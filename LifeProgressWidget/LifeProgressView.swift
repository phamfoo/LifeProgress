import Defaults
import SwiftUI
import WidgetKit

struct LifeProgressView: View {
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday

    var body: some View {
        if let life = getCurrentLife() {
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
                            
                            AgeGroup.getColorFor(age: group.rawValue)
                                .offset(y: containterHeight * previousAgeGroupProportion)
                        }
                    }
                    .frame(
                        width: containerWidth,
                        height: progressWithoutCurrentYear * containterHeight
                    )
                    .clipped()

                    // Current year
                    AgeGroup.getColorFor(age: life.age + 1)
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
    
    func getCurrentLife() -> Life? {
        if let birthday = birthday,
           let life = Life(
               birthday: birthday,
               lifeExpectancy: lifeExpectancy
           )
        {
            return life
        }

        return nil
    }
}

struct LifeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LifeProgressView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
