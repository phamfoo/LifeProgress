import SwiftUI

struct ZoomedInCalendar: View {
    var body: some View {
        ZStack {
            TopLeftGrid()
                .padding(.leading, 75)
                .padding(.top, 75)
                .mask {
                    Circle()
                }
                .background {
                    Circle()
                        .strokeBorder(.secondary, lineWidth: 2)
                        .background(
                            Circle()
                                .fill(.background)
                        )
                }
        }
    }
}

struct TopLeftGrid: View {
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)

                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .opacity(0.2)

                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .opacity(0.2)
            }

            HStack {
                ForEach(1 ... 3, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)
                }
            }
            .opacity(0.2)

            HStack {
                ForEach(1 ... 3, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 24, height: 24)
                }
            }
            .opacity(0.2)
        }
    }
}

struct ZoomedInCalendar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZoomedInCalendar()

            TopLeftGrid()
        }
    }
}
