//
//  AppDrivenWidget.swift
//  AppDrivenWidget
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: .checkmark)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: .checkmark)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        do {
            guard let urlString = UserDefaults(suiteName: "group.tkyen.demo")?.string(forKey: "imageUrl") else { return }
            print("#### [AppDriven] urlString: \(urlString)")
            let data = try Data(contentsOf: URL(string: urlString)!)
            let entry = SimpleEntry(date: currentDate, image: UIImage(data: data)!)
            entries.append(entry)
        } catch { }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct AppDrivenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFit()
    }
}

struct AppDrivenWidget: Widget {
    let kind: String = "AppDrivenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AppDrivenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AppDrivenWidget_Previews: PreviewProvider {
    static var previews: some View {
        AppDrivenWidgetEntryView(entry: SimpleEntry(date: Date(), image: .checkmark))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
