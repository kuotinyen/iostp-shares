//
//  JobRepository.swift
//  RepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/28.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation

protocol LocalJobRepoProtocol {
    func fetchJob(by jobId: String) -> Job?
}

protocol RemoteJobRepoProtocol {
    func fetchJob(by jobId: String, completion: @escaping (Result<Job>) -> ())
}

class JobRepository {
    
    var localRepo: LocalJobRepoProtocol!
    var remoteRepo: RemoteJobRepoProtocol!
    
    init(localRepository: LocalJobRepoProtocol, remoteRepository: RemoteJobRepoProtocol) {
        self.localRepo = localRepository
        self.remoteRepo = remoteRepository
    }
    
    public func fetchJob(by jobId: String, completion: @escaping (Result<Job>) -> ()) {
        
        if let localJob = localRepo.fetchJob(by: jobId) {
            completion(.success(localJob))
            
            let shouldFetchFromRemote = TimestampManger.isJobExpired(timestamp: localJob.timestamp)
            if (!shouldFetchFromRemote) { return }
        }
        remoteRepo.fetchJob(by: jobId, completion: completion)
    }
}

class RepositoryFactory {
    static func provideJobRepository() -> JobRepository {
        return JobRepository(localRepository: RealmDB.shared, remoteRepository: JobsAPI.shared)
    }
}
