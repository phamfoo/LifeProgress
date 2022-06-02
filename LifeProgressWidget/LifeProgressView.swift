import Defaults
import SwiftUI
import WidgetKit

struct LifeProgressView: View {
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday

    var body: some View {
        if let birthday = birthday,
           let lifeProgress = LifeProgress(
               birthday: birthday,
               lifeExpectancy: lifeExpectancy
           )
        {
            GeometryReader { geometry in
                let containterHeight = geometry.size.height
                let containerWidth = geometry.size.width
                let progressWithoutCurrentYear = Double(lifeProgress.age) /
                    Double(lifeProgress.lifeExpectancy)

                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        ForEach(AgeGroup.allCases, id: \.self) { group in
                            let previousAgeGroupProportion = Double(group.rawValue) /
                                Double(lifeProgress
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
                    AgeGroup.getColorFor(age: lifeProgress.age + 1)
                        .frame(
                            width: lifeProgress.currentYearProgress * containerWidth,
                            height: containterHeight / Double(lifeProgress.lifeExpectancy)
                        )

                    Spacer()
                }
                .background(Color(uiColor: .systemFill))
            }
        }
    }
}

struct LifeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LifeProgressView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
