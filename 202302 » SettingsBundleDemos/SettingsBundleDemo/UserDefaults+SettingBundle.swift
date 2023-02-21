//
//  SettingBundle.swift
//  SettingsBundleDemo
//
//  Created by Ting Yen Kuo on 2023/2/21.
//

import Foundation

enum SettingBundleKeys: String {
    case apiKey = "api-key"
}

extension UserDefaults {
    @objc dynamic var apiKey: String? {
        get { string(forKey: SettingBundleKeys.apiKey.rawValue) }
        set { set(newValue, forKey: SettingBundleKeys.apiKey.rawValue) }
    }
    
    func registerDefaultValueFromSettingBundle() {
        guard let path = Bundle.main.path(forResource: "Root", ofType: "plist", inDirectory: "Settings.bundle") else { return }
        guard let settings = NSDictionary(contentsOfFile: path) else { return }
        guard let prefs = settings.object(forKey: "PreferenceSpecifiers") as? [NSDictionary] else { return }
        
        var defaults: [String: Any] = [:]
        
        for pref in prefs {
            guard let prefKey = pref.object(forKey: "Key") as? String else { continue }
            let defaultValue = pref.object(forKey: "DefaultValue")
            defaults[prefKey] = defaultValue
        }
        
        register(defaults: defaults)
    }
}
