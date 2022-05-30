import SwiftUI

struct LifeCalendar: View {
    let progress: LifeProgress
    @State private var displayMode = DisplayMode.life

    var body: some View {
        GeometryReader { proxy in
            let cellSize = proxy.size.width / CGFloat(LifeProgress.totalWeeksInAYear)
            let cellPadding = cellSize / 8

            ZStack(alignment: .topLeading) {
                // Most of the calendar is drawn using canvas,
                // except for the current year
                //
                // We're doing this because when switching from `life` to `year` mode,
                // the cells from the current year should transition smoothly to
                // a new grid layout.
                // This is really easy with view transitions, I'm not sure if it's possible
                // to do with canvas only.
                Canvas { context, _ in
                    for yearIndex in 0 ..< progress.lifeExpectancy {
                        for weekIndex in 0 ..< LifeProgress.totalWeeksInAYear {
                            let cellPath =
                                Path(CGRect(
                                    x: CGFloat(weekIndex) * cellSize + cellPadding,
                                    y: CGFloat(yearIndex) * cellSize + cellPadding,
                                    width: cellSize - cellPadding * 2,
                                    height: cellSize - cellPadding * 2
                                ))

                            // Ignore the current year
                            if yearIndex < progress.age {
                                context.fill(cellPath, with: .color(.primary))
                            } else if yearIndex > progress.age {
                                context.fill(cellPath, with: .color(.secondary))
                            }
                        }
                    }
                }
                .opacity(displayMode == .life ? 1 : 0)
                .animation(.easeInOut(duration: 0.54), value: displayMode)

                // Draw the current year with views
                let yearModeColumnCount = 6
                let currentYearCellSize = displayMode == .currentYear ? proxy.size
                    .width / CGFloat(yearModeColumnCount) : cellSize
                let currentYearCellPadding = currentYearCellSize / 8

                ForEach(0 ..< LifeProgress.totalWeeksInAYear, id: \.self) { weekIndex in
                    let row = displayMode == .currentYear ? weekIndex /
                        yearModeColumnCount :
                        progress.age
                    let column = displayMode == .currentYear ? weekIndex %
                        yearModeColumnCount :
                        weekIndex

                    Rectangle()
                        .fill(weekIndex <= progress.weekOfYear ? Color.primary : Color
                            .secondary)
                        .padding(currentYearCellPadding)
                        .frame(width: currentYearCellSize, height: currentYearCellSize)
                        .offset(
                            x: CGFloat(column) * currentYearCellSize,
                            y: CGFloat(row) * currentYearCellSize
                        )
                        .animation(
                            Animation.easeInOut(duration: 0.34)
                                .delay(0.015 * Double(weekIndex)),
                            value: displayMode
                        )
                }
            }
            .frame(height: cellSize * CGFloat(progress.lifeExpectancy))
            .onTapGesture {
                if displayMode == .currentYear {
                    displayMode = .life
                } else {
                    displayMode = .currentYear
                }
            }
        }
    }

    enum DisplayMode {
        case currentYear
        case life
    }
}

struct LifeCalendar_Previews: PreviewProvider {
    static var previews: some View {
        if let lifeProgress = LifeProgress(
            birthday: Calendar.current
                .date(byAdding: .weekOfYear, value: -987, to: .now) ?? .now,
            lifeExpectancy: 72
        ) {
            LifeCalendar(progress: lifeProgress)
        }
    }
}
