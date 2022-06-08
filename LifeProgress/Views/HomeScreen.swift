import SwiftUI

struct HomeScreen: View {
    var life: Life
    
    @State private var showingProfile = false
    @State private var displayMode: LifeProgressView.DisplayMode = .life

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

                LifeProgressView(life: life, displayMode: displayMode)
                    .onTapGesture {
                        withAnimation {
                            displayMode = displayMode == .currentYear
                                ? .life
                                : .currentYear
                        }
                    }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingProfile) {
                ProfileScreen()
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

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(life: Life.example)
    }
}
