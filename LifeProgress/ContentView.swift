import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            if let lifeProgress = LifeProgress(dob: "1969/6/9") {
                LifeCalendarView(progress: lifeProgress)
                    .navigationTitle("Life Progress: \(lifeProgress.formattedProgress)%")
                    .padding()
            }
        }
    }
}

struct LifeCalendarView: View {
    let progress: LifeProgress

    var body: some View {
        Canvas { context, size in
            let cellSize = size.width / CGFloat(LifeProgress.totalWeeksInAYear)
            let cellPadding = cellSize / 8

            for rowIndex in 0 ..< LifeProgress.averageLifeExpectancy {
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

struct LifeProgress {
    static let totalWeeksInAYear = 52
    static let averageLifeExpectancy = 72

    var age: Int
    var weekOfYear: Int

    init?(dob: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        guard let dobDate = formatter.date(from: dob) else {
            return nil
        }

        let ageComponents = Calendar.current.dateComponents(
            [.year, .weekOfYear],
            from: dobDate,
            to: Date.now
        )

        guard let age = ageComponents.year,
              let weekOfYear = ageComponents.weekOfYear
        else {
            return nil
        }

        self.age = age
        self.weekOfYear = weekOfYear
    }

    var formattedProgress: String {
        let realAge = Double(age) + Double(weekOfYear) /
            Double(LifeProgress.totalWeeksInAYear)
        let progress = realAge /
            Double(LifeProgress.averageLifeExpectancy) * 100
        let formattedProgress = String(format: "%.1f", progress)

        return formattedProgress
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
