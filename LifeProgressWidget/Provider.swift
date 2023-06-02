import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(
        in _: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(
        in _: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        // Create a timeline entry for "now."
        let date = Date()
        let entry = SimpleEntry(
            date: date
        )

        let calendar = Calendar.current
        let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: date
        )!

        let nextUpdateDate = calendar.startOfDay(for: tomorrow)

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextUpdateDate)
        )

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}
