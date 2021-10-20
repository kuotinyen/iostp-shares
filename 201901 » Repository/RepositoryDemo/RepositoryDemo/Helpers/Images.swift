//
//  Images.swift
//  SingleSourceRepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/24.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import ImageProvider

extension ImageKeys {
    
    // Navigation
    static let navMenuIcon = ImageKey(rawValue: "navMenuIcon")
    static let navSaveIcon = ImageKey(rawValue: "navSaveIcon")
    static let navFilterIcon = ImageKey(rawValue: "navfilterIcon")
    static let navShareIcon = ImageKey(rawValue: "navShareIcon")
    
    // JobListCell
    static let salaryIcon = ImageKey(rawValue: "salaryIcon")
    static let collectIcon = ImageKey(rawValue: "collectIcon")
    static let collectIconSel = ImageKey(rawValue: "collectIconSel")
    
    // ShowJobPage
    static let mapIcon = ImageKey(rawValue: "mapIcon")
}

let Images = ImageProvider.shared
