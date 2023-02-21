//
//  MonthlyApp.swift
//  Monthly
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import SwiftUI

@main
struct MonthlyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
