//
//  CombineAppDrivenAndAfterDate.swift
//  CombineAppDrivenAndAfterDate
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), points: .zero)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), points: .zero)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let points = UserDefaults.demo.double(forKey: "points")

        let entry = SimpleEntry(date: currentDate, points: points)
        let currentDateString = currentDate.date2String(dateFormat: "yyyy/MM/dd HH:mm:ss")
        entries.append(entry)

        let firstTimeToday = Calendar.current.startOfDay(for: currentDate)
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: firstTimeToday)!
        let nextDate = Calendar.current.date(bySetting: .hour, value: 10, of: tomorrowDate)!
        let nextDateString = nextDate.date2String(dateFormat: "yyyy/MM/dd HH:mm:ss")
        let nextEntry = SimpleEntry(date: nextDate, points: .zero)
        entries.append(nextEntry)
        
        print("#### [Widget] currentDate: \(currentDateString), nextDate: \(nextDateString)")
        
        if nextDate == Date() {
            UserDefaults.demo.set(0.0, forKey: "points")
            WidgetCenter.shared.reloadAllTimelines()
        }
        
//        print("#### [Timeline] entries: \(entries)")

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let points: Double
}

struct CombineAppDrivenAndAfterDateEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("Points: \(entry.points)")
        // not work for now,
        // other people too: https://developer.apple.com/forums/thread/672282
//            .onAppear {
//                let today = Calendar.current.startOfDay(for: Date())
//
//                if let lastDay = UserDefaults.demo.object(forKey: "last-day") as? Date {
//                    if Calendar.current.isDate(today, inSameDayAs: lastDay) {
//                        // lastDay is today, no-op
//                    } else {
//                        // lastDay is yesterday, should make points set to zero.
//                        UserDefaults.demo.set(Double(0.0), forKey: "points")
//                        WidgetCenter.shared.reloadAllTimelines()
//                        print("#### reset points to zero")
//                    }
//                } else {
//                    // never save a date, no-op
//                }
//
//                UserDefaults.demo.set(today, forKey: "last-day")
//            }
    }
}

struct CombineAppDrivenAndAfterDate: Widget {
    let kind: String = "CombineAppDrivenAndAfterDate"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CombineAppDrivenAndAfterDateEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CombineAppDrivenAndAfterDate_Previews: PreviewProvider {
    static var previews: some View {
        CombineAppDrivenAndAfterDateEntryView(entry: SimpleEntry(date: Date(), points: .zero))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Date {
    func date2String(dateFormat:String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(identifier:"Asia/Taipei")
        formatter.locale = Locale.init(identifier: "zh_Hant_TW")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
}
