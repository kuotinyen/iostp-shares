//
//  Realm_Job.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/25.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import RealmSwift

class Realm_Job: Object {
    
    @objc dynamic var jobId: String = ""
    @objc dynamic var companyName: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var salary: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var requirement: String? = nil
    @objc dynamic var companyImageString: String? = nil
    @objc dynamic var link: String? = nil
    
    @objc dynamic var lat: Double = 0
    @objc dynamic var lon: Double = 0
    
    @objc dynamic var isClosed: Bool = false
    @objc dynamic var isCollected: Bool = false
    @objc dynamic var isBlocked: Bool = false
    @objc dynamic var timestamp: Int = -1
    
    override static func primaryKey() -> String? {
        return "jobId"
    }
    
    convenience init(job: Job) {
        self.init()
        
        self.jobId = job.jobId
        self.companyName = job.companyName
        self.title = job.title
        self.salary = job.salary
        self.address = job.address
        self.requirement = job.requirement
        self.companyImageString = job.companyImageString
        self.link = job.link
        
        if let gps = job.gps {
            self.lat = gps.lat
            self.lon = gps.lon
        }
        
        self.isClosed = job.isClosed ?? false
        self.isCollected = job.isCollected
        self.isBlocked = job.isBlocked
        self.timestamp = job.timestamp
    }
    
    var entity: Job {
        
        return Job(jobId: jobId,
                   title: title,
                   companyName: companyName,
                   companyImageString: companyImageString,
                   salary: salary, address: address,
                   link: link,
                   gps: GPS(lat: lat, lon: lon),
                   isClosed: isClosed,
                   isCollected: isCollected,
                   isBlocked: isBlocked,
                   requirement: requirement,
                   timestamp: timestamp)
        
    }
}

