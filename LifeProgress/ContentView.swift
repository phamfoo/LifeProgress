import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            if let (age, weekOfYear) = getAgeComponents() {
                let totalWeeksInAYear = 52
                let averageLifeExpectancy = 72
                let progress =
                    (Double(age) + Double(weekOfYear) / Double(totalWeeksInAYear)) /
                    Double(averageLifeExpectancy) * 100
                let formattedProgress = String(format: "%.1f", progress)

                Canvas { context, size in
                    let cellSize = size.width / CGFloat(totalWeeksInAYear)
                    let cellPadding = cellSize / 8

                    for rowIndex in 0 ..< averageLifeExpectancy {
                        for colIndex in 0 ..< totalWeeksInAYear {
                            let cellPath =
                                Path(CGRect(
                                    x: CGFloat(colIndex) * cellSize + cellPadding,
                                    y: CGFloat(rowIndex) * cellSize + cellPadding,
                                    width: cellSize - cellPadding * 2,
                                    height: cellSize - cellPadding * 2
                                ))

                            if rowIndex < age || rowIndex == age && colIndex <=
                                weekOfYear
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
                .navigationTitle("Life Progress: \(formattedProgress)%")
                .padding()
            }
        }
    }

    func getAgeComponents() -> (age: Int, weekOfYear: Int)? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        if let dob = formatter.date(from: "1969/6/9") {
            let ageComponents = Calendar.current.dateComponents(
                [.year, .weekOfYear],
                from: dob,
                to: Date.now
            )

            if let age = ageComponents.year,
               let weekOfYear = ageComponents.weekOfYear
            {
                return (age, weekOfYear)
            }
        }

        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
