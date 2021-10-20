//
//  JobPinModel.swift
//  ujob
//
//  Created by TING YEN KUO on 2018/9/24.
//  Copyright © 2018年 TING YEN KUO. All rights reserved.
//

import MapKit

class JobPinModel: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var identifier: String?
    var job: Job?
    var title: String?
    var subtitle: String?
    
    init(with job: Job) {
        
        self.identifier = job.jobId
        self.job = job
        self.title = job.companyName
        self.subtitle = job.salary
        
        if let gps = job.gps {
            self.coordinate = CLLocationCoordinate2D(latitude: gps.lat, longitude: gps.lon)
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
    }
}

