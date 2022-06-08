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
        switch age {
        case ..<AgeGroup.child.rawValue:
            self = .baby
        case ..<AgeGroup.adolescent.rawValue:
            self = .child
        case ..<AgeGroup.youngAdult.rawValue:
            self = .adolescent
        case ..<AgeGroup.adult.rawValue:
            self = .youngAdult
        case ..<AgeGroup.middleAge.rawValue:
            self = .adult
        case ..<AgeGroup.oldAge.rawValue:
            self = .middleAge
        default:
            self = .oldAge
        }
    }
}
