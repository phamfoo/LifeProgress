import SwiftUI

struct Home: View {
    var life: Life
    @State private var showingProfile = false
    @State private var displayMode: LifeCalendar.DisplayMode = .life

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if displayMode == .life {
                    lifeProgressInfo
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(AnyTransition.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                } else {
                    yearProgressInfo
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(AnyTransition.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                }

                LifeCalendar(life: life, displayMode: $displayMode)
                    .onTapGesture {
                        withAnimation {
                            if displayMode == .currentYear {
                                displayMode = .life
                            } else {
                                displayMode = .currentYear
                            }
                        }
                    }
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing:
                Button(action: {
                    showingProfile.toggle()
                }) {
                    Image(systemName: "square.and.pencil").imageScale(.large)
                })
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingProfile) {
                Profile(onDone: {
                    showingProfile = false
                })
            }
        }
    }

    var lifeProgressInfo: some View {
        let remainingWeeksText = try! AttributedString(
            markdown: "**\(life.remainingWeeks)** weeks left"
        )

        return VStack(alignment: .leading) {
            Text("Life Progress: \(life.progressFormattedString)%")
                .font(.title)
                .bold()
            Text(remainingWeeksText)
                .foregroundColor(.secondary)
        }
    }

    var yearProgressInfo: some View {
        let remainingWeeksText = try! AttributedString(
            markdown: "**\(life.currentYearRemainingWeeks)** weeks until your birthday"
        )

        return VStack(alignment: .leading) {
            Text("Year Progress: \(life.currentYearProgressFormattedString)%")
                .font(.title)
                .bold()
            Text(remainingWeeksText)
                .foregroundColor(.secondary)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(life: Life.example)
    }
}
