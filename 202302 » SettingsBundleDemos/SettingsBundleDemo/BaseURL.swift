//
//  BaseURL.swift
//  SettingsBundleDemo
//
//  Created by Ting Yen Kuo on 2023/2/21.
//

import Foundation

struct Properties {
    static var streamBaseURL: BaseURL {
        .init(staging: URL(string: "stream-staging")!, production: URL(string: "stream-production")!)
    }
}

struct BaseURL {
    static var stream: URL { Properties.streamBaseURL.current }
    
    let staging: URL
    let production: URL
    
    var current: URL {
#if DEBUG
        let rawValue = UserDefaults.standard.integer(forKey: "api-environment")
        switch rawValue {
        case 0: return production
        case 1: return staging
        default: return production
        }
#else
        return production
#endif
    }
}
