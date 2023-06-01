import SwiftUI

struct LifeCalendarView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    let life: Life
    var displayMode: DisplayMode

    private static let currentYearModeColumnCount = 6

    var body: some View {
        if verticalSizeClass == .regular {
            content
        } else {
            // We want the view to be expandable and scrollable
            // if the user is in the landscape mode on the smaller devices.
            ScrollView(showsIndicators: false) {
                content
            }
        }
    }

    var content: some View {
        let fullCalendarAspectRatio = Double(Life.totalWeeksInAYear) /
            Double(life.lifeExpectancy)

        let currentYearGridAspectRatio = Double(
            LifeCalendarView
                .currentYearModeColumnCount
        ) /
            (
                Double(Life.totalWeeksInAYear) /
                    Double(LifeCalendarView.currentYearModeColumnCount) + 1
            )

        return ZStack(alignment: .topLeading) {
            // Most of the calendar is drawn using canvas,
            // except for the current year
            //
            // We're doing this because when switching from `life` to `year`
            // mode,
            // the cells from the current year should transition smoothly to
            // a new grid layout.
            // This is really easy with view transitions, I'm not sure if it's
            // possible
            // to do with canvas only.
            calendarWithoutCurrentYear

            // Draw the current year with views
            currentYear
        }
        .aspectRatio(
            // This prevents content from being cut off
            // while trying to utilize as much space as we can
            min(fullCalendarAspectRatio, currentYearGridAspectRatio),
            contentMode: .fit
        )
    }

    private var calendarWithoutCurrentYear: some View {
        Canvas { context, size in
            let containerWidth = size.width
            let cellSize = containerWidth / Double(Life.totalWeeksInAYear)
            let cellPadding = cellSize / 12

            for yearIndex in 0 ..< life.lifeExpectancy {
                for weekIndex in 0 ..< Life.totalWeeksInAYear {
                    let cellPath =
                        Path(CGRect(
                            x: Double(weekIndex) * cellSize + cellPadding,
                            y: Double(yearIndex) * cellSize + cellPadding,
                            width: cellSize - cellPadding * 2,
                            height: cellSize - cellPadding * 2
                        ))

                    let currentYear = yearIndex + 1
                    let ageGroupColor = AgeGroup(age: currentYear)
                        .getColor()

                    // Ignore the current year (currentYear == life.age)
                    if currentYear < life.age {
                        context.fill(cellPath, with: .color(ageGroupColor))
                    } else if currentYear > life.age {
                        context.fill(
                            cellPath,
                            with: .color(Color(uiColor: .systemFill))
                        )
                    }
                }
            }
        }
        .opacity(displayMode == .life ? 1 : 0)
        .animation(
            Animation.easeInOut(duration: 0.3)
                .delay(
                    displayMode == .currentYear
                        ? 0.0
                        : 0.3 +
                        getAnimationDelay(weekIndex: Life.totalWeeksInAYear)
                ),

            value: displayMode
        )
    }

    private var currentYear: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width

            let cellSize = displayMode == .currentYear ?
                containerWidth /
                Double(LifeCalendarView.currentYearModeColumnCount) :
                containerWidth / Double(Life.totalWeeksInAYear)
            let cellPadding = cellSize / 12

            ForEach(0 ..< Life.totalWeeksInAYear, id: \.self) { weekIndex in
                // TODO: Maybe instead of doing it this way, I could just lay things out normally
                // and use matchedGeometryEffect and let SwiftUI do its "magic
                // move" thing
                let rowIndex = displayMode == .currentYear ?
                    weekIndex / LifeCalendarView.currentYearModeColumnCount :
                    life.age - 1
                let columnIndex = displayMode == .currentYear ?
                    weekIndex % LifeCalendarView.currentYearModeColumnCount :
                    weekIndex

                Rectangle()
                    .fill(
                        weekIndex < life.weekOfYear ?
                            AgeGroup(age: life.age + 1).getColor() :
                            Color(uiColor: .systemFill)
                    )
                    .padding(cellPadding)
                    .frame(width: cellSize, height: cellSize)
                    .offset(
                        x: Double(columnIndex) * cellSize,
                        y: Double(rowIndex) * cellSize
                    )
                    .animation(
                        Animation.easeInOut(duration: 0.3)
                            .delay(
                                displayMode == .currentYear
                                    ? 0.3
                                    : 0
                            )
                            .delay(getAnimationDelay(weekIndex: weekIndex)),
                        value: displayMode
                    )
            }
        }
    }

    private func getAnimationDelay(weekIndex: Int) -> Double {
        Double(
            weekIndex / LifeCalendarView.currentYearModeColumnCount
        ) * 0.04
    }

    enum DisplayMode {
        case currentYear
        case life
    }
}

struct LifeCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        LifeCalendarView(life: Life.example, displayMode: .life)
    }
}
