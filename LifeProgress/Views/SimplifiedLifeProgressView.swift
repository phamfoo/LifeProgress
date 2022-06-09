import SwiftUI

struct SimplifiedLifeProgressView: View {
    var life: Life

    var body: some View {
        GeometryReader { geometry in
            let containterHeight = geometry.size.height
            let containerWidth = geometry.size.width
            let progressWithoutCurrentYear = Double(life.age) /
                Double(life.lifeExpectancy)

            VStack(alignment: .leading, spacing: 0) {
                // Draw all age groups first, and then clip out only the top part
                // which represents the passed years
                ZStack(alignment: .topLeading) {
                    ForEach(AgeGroup.allCases, id: \.self) { group in
                        let previousAgeGroupProportion = Double(group.rawValue) /
                            Double(life
                                .lifeExpectancy)

                        group
                            .getColor()
                            .offset(y: containterHeight * previousAgeGroupProportion)
                    }
                }
                .frame(
                    width: containerWidth,
                    height: progressWithoutCurrentYear * containterHeight
                )
                .clipped()

                // Current year
                AgeGroup(age: life.age + 1)
                    .getColor()
                    .frame(
                        width: life.currentYearProgress * containerWidth,
                        height: containterHeight / Double(life.lifeExpectancy)
                    )

                Spacer()
            }
            .background(Color(uiColor: .systemFill))
        }
    }
}

struct SimplifiedLifeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SimplifiedLifeProgressView(life: Life.example)
    }
}
