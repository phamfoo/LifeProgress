import Foundation
import SwiftUI

enum AgeGroup: Int, CaseIterable {
    case baby = 0
    case child = 3
    case adolescent = 9
    case youngAdult = 18
    case adult = 25
    case middleAge = 40
    case oldAge = 60
    
    static func getColorFor(age: Int) -> Color {
        if age < child.rawValue {
            return .blue
        } else if age < adolescent.rawValue {
            return .green
        } else if age < youngAdult.rawValue {
            return .yellow
        } else if age < adult.rawValue {
            return .orange
        } else if age < middleAge.rawValue {
            return .red
        } else {
            return .purple
        }
    }

}
