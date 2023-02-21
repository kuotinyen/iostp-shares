//
//  ContentView.swift
//  SettingsBundleDemo
//
//  Created by Ting Yen Kuo on 2023/2/21.
//

import SwiftUI
import Combine

// #1 SettingBundle + UserDefault
// #2 🐛SettingBundle default value
// #3 Muti-Value
// #4 Group
// #5 Title
// #6 API Environment switching demo

// #7 Hide debug settings from user.
// https://www.jianshu.com/p/784626ea052c
// or merge debug plist to release plist. (keyword: PlistBuddy)

struct ContentView: View {
    // #1-1
    // Subsribe UserDefaults change automatically.
//    @AppStorage("api-key") var apiKey: String?
    
    // #1-2
    // Subsribe UserDefaults change manually.
    @State var apiKey = UserDefaults.standard.apiKey
    
    // #3
    @AppStorage("currency") var currency: Int?
    
    // #5
    @AppStorage("app-version") var appVersion: String?
    
    // #6
    @AppStorage("api-environment") var apiEnvironment: Int?
    @State var api: String = BaseURL.stream.absoluteString
    
    
    var body: some View {
        VStack {
            Text(apiKey ?? "None")
            Text("\(currency ?? .zero)")
            Text(appVersion ?? "None")
            Text("\(apiEnvironment ?? .zero)")
            Text(api ?? "None")
        }
        .padding()
        .onAppear {
            // #2
            UserDefaults.standard.registerDefaultValueFromSettingBundle()
        }
        // #1-2
        .onReceive(
            NotificationCenter.default
                .publisher(for: UserDefaults.didChangeNotification)
                .receive(on: RunLoop.main)
        ) { _ in
            apiKey = UserDefaults.standard.apiKey
            api = BaseURL.stream.absoluteString
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
