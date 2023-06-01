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
    }

    private var supportedFamilies: [WidgetFamily] {
        var widgetFamilies: [WidgetFamily] = [
            .systemMedium,
            .systemSmall,
            .systemLarge,
        ]

        if #available(iOS 16, *) {
            widgetFamilies.append(.accessoryCircular)
        }

        return widgetFamilies
    }
}

struct YearProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        YearProgressWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
