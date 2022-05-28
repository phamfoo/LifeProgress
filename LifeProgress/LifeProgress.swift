import Foundation

struct LifeProgress {
    static let totalWeeksInAYear = 52

    var age: Int
    var weekOfYear: Int
    var lifeExpectancy: Int

    init?(birthday: Date, lifeExpectancy: Int) {
        let ageComponents = Calendar.current.dateComponents(
            [.year, .weekOfYear],
            from: birthday,
            to: Date.now
        )

        guard let age = ageComponents.year,
              let weekOfYear = ageComponents.weekOfYear
        else {
            return nil
        }

        self.age = age
        self.weekOfYear = weekOfYear
        self.lifeExpectancy = lifeExpectancy
    }

    var formattedProgress: String {
        let realAge = Double(age) + Double(weekOfYear) /
            Double(LifeProgress.totalWeeksInAYear)
        let progress = realAge /
            Double(lifeExpectancy) * 100
        let formattedProgress = String(format: "%.1f", progress)

        return formattedProgress
    }
}
