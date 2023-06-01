import Defaults
import SwiftUI
import WidgetKit

struct YearProgressWidgetEntryView: View {
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
                    .padding()
            } else if widgetFamily == .systemMedium {
                SystemMediumWidgetView(life: life)
                    .padding()
            } else {
                SystemLargeWidgetView(life: life)
                    .padding()
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
        Gauge(value: life.currentYearProgress) {
            Text("Year")
                .font(.headline)
        } currentValueLabel: {
            Text("\(life.currentYearProgressFormattedString)%")
        }
        .gaugeStyle(.accessoryCircular)
    }
}

private struct SystemMediumWidgetView: View {
    var life: Life

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text("\(life.currentYearProgressFormattedString)%")
                    .font(.title)
                    .bold()

                Text("**\(life.weekOfYear)** weeks spent")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("**\(life.currentYearRemainingWeeks)** weeks left")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            YearCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.leading)
        }
    }
}

private struct SystemSmallWidgetView: View {
    var life: Life

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(life.currentYearProgressFormattedString)%")
                .font(.headline)

            Text("**\(life.currentYearRemainingWeeks)** weeks left")
                .font(.footnote)
                .foregroundColor(.secondary)

            YearCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.top, 8)
        }
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
                "**\(life.weekOfYear)** weeks spent • **\(life.currentYearRemainingWeeks)** weeks left"
            )
            .font(.subheadline)
            .foregroundColor(.secondary)

            YearCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.top, 8)
        }
    }
}

struct YearProgressWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let life = Life.example

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
