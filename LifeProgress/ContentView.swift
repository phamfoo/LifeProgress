import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Canvas { context, size in
                let totalWeeksInAYear = 52
                let averageLifeExpectancy = 72
                let cellSize = size.width / CGFloat(totalWeeksInAYear)
                let cellPadding = cellSize / 8

                for rowIndex in 0 ..< averageLifeExpectancy {
                    for colIndex in 0 ..< totalWeeksInAYear {
                        let cellPath =
                            Path(CGRect(
                                x: CGFloat(colIndex) * cellSize + cellPadding,
                                y: CGFloat(rowIndex) * cellSize + cellPadding,
                                width: cellSize - cellPadding * 2,
                                height: cellSize - cellPadding * 2
                            ))

                        if rowIndex <= 29 {
                            context.fill(cellPath, with: .color(.gray))
                        } else {
                            context.stroke(
                                cellPath,
                                with: .color(.gray),
                                lineWidth: cellSize / 8
                            )
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Life Progress: \(40)%")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
