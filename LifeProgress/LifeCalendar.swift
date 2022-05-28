import SwiftUI

struct LifeCalendar: View {
    let progress: LifeProgress

    var body: some View {
        Canvas { context, size in
            let cellSize = size.width / CGFloat(LifeProgress.totalWeeksInAYear)
            let cellPadding = cellSize / 8

            for rowIndex in 0 ..< progress.lifeExpectancy {
                for colIndex in 0 ..< LifeProgress.totalWeeksInAYear {
                    let cellPath =
                        Path(CGRect(
                            x: CGFloat(colIndex) * cellSize + cellPadding,
                            y: CGFloat(rowIndex) * cellSize + cellPadding,
                            width: cellSize - cellPadding * 2,
                            height: cellSize - cellPadding * 2
                        ))

                    if rowIndex < progress.age || rowIndex == progress
                        .age && colIndex <=
                        progress.weekOfYear
                    {
                        context.fill(cellPath, with: .color(.gray))
                    } else {
                        context.stroke(
                            cellPath,
                            with: .color(.gray),
                            lineWidth: cellSize / 8
                        )
                    }
                }
            }
        }
    }
}

struct LifeCalendar_Previews: PreviewProvider {
    static var previews: some View {
        if let lifeProgress = LifeProgress(
            birthday: Calendar.current.date(byAdding: .weekOfYear, value: -987, to: .now) ?? .now,
            lifeExpectancy: 72
        ) {
            LifeCalendar(progress: lifeProgress)
        }
    }
}
