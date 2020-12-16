//
//  UBikeStation.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

struct UBikeStation: Codable {
    var id: String
    var chineseName: String
    var totalSpacesCount: Int
    var currentAvailableSpacesCount: Int
    var chineseArea: String
    var lastModifyTimeString: String
    var latitude: Double
    var longitude: Double
    var chineseAddress: String
    var englishArea: String
    var englishName: String
    var englishAddress: String
    var currentEmptySpacesCount: Int
    var isClosed: Bool
    
    init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try vals.decode(String.self, forKey: CodingKeys.id)
        chineseName = try vals.decode(String.self, forKey: CodingKeys.chineseName)
        
        if let totalSpacesCountString = try? vals.decode(String.self, forKey: CodingKeys.totalSpacesCount), let totalSpaceCount = Int(totalSpacesCountString) {
            self.totalSpacesCount = totalSpaceCount
        } else {
            self.totalSpacesCount = 0
        }
        
        if let currentAvailableSpacesCountString = try? vals.decode(String.self, forKey: CodingKeys.currentAvailableSpacesCount), let currentAvailableSpacesCount = Int(currentAvailableSpacesCountString) {
            self.currentAvailableSpacesCount = currentAvailableSpacesCount
        } else {
            self.currentAvailableSpacesCount = 0
        }
        
        chineseArea = try vals.decode(String.self, forKey: CodingKeys.chineseArea)
        
        lastModifyTimeString = try vals.decode(String.self, forKey: CodingKeys.lastModifyTimeString)
        
        if let latitudeString = try? vals.decode(String.self, forKey: CodingKeys.latitude), let latitude = Double(latitudeString) {
            self.latitude = latitude
        } else {
            self.latitude = 0
        }
        
        if let longitudeString = try? vals.decode(String.self, forKey: CodingKeys.longitude), let longitude = Double(longitudeString) {
            self.longitude = longitude
        } else {
            self.longitude = 0
        }
        
        chineseAddress = try vals.decode(String.self, forKey: CodingKeys.chineseAddress)
        englishArea = try vals.decode(String.self, forKey: CodingKeys.englishArea)
        englishName = try vals.decode(String.self, forKey: CodingKeys.englishName)
        englishAddress = try vals.decode(String.self, forKey: CodingKeys.englishAddress)
        
        if let currentEmptySpacesCountString = try? vals.decode(String.self, forKey: CodingKeys.currentEmptySpacesCount), let currentEmptySpacesCount = Int(currentEmptySpacesCountString) {
            self.currentEmptySpacesCount = currentEmptySpacesCount
        } else {
            self.currentEmptySpacesCount = 0
        }
        
        if let isClosedString = try? vals.decode(String.self, forKey: CodingKeys.isClosed), let isClosed = Int(isClosedString) == 1 ? true : false {
            self.isClosed = isClosed
        } else {
            self.isClosed = false
        }
    }

    init(id: String,
        chineseName: String,
        totalSpacesCount: Int,
        currentAvailableSpacesCount: Int,
        chineseArea: String,
        lastModifyTimeString: String,
        latitude: Double,
        longitude: Double,
        chineseAddress: String,
        englishArea: String,
        englishName: String,
        englishAddress: String,
        currentEmptySpacesCount: Int,
        isClosed: Bool) {
        self.id = id
        self.chineseName = chineseName
        self.totalSpacesCount = totalSpacesCount
        self.currentAvailableSpacesCount = currentAvailableSpacesCount
        self.chineseArea = chineseArea
        self.lastModifyTimeString = lastModifyTimeString
        self.latitude = latitude
        self.longitude = longitude
        self.chineseAddress = chineseAddress
        self.englishArea = englishArea
        self.englishName = englishName
        self.englishAddress = englishAddress
        self.currentEmptySpacesCount = currentEmptySpacesCount
        self.isClosed = isClosed
    }

    static func generateEmptyStation() -> Self {
        return .init(id: "", chineseName: "", totalSpacesCount: -1, currentAvailableSpacesCount: -1, chineseArea: "", lastModifyTimeString: "", latitude: -1, longitude: -1, chineseAddress: "", englishArea: "", englishName: "", englishAddress: "", currentEmptySpacesCount: -1, isClosed: false)
    }
}

// MARK: - CodingKeys

extension UBikeStation {
    enum CodingKeys: String, CodingKey {
        case id = "sno"
        case chineseName = "sna"
        case totalSpacesCount = "tot"
        case currentAvailableSpacesCount = "sbi"
        case chineseArea = "sarea"
        case lastModifyTimeString = "mday"
        case latitude = "lat"
        case longitude = "lng"
        case chineseAddress = "ar"
        case englishArea = "sareaen"
        case englishName = "snaen"
        case englishAddress = "aren"
        case currentEmptySpacesCount = "bemp"
        case isClosed = "act"
    }
}


