import Defaults
import SwiftUI
import WidgetKit

private struct HomeView: View {
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
                        .transition(
                            moveTransition(edge: .leading)
                                .combined(with: .opacity)
                        )
                } else {
                    yearProgressInfo
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .transition(
                            moveTransition(edge: .trailing)
                                .combined(with: .opacity)
                        )
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
        .animation(.easeInOut(duration: 0.6), value: displayMode)
    }

    private var lifeProgressInfo: some View {
        VStack(alignment: .leading) {
            Text("\(life.progressFormattedString)%")
                .font(.system(size: 48))
                .fontWeight(.bold)

            let weeksSpentText = Text("\(life.numberOfWeeksSpent)")
                .font(.title3)
                .fontWeight(.bold)
            let weeksLeftText = Text("\(life.numberOfWeeksLeft)")
                .font(.title3)
                .fontWeight(.bold)

            Text(
                "\(weeksSpentText) weeks spent • \(weeksLeftText) weeks left"
            )
            .foregroundColor(.secondary)
        }
    }

    private var yearProgressInfo: some View {
        VStack(alignment: .trailing) {
            Text("\(life.currentYearProgressFormattedString)%")
                .font(.system(size: 48))
                .fontWeight(.bold)

            // TODO: Consider using stringsdict instead
            // Not sure how that would work with nested texts
            let remainingWeeks = life.currentYearRemainingWeeks
            let remainingWeeksText = Text("\(remainingWeeks)")
                .font(.title3)
                .fontWeight(.bold)

            if remainingWeeks == 1 {
                Text(
                    "\(remainingWeeksText) week until your birthday"
                )
                .foregroundColor(.secondary)
            } else {
                Text(
                    "\(remainingWeeksText) weeks until your birthday"
                )
                .foregroundColor(.secondary)
            }
        }
    }

    private func moveTransition(edge: Edge) -> AnyTransition {
        let oppositeEdge: Edge =
            edge == .leading
                ? .trailing
                : .leading
        if #available(iOS 16.0, *) {
            return AnyTransition.move(edge: edge)
        } else {
            return AnyTransition.asymmetric(
                insertion: .move(edge: edge),
                removal: .move(edge: oppositeEdge)
            )
        }
    }
}

struct HomeScreen: View {
    @Environment(\.scenePhase) var scenePhase
    @Default(.birthday) private var birthday
    @Default(.lifeExpectancy) private var lifeExpectancy

    var body: some View {
        HomeView(life: life)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
    }

    private var life: Life {
        return Life(birthday: birthday, lifeExpectancy: lifeExpectancy)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
