import SwiftUI

struct HomeScreen: View {
    var life: Life

    @State private var showingProfile = false
    @State private var showingAbout = false
    @State private var displayMode: LifeCalendarView.DisplayMode = .life

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

                LifeCalendarView(life: life, displayMode: displayMode)
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
                    Menu {
                        Button {
                            showingProfile = true
                        } label: {
                            Label(
                                "Profile",
                                systemImage: "person.circle.fill"
                            )
                        }

                        Button {
                            showingAbout = true
                        } label: {
                            Label(
                                "About This App",
                                systemImage: "info.circle.fill"
                            )
                        }

                    } label: {
                        Label(
                            "Menu",
                            systemImage: "ellipsis.circle"
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingProfile) {
            ProfileScreen()
        }
        .sheet(isPresented: $showingAbout) {
            AboutScreen(life: life)
        }
    }

    var lifeProgressInfo: some View {
        return VStack(alignment: .leading) {
            Text("Life Progress: \(life.progressFormattedString)%")
                .font(.title)
                .bold()
            Text(
                "**\(life.numberOfWeeksSpent)** weeks spent • **\(life.numberOfWeeksLeft)** weeks left"
            )
            .foregroundColor(.secondary)
        }
    }

    var yearProgressInfo: some View {
        return VStack(alignment: .leading) {
            Text("Year Progress: \(life.currentYearProgressFormattedString)%")
                .font(.title)
                .bold()
            
            // TODO: Make sure other strings are pluralized properly
            // Maybe use stringsdict instead
            Text(
                "^[**\(life.currentYearRemainingWeeks)** weeks](inflect: true) until your birthday"
            )
            .foregroundColor(.secondary)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(life: Life.example)
    }
}
