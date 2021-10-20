//
//  Job.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/24.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation
import MapKit

struct Job: Codable {
    
    var jobId: String
    var companyName: String
    var title: String
    var salary: String
    var address: String
    var requirement: String?
    var companyImageString: String?
    var link: String?
    var gps: GPS?
    
    var isClosed: Bool?
    var isCollected: Bool = false
    var isBlocked: Bool = false
    var timestamp: Timestamp = 0
    
    enum CodingKeys: String, CodingKey {
        case jobId = "id"
        case title = "title"
        case companyName = "company"
        case companyImageString = "company_image"
        case salary = "price"
        case address = "address"
        case gps = "location"
        case link = "url"
        case isClosed = "is_closed"
        case requirement = "requirement"
        case isCollected = "is_collected"
    }
    
    init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: CodingKeys.self)
        
        jobId = try vals.decode(String.self, forKey: CodingKeys.jobId)
        companyName = try vals.decode(String.self, forKey: CodingKeys.companyName)
        title = try vals.decode(String.self, forKey: CodingKeys.title)
        salary = try vals.decode(String.self, forKey: CodingKeys.salary)
        address = try vals.decode(String.self, forKey: CodingKeys.address)
        
        if let val = try? vals.decode(String.self, forKey: CodingKeys.requirement) {
            requirement = val
        } else {
            requirement = nil
        }
        
        if let val = try? vals.decode(String.self, forKey: CodingKeys.companyImageString) {
            companyImageString = val
        } else {
            companyImageString = nil
        }
        
        if let val = try? vals.decode(String.self, forKey: CodingKeys.link) {
            link = val
        } else {
            link = nil
        }
        
        gps = try? vals.decode(GPS.self, forKey: CodingKeys.gps)
        
        if let val = try? vals.decode(Bool.self, forKey: CodingKeys.isClosed) {
            isClosed = val
        } else {
            isClosed = nil
        }
        
        isCollected = try vals.decode(Bool.self, forKey: CodingKeys.isCollected)
        
        timestamp = Timestamp.current()
    }
    
    init(jobId: String, title: String, companyName: String, companyImageString: String?,
         salary: String, address: String, link: String?, gps: GPS, isClosed: Bool, isCollected: Bool, isBlocked: Bool, requirement: String?, timestamp: Int) {
        
        self.jobId = jobId
        self.title = title
        self.companyName = companyName
        self.companyImageString = companyImageString
        self.salary = salary
        self.address = address
        self.link = link
        self.gps = gps
        self.isClosed = isClosed
        self.isCollected = isCollected
        self.isBlocked = isBlocked
        self.requirement = requirement
        self.timestamp = timestamp
    }
    
    static func empty() -> Job {
        return Job(jobId: "", title: "", companyName: "", companyImageString: nil, salary: "", address: "", link: nil, gps: GPS.init(lat: 0, lon: 0), isClosed: false, isCollected: false, isBlocked: false, requirement: nil, timestamp: 0)
    }
    
    func realmJob() -> Realm_Job {
        return Realm_Job(job: self)
    }
    
}

struct GPS: Codable {
    
    var lat: Double
    var lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
    
    init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            lat = try vals.decode(Double.self, forKey: CodingKeys.lat)
        } catch let error {
            print("lat error -> \(error)")
        }
        
        do {
            lon = try vals.decode(Double.self, forKey: CodingKeys.lon)
        } catch let error {
            print("lon error -> \(error)")
        }
        
        lat = try vals.decode(Double.self, forKey: CodingKeys.lat)
        lon = try vals.decode(Double.self, forKey: CodingKeys.lon)
    }
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}
