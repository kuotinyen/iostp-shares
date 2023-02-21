//
//  AfterDateWidget.swift
//  AfterDateWidget
//
//  Created by Ting Yen Kuo on 2023/1/10.
//

import WidgetKit
import SwiftUI

class Dummy {
    static let shared = Dummy()
    var isFirstLoad = true
}

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
                if Dummy.shared.isFirstLoad {
                    let 妙1Data = try Data(contentsOf: URL(string: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/cf47f9fac4ed3037ff2a8ea83204e32aff8fb5f3.png")!)
                    let 妙1Entry = SimpleEntry(date: currentDate, image: UIImage(data: 妙1Data)!)
                    entries.append(妙1Entry)
                    
                    let 妙2Data = try Data(contentsOf: URL(string: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/3245e4f8c04aa0619cb31884dbf123c6918b3700.png")!)
                    let 妙2Date = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                    let 妙2Entry = SimpleEntry(date: 妙2Date, image: UIImage(data: 妙2Data)!)
                    entries.append(妙2Entry)
                } else {
                    let 火1Data = try Data(contentsOf: URL(string: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/d0ee81f16175c97770192fb691fdda8da1f4f349.png")!)
                    let 火1Entry = SimpleEntry(date: currentDate, image: UIImage(data: 火1Data)!)
                    entries.append(火1Entry)
                    
                    let 火2Data = try Data(contentsOf: URL(string: "https://tw.portal-pokemon.com/play/resources/pokedex/img/pm/285395ca77d82861fd30cea64567021a50c1169c.png")!)
                    let 火2Date = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                    let 火2Entry = SimpleEntry(date: 火2Date, image: UIImage(data: 火2Data)!)
                    entries.append(火2Entry)
                }
                
                print("#### entries: \(entries)")
                Dummy.shared.isFirstLoad = false
                
                let date = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
                let timeline = Timeline(entries: entries, policy: .after(date))
                completion(timeline)
            } catch {
                
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct AfterDateWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFit()
//            Text(entry.date, style: .time)
    }
}

struct AfterDateWidget: Widget {
    let kind: String = "AfterDateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AfterDateWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AfterDateWidget_Previews: PreviewProvider {
    static var previews: some View {
        AfterDateWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage.checkmark))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
