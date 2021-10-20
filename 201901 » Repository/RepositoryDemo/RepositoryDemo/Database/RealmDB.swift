//
//  RealmDB.swift
//  RepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/28.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmDB: LocalJobRepoProtocol {
    
    typealias DBTaskCompletion = (() -> Void)?
    
    private init() {}
    static let shared = RealmDB()
    
    private let realm = try! Realm()
}

// ----------------------------------------------------------------------------------
/// Save / Fetch Job
//  MARK: - Save / Fetch Job
// ----------------------------------------------------------------------------------

extension RealmDB {
    
    public func fetchJob(by jobId: String) -> Job? {
        return self.realm.objects(Realm_Job.self).filter("jobId = '\(jobId)'").first?.entity
    }
    
    public func puts(_ jobs: [Job], completion: DBTaskCompletion = nil) {
        jobs.forEach { put($0) }
        completion?()
    }
    
    public func put(_ job: Job, completion: DBTaskCompletion = nil) {
        
        if let localJob = updatedLocalJob(with: job) {
            updateJob(localJob, completion: completion)
        } else {
            updateJob(job, completion: completion)
        }
    }
    
    private func updatedLocalJob(with job: Job) -> Job? {
        var localJob = RealmDB.shared.fetchJob(by: job.jobId)
        
        if localJob == nil {
            return nil
        }
        
        if let requirement = job.requirement {
            localJob?.requirement = requirement
            localJob?.timestamp = job .timestamp
        }
        
        return localJob
    }
    
    private func updateJob(_ job: Job,  completion: DBTaskCompletion = nil) {
        let realmJob = Realm_Job(job: job)
        
        try! self.realm.write {
            self.realm.add(realmJob, update: true)
            completion?()
        }
        
    }
}
