import SwiftUI
import WidgetKit

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
            .systemMedium,
            .systemSmall,
            .systemLarge,
        ]

        if #available(iOSApplicationExtension 16.0, *) {
            widgetFamilies.append(.accessoryCircular)
        }

        return widgetFamilies
    }
}
