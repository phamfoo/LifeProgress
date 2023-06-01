import SwiftUI

struct YearCalendarView: View {
    var life: Life

    var body: some View {
        Canvas { context, size in
            let numberOfColumns = 8
            let numberOfRows = Life.totalWeeksInAYear / numberOfColumns + 1
            let cellWidth = size.width / Double(numberOfColumns)
            let cellHeight = size.height / Double(numberOfRows)
            let cellPadding = cellWidth / 32

            let scaleFactor = size.width / (size.width - cellPadding * 2)
            let scaleTransform = CGAffineTransform(
                scaleX: scaleFactor,
                y: scaleFactor
            )
            let translateTransform = CGAffineTransform(
                translationX: -cellPadding * scaleFactor,
                y: -cellPadding * scaleFactor
            )

            context.concatenate(scaleTransform)
            context.concatenate(translateTransform)

            for weekIndex in 0 ... Life.totalWeeksInAYear {
                let rowIndex = weekIndex / numberOfColumns
                let columnIndex = weekIndex % numberOfColumns

                let cellPath =
                    Path(
                        CGRect(
                            x: Double(columnIndex) * cellWidth + cellPadding,
                            y: Double(rowIndex) * cellHeight + cellPadding,
                            width: cellWidth - cellPadding * 2,
                            height: cellHeight - cellPadding * 2
                        )
                    )

                let fillColor = weekIndex < life.weekOfYear
                    ? AgeGroup(age: life.age + 1).getColor()
                    : Color(uiColor: .systemFill)

                context.fill(cellPath, with: .color(fillColor))
            }
        }
    }
}

struct YearCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        YearCalendarView(life: Life.example)
            .previewLayout(.fixed(width: 300, height: 200))
    }
}
