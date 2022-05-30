import Defaults
import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(
        for configuration: ConfigurationIntent,
        in _: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(
        for configuration: ConfigurationIntent,
        in _: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(
                byAdding: .hour,
                value: hourOffset,
                to: currentDate
            )!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CalendarWidgetEntryView: View {
    var entry: Provider.Entry
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let birthday = birthday,
               let lifeProgress = LifeProgress(
                   birthday: birthday,
                   lifeExpectancy: lifeExpectancy
               )
            {
                Text("\(lifeProgress.formattedProgress)%")
                    .font(.headline)
                LifeCalendarWidgetView()
                    .aspectRatio(1, contentMode: .fit)
            } else {
                VStack {
                    Text("Calendar not available")
                    Text("Tap to setup")
                        .font(.headline)
                        .padding([.top])
                }
            }
        }
        .padding()
    }
}

@main
struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarWidgetEntryView(entry: SimpleEntry(date: Date(),
                                                       configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            CalendarWidgetEntryView(entry: SimpleEntry(date: Date(),
                                                       configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
        }
    }
}
