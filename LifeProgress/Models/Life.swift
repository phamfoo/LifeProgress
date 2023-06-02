import Defaults
import Foundation

struct Life {
    var lifeExpectancy: Int

    var age: Int
    var numberOfWeeksTotal: Int
    var numberOfWeeksSpent: Int
    var currentYearNumberOfWeeksSpent: Int

    init(birthday: Date, lifeExpectancy: Int) {
        let calendar = Calendar.current

        self.lifeExpectancy = lifeExpectancy
        let birthday = calendar.startOfDay(for: birthday)

        let ageComponents = calendar.dateComponents(
            [.year, .weekOfYear],
            from: birthday,
            to: .now
        )
        age = ageComponents.year!
        currentYearNumberOfWeeksSpent = ageComponents.weekOfYear!

        let endOfLife = calendar.date(
            byAdding: .year,
            value: lifeExpectancy,
            to: birthday
        )!
        numberOfWeeksTotal = calendar.dateComponents(
            [.weekOfYear],
            from: birthday,
            to: endOfLife
        ).weekOfYear!

        numberOfWeeksSpent = calendar.dateComponents(
            [.weekOfYear],
            from: birthday,
            to: .now
        ).weekOfYear!
    }
}

// MARK: - Life progress

extension Life {
    var numberOfWeeksLeft: Int {
        numberOfWeeksTotal - numberOfWeeksSpent
    }

    var progress: Double {
        Double(numberOfWeeksSpent) / Double(numberOfWeeksTotal)
    }

    var progressFormattedString: String {
        String(format: "%.1f", progress * 100)
    }
}

// MARK: - Year progress

extension Life {
    static let numberOfWeeksInAYear = 52

    var currentYearNumberOfWeeksLeft: Int {
        Life.numberOfWeeksInAYear - currentYearNumberOfWeeksSpent
    }

    var currentYearProgress: Double {
        Double(currentYearNumberOfWeeksSpent) /
            Double(Life.numberOfWeeksInAYear)
    }

    var currentYearProgressFormattedString: String {
        String(format: "%.1f", currentYearProgress * 100)
    }
}

// MARK: - Utils

extension Life {
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
        let birthday = Calendar.current.date(
            byAdding: .month, value: 4, to: getDefaultBirthday()
        ) ?? .now

        let life = Life(
            birthday: birthday,
            lifeExpectancy: 72
        )

        return life
    }
}
