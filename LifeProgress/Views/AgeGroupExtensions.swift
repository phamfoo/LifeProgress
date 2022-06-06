import SwiftUI

extension AgeGroup {
    func getColor() -> Color {
        switch self {
        case .baby:
            return .blue
        case .child:
            return .green
        case .adolescent:
            return .yellow
        case .youngAdult:
            return .orange
        case .adult:
            return .red
        case .middleAge:
            return .purple
        case .oldAge:
            return .brown
        }
    }
}
