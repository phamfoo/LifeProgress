import SwiftUI

// TODO: See if it makes sense to make this reusable
struct CurrentYearProgressView: View {
    var life: Life

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let cellSize = containerWidth / Double(Life.totalWeeksInAYear)
            let cellPadding = cellSize / 12

            HStack(alignment: .top, spacing: 0) {
                ForEach(0 ..< Life.totalWeeksInAYear,
                        id: \.self) { weekIndex in
                    Rectangle()
                        .fill(weekIndex < life.weekOfYear ?
                            AgeGroup(age: life.age + 1).getColor() :
                            Color(uiColor: .systemFill))
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
