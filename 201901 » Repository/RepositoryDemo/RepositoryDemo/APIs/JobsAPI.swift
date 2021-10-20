//
//  JobsAPI.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/24.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation
import Alamofire

let usingExistFcmToken = true

final class JobsAPI: RemoteJobRepoProtocol {
    
    private init() {}
    static let shared = JobsAPI()
    
    lazy var headers = ["x-user": getFCMToken()]
        
    fileprivate func getFCMToken() -> String {
        
        if usingExistFcmToken {
            return fixedFcmToken
        }
        
        guard let fcmToken = DB[.fcmToken] as? String else { return "" }
        return fcmToken
    }
}

// ----------------------------------------------------------------------------------
/// Fetch Hot-Jobs
//  MARK: - Fetch Hot-Jobs
// ----------------------------------------------------------------------------------

extension JobsAPI {
    
    func fetchHotJobs(with params: Parameters, completion: @escaping(PagingResult<[Job], Int>) -> ()) {
        let endpoint = "\(baseUrl)/jobs/hot"
        
        Alamofire.request(endpoint, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                
                guard let JSON = response.result.value else {
                    return
                }
                
                guard let data = try? JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted) else {
                    return
                }
                
                guard let hotJobsModel = try? JSONDecoder().decode(JobsResponseModel.self, from: data) else {
                    completion(.failure(APIError.formatError))
                    return
                }
                
                let jobs = hotJobsModel.jobs
                let totalCount = hotJobsModel.totalCount
                
                RealmDB.shared.puts(jobs, completion: {
                    completion(.success(jobs, totalCount))
                })
                
            case .failure(let error):
                print("failed to get hot-jobs.")
                print("error message is \(error)")
                
                completion(.failure(error))
            }
        }
    }
}

// ----------------------------------------------------------------------------------
/// Fetch Job
//  MARK: - Fetch Job
// ----------------------------------------------------------------------------------

extension JobsAPI {
    
    func fetchJob(by jobId: String, completion: @escaping (Result<Job>) -> ()) {
        
        let endpoint = "\(baseUrl)/jobs/\(jobId)"
        
        Alamofire.request(endpoint, method: .get, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                guard let JSON = response.result.value else {
                    return
                }
                
                guard let data = try? JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted) else {
                    return
                }
                
                guard let job = try? JSONDecoder().decode(Job.self, from: data) else {
                    return
                }
                
                RealmDB.shared.put(job, completion: {
                    completion(.success(job))
                })
                
            case .failure(let error):
                print("failed to get job.")
                print("error message is \(error)")
                
                completion(.failure(error))
            }
        }
        
    }
    
}


// ----------------------------------------------------------------------------------
/// Definitions
//  MARK: - Definitions
// ----------------------------------------------------------------------------------

enum APIError: Error {
    case serverDown
    case formatError
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum PagingResult<Value, TotalCount> {
    case success(Value, Int)
    case failure(Error)
}

enum PagingKeyResult<Value, TotalCount, Key> {
    case success(Value, Int, String)
    case failure(Error)
}
