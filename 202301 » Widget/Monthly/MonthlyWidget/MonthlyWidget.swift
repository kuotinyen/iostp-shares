//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: "♻️")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), data: "💎")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        print("#### currentDate: \(currentDate)")
        
        // demo 1

        
        // demo2
        let entry = SimpleEntry(date: Date(), data: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/cf47f9fac4ed3037ff2a8ea83204e32aff8fb5f3.png")
        entries.append(entry)
        
        print("#### entries: \(entries)")

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: String
}

struct MonthlyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            Text(entry.date, style: .time)
//            Text(entry.emoji)
            // AsyncImage(url: URL(string: entry.data))
            // will not work.
        }
    }
}

struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MonthlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyWidgetEntryView(entry: SimpleEntry(date: Date(), data: "🌱"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
