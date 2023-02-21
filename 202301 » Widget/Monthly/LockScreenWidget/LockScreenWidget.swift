//
//  LockScreenWidget.swift
//  LockScreenWidget
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("🧑🏻‍💻iOSTP：Widget")
    }
}

//struct LockScreenWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Image(uiImage: image)
//            .resizable()
//            .scaledToFit()
//    }
//    
//    var image: UIImage {
//        let data = try! Data(contentsOf: URL(string: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/cf47f9fac4ed3037ff2a8ea83204e32aff8fb5f3.png")!)
//        return UIImage(data: data)!
//    }
//}

struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
