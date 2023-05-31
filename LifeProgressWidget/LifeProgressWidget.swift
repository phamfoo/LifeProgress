import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(
        in _: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(
        in _: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        // Create a timeline entry for "now."
        let date = Date()
        let entry = SimpleEntry(
            date: date
        )

        let tomorrow = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: date
        )!

        let nextUpdateDate = Calendar.current.date(
            bySettingHour: 0, minute: 0, second: 0, of: tomorrow
        )!

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextUpdateDate)
        )

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

@main
struct LifeProgressWidget: Widget {
    let kind: String = "LifeProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            LifeProgressWidgetEntryView()
        }
        .configurationDisplayName("Life Progress")
        .description("Friendly reminder that you're not gonna live forever.")
        .supportedFamilies(supportedFamilies)
    }

    private var supportedFamilies: [WidgetFamily] {
        var widgetFamilies: [WidgetFamily] = [
            .systemSmall,
            .systemLarge,
            .systemExtraLarge,
        ]

        if #available(iOS 16, *) {
            widgetFamilies.append(.accessoryCircular)
        }

        return widgetFamilies
    }
}

struct LifeProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        LifeProgressWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
