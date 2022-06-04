import SwiftUI

struct LifeCalendar: View {
    let life: Life
    @State private var displayMode = DisplayMode.life

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let cellSize = containerWidth / Double(Life.totalWeeksInAYear)
            let cellPadding = cellSize / 12
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
                    for yearIndex in 0 ..< life.lifeExpectancy {
                        for weekIndex in 0 ..< Life.totalWeeksInAYear {
                            let cellPath =
                                Path(CGRect(
                                    x: Double(weekIndex) * cellSize + cellPadding,
                                    y: Double(yearIndex) * cellSize + cellPadding,
                                    width: cellSize - cellPadding * 2,
                                    height: cellSize - cellPadding * 2
                                ))

                            let currentAge = yearIndex + 1
                            let ageGroupColor = AgeGroup.getColorFor(age: currentAge)
                            // Ignore the current year
                            if currentAge < life.age {
                                context.fill(cellPath, with: .color(ageGroupColor))
                            } else if currentAge > life.age {
                                context.fill(
                                    cellPath,
                                    with: .color(Color(uiColor: .systemFill))
                                )
                            }
                        }
                    }
                }
                .opacity(displayMode == .life ? 1 : 0)
                .animation(.easeInOut(duration: 0.54), value: displayMode)

                // Draw the current year with views
                let currentYearModeColumnCount = 6
                let currentYearCellSize = displayMode == .currentYear ? containerWidth /
                    Double(currentYearModeColumnCount) : cellSize
                let currentYearCellPadding = currentYearCellSize / 12

                ForEach(0 ..< Life.totalWeeksInAYear, id: \.self) { weekIndex in
                    let row = displayMode == .currentYear ? weekIndex /
                        currentYearModeColumnCount :
                        life.age - 1
                    let column = displayMode == .currentYear ? weekIndex %
                        currentYearModeColumnCount :
                        weekIndex

                    Rectangle()
                        .fill(weekIndex <= life
                            .weekOfYear ? AgeGroup.getColorFor(age: life.age + 1) :
                            Color(uiColor: .systemFill))
                        .padding(currentYearCellPadding)
                        .frame(width: currentYearCellSize, height: currentYearCellSize)
                        .offset(
                            x: Double(column) * currentYearCellSize,
                            y: Double(row) * currentYearCellSize
                        )
                        .animation(
                            Animation.easeInOut(duration: 0.34)
                                .delay(0.015 * Double(weekIndex)),
                            value: displayMode
                        )
                }
            }
            .frame(height: cellSize * Double(life.lifeExpectancy))
            .onTapGesture {
                if displayMode == .currentYear {
                    displayMode = .life
                } else {
                    displayMode = .currentYear
                }
            }
        }
        .aspectRatio(
            Double(Life.totalWeeksInAYear) / Double(life.lifeExpectancy),
            contentMode: .fit
        )
    }

    enum DisplayMode {
        case currentYear
        case life
    }
}

struct LifeCalendar_Previews: PreviewProvider {
    static var previews: some View {
        let life = Life.example

        LifeCalendar(life: life)
    }
}
