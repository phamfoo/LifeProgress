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
                .fontWeight(.heavy)

            HStack(spacing: 0) {
                Text("\(life.numberOfWeeksSpent)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text(" weeks spent • ")

                Text("\(life.numberOfWeeksLeft)")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(" weeks left")
            }
            .foregroundColor(.secondary)
        }
    }

    private var yearProgressInfo: some View {
        VStack(alignment: .trailing) {
            Text("\(life.currentYearProgressFormattedString)%")
                .font(.system(size: 48))
                .fontWeight(.heavy)

            // TODO: Make sure other strings are pluralized properly
            // Maybe use stringsdict instead

            HStack(spacing: 0) {
                Text("\(life.currentYearRemainingWeeks)")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(
                    " weeks until your birthday"
                )
            }
            .foregroundColor(.secondary)
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
    @State private var life = Life.getCurrentLife()

    var body: some View {
        HomeView(life: life)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    life = Life.getCurrentLife()
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
