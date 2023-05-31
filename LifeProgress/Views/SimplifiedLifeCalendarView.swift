import SwiftUI

struct SimplifiedLifeCalendarView: View {
    var life: Life

    var body: some View {
        GeometryReader { geometry in
            let containerHeight = geometry.size.height
            let containerWidth = geometry.size.width
            let progressWithoutCurrentYear = Double(life.age) /
                Double(life.lifeExpectancy)

            VStack(alignment: .leading, spacing: 0) {
                // Draw all age groups first, and then clip out only the top
                // part, which represents the passed years
                ZStack(alignment: .topLeading) {
                    ForEach(AgeGroup.allCases, id: \.self) { group in
                        let previousAgeGroupProportion =
                            Double(group.rawValue) /
                            Double(life.lifeExpectancy)

                        group
                            .getColor()
                            .offset(
                                y: containerHeight * previousAgeGroupProportion
                            )
                    }
                }
                .frame(
                    width: containerWidth,
                    height: progressWithoutCurrentYear * containerHeight
                )
                .clipped()

                // Current year
                AgeGroup(age: life.age + 1)
                    .getColor()
                    .frame(
                        width: life.currentYearProgress * containerWidth,
                        height: containerHeight / Double(life.lifeExpectancy)
                    )

                Spacer()
            }
            .background(Color(uiColor: .systemFill))
        }
    }
}

struct SimplifiedLifeCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SimplifiedLifeCalendarView(life: Life.example)
    }
}
