import Foundation

struct Life {
    static let totalWeeksInAYear = 52

    var age: Int
    var weekOfYear: Int
    var lifeExpectancy: Int

    init?(birthday: Date, lifeExpectancy: Int) {
        let ageComponents = Calendar.current.dateComponents(
            [.year, .weekOfYear],
            from: birthday,
            to: .now
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

    var progress: Double {
        let realAge = Double(age) + Double(weekOfYear) /
            Double(Life.totalWeeksInAYear)
        let progress = realAge /
            Double(lifeExpectancy)

        return progress
    }

    var progressFormattedString: String {
        String(format: "%.1f", progress * 100)
    }

    var currentYearProgress: Double {
        Double(weekOfYear) / Double(Life.totalWeeksInAYear)
    }

    var currentYearProgressFormattedString: String {
        String(format: "%.1f", currentYearProgress * 100)
    }

    var currentYearRemainingWeeks: Int {
        Life.totalWeeksInAYear - weekOfYear
    }

    // We could use the Calendar API to calculate an accurate value of this,
    // but I want the value to match the amount of blank squares on the calendar
    var remainingWeeks: Int {
        Life.totalWeeksInAYear - weekOfYear +
            Life.totalWeeksInAYear * (lifeExpectancy - age - 1)
    }
    
    static func getDefaultBirthday() -> Date {
        let defaultUserAge = 22
        let defaultBirthday = Calendar.current.date(
            byAdding: .year,
            value: -defaultUserAge,
            to: .now
        )

        return defaultBirthday ?? .now
    }

    static var example: Life {
        // This is meant to be used only in previews
        // So I think it's okay to force unwrap here
        let birthday = getDefaultBirthday()
        let life = Life(
            birthday: birthday,
            lifeExpectancy: 72
        )!

        return life
    }
}
