//
//  UserDefaults+enum.swift
//  ujob
//
//  Created by TING YEN KUO on 2019/1/3.
//  Copyright © 2019 Ting-Yen, Kuo. All rights reserved.
//

import Foundation

var DB: UserDefaults {
    get {
        return UserDefaults.standard
    }
}

extension UserDefaults {
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        
        set {
            set(newValue, forKey: key)
        }
    }
    
    subscript(key: keys) -> Any? {
        get {
            return object(forKey: key.rawValue)
        }
        
        set {
            set(newValue, forKey: key.rawValue)
        }
    }
}

extension UserDefaults {
    enum keys: String {
        case fcmToken
    }
    
    static func set(_ value: Any, forKey key: keys) {
        let key = key.rawValue
        DB.set(value, forKey: key)
    }
    
    static func object(forKey key: keys) -> Any? {
        let key = key.rawValue
        return DB.object(forKey: key)
    }
}

