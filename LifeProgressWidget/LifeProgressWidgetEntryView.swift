import Defaults
import SwiftUI
import WidgetKit

struct LifeProgressWidgetEntryView: View {
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday
    @Default(.profileSetupCompleted) var profileSetupCompleted

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if profileSetupCompleted {
            let life = Life(
                birthday: birthday,
                lifeExpectancy: lifeExpectancy
            )!

            switch widgetFamily {
            case .systemMedium:
                SystemMediumWidgetView(life: life)
                    .padding()
            case .systemSmall:
                SystemSmallWidgetView(life: life)
                    .padding()
            default:
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
}

struct SystemMediumWidgetView: View {
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
    }
}

struct SystemSmallWidgetView: View {
    var life: Life

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(life.progressFormattedString)%")
                .font(.headline)

            Text("**\(life.numberOfWeeksLeft)** weeks left")
                .font(.footnote)
                .foregroundColor(.secondary)

            SimplifiedLifeCalendarView(life: life)
                .clipShape(ContainerRelativeShape())
                .padding(.top, 8)
        }
    }
}

struct SystemLargeWidgetView: View {
    var life: Life

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
