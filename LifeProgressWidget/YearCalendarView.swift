import SwiftUI

struct YearCalendarView: View {
    var life: Life

    var body: some View {
        GeometryReader { geometry in
            let numberOfColumns = 8
            let numberOfRows = Life.totalWeeksInAYear / numberOfColumns + 1
            let cellWidth = geometry.size.width / Double(numberOfColumns)
            let cellHeight = geometry.size.height / Double(numberOfRows)
            let cellPadding = cellWidth / 12

            ForEach(0 ..< Life.totalWeeksInAYear, id: \.self) { weekIndex in
                let rowIndex = weekIndex / numberOfColumns
                let columnIndex = weekIndex % numberOfColumns

                Rectangle()
                    .fill(
                        weekIndex < life.weekOfYear ?
                            AgeGroup(age: life.age + 1).getColor() :
                            Color(uiColor: .systemFill)
                    )
                    .padding(cellPadding)
                    .frame(width: cellWidth, height: cellHeight)
                    .offset(
                        x: Double(columnIndex) * cellWidth,
                        y: Double(rowIndex) * cellHeight
                    )
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
