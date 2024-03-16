import SwiftUI
import WidgetKit

struct YearProgressWidget: Widget {
    let kind: String = "YearProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            YearProgressWidgetEntryView()
        }
        .configurationDisplayName("Year Progress")
        .description("Friendly reminder that you're not gonna live forever.")
        .supportedFamilies(supportedFamilies)
        .contentMarginsDisabled()
    }

    private var supportedFamilies: [WidgetFamily] {
        var widgetFamilies: [WidgetFamily] = [
            .systemMedium,
            .systemSmall,
            .systemLarge,
        ]

        if #available(iOSApplicationExtension 16.0, *) {
            widgetFamilies += [.accessoryCircular, .accessoryRectangular]
        }

        return widgetFamilies
    }
}
