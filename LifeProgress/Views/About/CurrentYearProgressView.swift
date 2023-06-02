import SwiftUI

struct CurrentYearProgressView: View {
    var life: Life

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let cellSize = containerWidth / Double(Life.numberOfWeeksInAYear)
            let cellPadding = cellSize / 12

            HStack(alignment: .top, spacing: 0) {
                ForEach(
                    0 ..< Life.numberOfWeeksInAYear,
                    id: \.self
                ) { weekIndex in
                    Rectangle()
                        .fill(
                            weekIndex < life.currentYearNumberOfWeeksSpent ?
                                AgeGroup(age: life.age + 1).getColor() :
                                Color(uiColor: .systemFill)
                        )
                        .padding(cellPadding)
                        .frame(width: cellSize, height: cellSize)
                }
            }
        }
        .aspectRatio(52, contentMode: .fit)
    }
}

struct CurrentYearProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentYearProgressView(life: Life.example)
    }
}
