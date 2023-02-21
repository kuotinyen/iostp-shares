//
//  TimelyWidget.swift
//  TimelyWidget
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: "☀️")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), data: "💎")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let items = [(0, "🥚"), (1, "🌱"), (2, "🌿"), (3, "🌲")]

        let currentDate = Date()
        for item in items {
            let entryDate = Calendar.current.date(byAdding: .minute, value: item.0, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, data: item.1)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimelyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            Text(entry.date, style: .time)
            Text(entry.data)
        }
    }
}

struct TimelyWidget: Widget {
    let kind: String = "TimelyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimelyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TimelyWidget_Previews: PreviewProvider {
    static var previews: some View {
        TimelyWidgetEntryView(entry: SimpleEntry(date: Date(), data: "🌱"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
