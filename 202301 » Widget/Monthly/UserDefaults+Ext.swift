//
//  UserDefaults+Ext.swift
//  Monthly
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import Foundation

extension UserDefaults {
    static var demo: UserDefaults {
        .init(suiteName: "group.tkyen.demo")!
    }
}
