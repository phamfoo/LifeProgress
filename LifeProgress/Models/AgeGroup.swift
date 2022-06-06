import Foundation

enum AgeGroup: Int, CaseIterable {
    case baby = 0
    case child = 3
    case adolescent = 9
    case youngAdult = 18
    case adult = 25
    case middleAge = 40
    case oldAge = 60

    init(age: Int) {
        if age < AgeGroup.child.rawValue {
            self = .baby
        } else if age < AgeGroup.adolescent.rawValue {
            self = .child
        } else if age < AgeGroup.youngAdult.rawValue {
            self = .adolescent
        } else if age < AgeGroup.adult.rawValue {
            self = .youngAdult
        } else if age < AgeGroup.middleAge.rawValue {
            self = .adult
        } else if age < AgeGroup.oldAge.rawValue {
            self = .middleAge
        } else {
            self = .oldAge
        }
    }
}
