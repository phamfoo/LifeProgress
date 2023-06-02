import Defaults
import SwiftUI
import WidgetKit

struct LifeProgressWidgetEntryView: View {
    @Default(.profileSetupCompleted) var profileSetupCompleted
    @Default(.birthday) private var birthday
    @Default(.lifeExpectancy) private var lifeExpectancy

    var body: some View {
        if profileSetupCompleted {
            LifeProgressWidgetView(life: life)
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

struct LifeProgressWidgetView: View {
    var life: Life

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if #available(iOS 16, *), widgetFamily == .accessoryCircular {
            AccessoryCircularWidgetView(life: life)
        } else if widgetFamily == .systemSmall {
            SystemSmallWidgetView(life: life)
        } else if widgetFamily == .systemMedium {
            SystemMediumWidgetView(life: life)
        } else {
            SystemLargeWidgetView(life: life)
        }
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

                Text("**\(life.numberOfWeeksSpent)** wks spent")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("**\(life.numberOfWeeksLeft)** wks left")
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

            Text("**\(life.numberOfWeeksLeft)** wks left")
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
                "**\(life.numberOfWeeksSpent)** wks spent • **\(life.numberOfWeeksLeft)** wks left"
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

        Group {
            LifeProgressWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            LifeProgressWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            LifeProgressWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
