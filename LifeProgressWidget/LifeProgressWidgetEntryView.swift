import Defaults
import SwiftUI
import WidgetKit

struct LifeProgressWidgetEntryView: View {
    @Default(.profileSetupCompleted) var profileSetupCompleted
    @Default(.birthday) private var birthday
    @Default(.lifeExpectancy) private var lifeExpectancy

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if profileSetupCompleted {
            if #available(iOS 16, *), widgetFamily == .accessoryCircular {
                AccessoryCircularWidgetView(life: life)
            } else if widgetFamily == .systemSmall {
                SystemSmallWidgetView(life: life)
            } else if widgetFamily == .systemMedium {
                SystemMediumWidgetView(life: life)
            } else {
                SystemLargeWidgetView(life: life)
            }
        } else {
            VStack {
                Text("Calendar not available")
                Text("Tap to setup")
                    .font(.headline)
                    .padding(.top)
            }
        }
    }

    private var life: Life {
        return Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
    }
}

@available(iOS 16, *)
private struct AccessoryCircularWidgetView: View {
    var life: Life

    var body: some View {
        Gauge(value: life.progress) {
            Text("Life")
                .font(.headline)
        } currentValueLabel: {
            Text("\(life.progressFormattedString)%")
        }
        .gaugeStyle(.accessoryCircular)
    }
}

private struct SystemMediumWidgetView: View {
    var life: Life

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text("\(life.progressFormattedString)%")
                    .font(.title)
                    .bold()

                Text("**\(life.numberOfWeeksSpent)** weeks spent")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("**\(life.numberOfWeeksLeft)** weeks left")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            SimplifiedLifeCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.leading)
        }
        .padding()
    }
}

private struct SystemSmallWidgetView: View {
    var life: Life

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(life.progressFormattedString)%")
                .font(.headline)

            Text("**\(life.numberOfWeeksLeft)** weeks left")
                .font(.footnote)
                .foregroundColor(.secondary)

            SimplifiedLifeCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.top, 8)
        }
        .padding()
    }
}

private struct SystemLargeWidgetView: View {
    var life: Life

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(life.progressFormattedString)%")
                .font(.title)
                .bold()

            Text(
                "**\(life.numberOfWeeksSpent)** weeks spent • **\(life.numberOfWeeksLeft)** weeks left"
            )
            .font(.subheadline)
            .foregroundColor(.secondary)

            SimplifiedLifeCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.top, 8)
        }
        .padding()
    }
}

struct LifeProgressWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let life = Life.example

        // TODO: Preview LifeProgressWidgetEntryView directly after
        // https://developer.apple.com/forums/thread/703143 is fixed
        Group {
            SystemSmallWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            SystemMediumWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            SystemLargeWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .padding()
    }
}
