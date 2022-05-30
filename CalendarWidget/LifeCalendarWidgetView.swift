import SwiftUI
import Defaults
import WidgetKit

struct LifeCalendarWidgetView: View {
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday

    var body: some View {
        if let birthday = birthday,
           let lifeProgress = LifeProgress(
               birthday: birthday,
               lifeExpectancy: lifeExpectancy
           )
        {
            Canvas { context, size in
                let numberOfCols = 10
                let cellSize = min(size.width, size.height) / Double(numberOfCols)
                let cellPadding = cellSize / 8

                for rowIndex in 0 ..< 10 {
                    for colIndex in 0 ..< 10 {
                        let cellPath =
                            Path(CGRect(
                                x: CGFloat(colIndex) * cellSize + cellPadding,
                                y: CGFloat(rowIndex) * cellSize + cellPadding,
                                width: cellSize - cellPadding * 2,
                                height: cellSize - cellPadding * 2
                            ))

                        let currentProgress = lifeProgress.currentLifeProgress

                        let currentCellIndex = rowIndex * 10 + colIndex

                        if Double(currentCellIndex) < currentProgress {
                            context.fill(cellPath, with: .color(.primary))
                        } else {
                            context.fill(cellPath, with: .color(.secondary))
                        }
                    }
                }
            }

        }
    }
}


struct LifeCalendarWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LifeCalendarWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
