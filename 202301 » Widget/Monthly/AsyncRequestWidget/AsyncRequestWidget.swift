//
//  AsyncRequestWidget.swift
//  AsyncRequestWidget
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage.checkmark)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: UIImage.checkmark)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: URL(string: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/cf47f9fac4ed3037ff2a8ea83204e32aff8fb5f3.png")!)
                let entry = SimpleEntry(date: currentDate, image: UIImage(data: data)!)
                entries.append(entry)
                print("#### entry: \(entry)")
                
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } catch {
                
            }
        }
    }
}

#warning("You can not fetch remote image in Widget's SwiftUI View, should fetch inside 💎TimelineProvider.")
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let url: String
//}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct AsyncRequestWidgetEntryView : View {
    var entry: Provider.Entry
    @State var apiData: String = ""

    var body: some View {
        VStack {
            Image(uiImage: entry.image)
                .resizable()
                .scaledToFit()
//            Text(entry.date, style: .time)
            Text(apiData)
        }.onAppear {
            let url = URL(string: "https://reqres.in/api/users?page=1")!
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let content = String(data: data, encoding: .utf8) {
                        print("####", content)
                        DispatchQueue.main.async {
                            self.apiData = content
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct AsyncRequestWidget: Widget {
    let kind: String = "AsyncRequestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AsyncRequestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AsyncRequestWidget_Previews: PreviewProvider {
    static var previews: some View {
        AsyncRequestWidgetEntryView(entry:
                                        SimpleEntry(date: Date(), image: UIImage.checkmark)
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
