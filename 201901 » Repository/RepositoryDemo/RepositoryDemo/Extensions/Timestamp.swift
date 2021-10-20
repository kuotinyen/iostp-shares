//
//  ExpiredJobCheck.swift
//  RepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/28.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import Foundation

typealias Timestamp = Int

class TimestampManger {
    
    static func isJobExpired(timestamp: Timestamp) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        print("last fetch date: \(dformatter.string(from: date))")
        
        let timeIntervalSinceNow = date.timeIntervalSinceNow
        let secondsLimit = 60 // minute
        return Int(-timeIntervalSinceNow) > secondsLimit
    }
    
}

extension Timestamp {
    
    static func current() -> Timestamp {
        let now = Date()
        let timeInterval = now.timeIntervalSince1970
        return Timestamp(timeInterval)
    }
}

