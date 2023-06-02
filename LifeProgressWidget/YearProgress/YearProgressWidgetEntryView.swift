import Defaults
import SwiftUI
import WidgetKit

struct YearProgressWidgetEntryView: View {
    @Default(.profileSetupCompleted) var profileSetupCompleted
    @Default(.birthday) private var birthday
    @Default(.lifeExpectancy) private var lifeExpectancy

    var body: some View {
        if profileSetupCompleted {
            YearProgressWidgetView(life: life)
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

struct YearProgressWidgetView: View {
    var life: Life

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if #available(iOS 16, *), widgetFamily == .accessoryCircular {
            AccessoryCircularWidgetView(life: life)
        } else if #available(iOS 16, *), widgetFamily == .accessoryRectangular {
            AccessoryRectangularWidgetView(life: life)
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
private struct AccessoryRectangularWidgetView: View {
    var life: Life

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Image(systemName: "square.grid.4x3.fill")

                Text("Current Year")
                    .font(.headline)
            }

            ProgressView(value: life.currentYearProgress) {
                HStack {
                    Text("\(life.currentYearProgressFormattedString)%")
                        .font(.headline)
                    Spacer()

                    Text("\(life.currentYearRemainingWeeks) wks left")
                }
            }
        }
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
        .padding()
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
                "**\(life.weekOfYear)** weeks spent • **\(life.currentYearRemainingWeeks)** weeks left"
            )
            .font(.subheadline)
            .foregroundColor(.secondary)

            YearCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.top, 8)
        }
        .padding()
    }
}

struct YearProgressWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let life = Life.example

        Group {
            if #available(iOS 16, *) {
                YearProgressWidgetView(life: life)
                    .previewContext(
                        WidgetPreviewContext(family: .accessoryCircular)
                    )

                YearProgressWidgetView(life: life)
                    .previewContext(
                        WidgetPreviewContext(family: .accessoryRectangular)
                    )
            }

            YearProgressWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            YearProgressWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            YearProgressWidgetView(life: life)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
