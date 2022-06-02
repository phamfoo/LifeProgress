import Defaults
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(
                byAdding: .hour,
                value: hourOffset,
                to: currentDate
            )!
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

struct LifeProgressWidgetEntryView: View {
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if let birthday = birthday,
           let lifeProgress = LifeProgress(
               birthday: birthday,
               lifeExpectancy: lifeExpectancy
           )
        {
            switch widgetFamily {
            case .systemMedium:
                HStack(alignment: .center) {
                    VStack {
                        Text("\(lifeProgress.formattedProgress)%")
                            .font(.title)
                            .bold()

                        let remainingWeeksText = try! AttributedString(
                            markdown: "**\(lifeProgress.remainingWeeks)** weeks left"
                        )
                        Text(remainingWeeksText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    LifeProgressView()
                        .clipShape(ContainerRelativeShape())
                        .padding([.leading])
                }
                .padding()
            case .systemSmall:
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(lifeProgress.formattedProgress)%")
                        .font(.headline)

                    let remainingWeeksText = try! AttributedString(
                        markdown: "**\(lifeProgress.remainingWeeks)** weeks left"
                    )
                    Text(remainingWeeksText)
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    LifeProgressView()
                        .clipShape(ContainerRelativeShape())
                        .padding([.top], 8)
                }
                .padding()
            default:
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(lifeProgress.formattedProgress)%")
                        .font(.title)
                        .bold()

                    let remainingWeeksText = try! AttributedString(
                        markdown: "**\(lifeProgress.remainingWeeks)** weeks left"
                    )
                    Text(remainingWeeksText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    LifeProgressView()
                        .clipShape(ContainerRelativeShape())
                        .padding([.top], 8)
                }
                .padding()
            }

        } else {
            VStack {
                Text("Calendar not available")
                Text("Tap to setup")
                    .font(.headline)
                    .padding([.top])
            }
        }
    }
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
    }
}

struct LifeProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        LifeProgressWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
