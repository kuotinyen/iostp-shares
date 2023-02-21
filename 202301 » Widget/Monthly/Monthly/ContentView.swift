//
//  ContentView.swift
//  Monthly
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import SwiftUI
import CoreData
import WidgetKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("imageUrl", store: .demo) var imageUrl = ""
    @AppStorage("points", store: .demo) var points: Double = 0.0
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            Spacer()
            Button {
                imageUrl = "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/5794f0251b1180998d72d1f8568239620ff5279c.png"
                WidgetCenter.shared.reloadAllTimelines()
            } label: {
                Text("傑尼龜進化！")
            }
            
            Spacer()
            
            Button {
                points += 10
                WidgetCenter.shared.reloadAllTimelines()
                print("#### [view] points: \(points)")
            } label: {
                Text("增加 10 點數")
            }
            Spacer()
        }.onChange(of: scenePhase) { newPhase in
            let today = Calendar.current.startOfDay(for: Date())

            if let lastDay = UserDefaults.demo.object(forKey: "last-day") as? Date {
                if Calendar.current.isDate(today, inSameDayAs: lastDay) {
                    // lastDay is today, no-op
                    print("#### [View] last day is today")
                } else {
                    // lastDay is yesterday, should make points set to zero.
                    points = 0
                    WidgetCenter.shared.reloadAllTimelines()
                    print("#### [View] reset points to zero")
                }
            } else {
                // never save a date, no-op
                print("#### [View] never save a day.")
            }
            UserDefaults.demo.set(today, forKey: "last-day")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
