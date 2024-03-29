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
                Group {
                    if displayMode == .life {
                        lifeProgressInfo
                            .transition(
                                moveTransition(edge: .top)
                                    .combined(with: .opacity)
                            )
                    } else {
                        yearProgressInfo
                            .transition(
                                moveTransition(edge: .bottom)
                                    .combined(with: .opacity)
                            )
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: displayMode)

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
            .padding(.horizontal)
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

    private var lifeProgressInfo: some View {
        VStack(spacing: 16) {
            VStack {
                Text("Your Life Progress")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("\(life.progressFormattedString)%")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
            }

            HStack {
                VStack {
                    Text("\(life.numberOfWeeksSpent)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(weeksSpentLabel(for: life.numberOfWeeksSpent))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text("\(life.numberOfWeeksLeft)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(weeksLeftLabel(for: life.numberOfWeeksLeft))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text("\(life.numberOfWeeksTotal)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("in total")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var yearProgressInfo: some View {
        VStack(spacing: 16) {
            VStack {
                Text(currentYearTitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("\(life.currentYearProgressFormattedString)%")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
            }

            HStack {
                Spacer()

                VStack {
                    let weeksSpentText =
                        Text("\(life.currentYearNumberOfWeeksSpent)")
                            .foregroundColor(.primary)

                    Text("\(weeksSpentText)/\(Life.numberOfWeeksInAYear)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)

                    Text(weeksSpentLabel(
                        for: life
                            .currentYearNumberOfWeeksSpent
                    ))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }

                Spacer()

                VStack {
                    Text("\(life.currentYearNumberOfWeeksLeft)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(weeksLeftLabel(for: life.currentYearNumberOfWeeksLeft))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
        }
    }

    private func moveTransition(edge: Edge) -> AnyTransition {
        let oppositeEdge: Edge =
            edge == .top
                ? .bottom
                : .top
        if #available(iOS 16.0, *) {
            return AnyTransition.move(edge: edge)
        } else {
            return AnyTransition.asymmetric(
                insertion: .move(edge: edge),
                removal: .move(edge: oppositeEdge)
            )
        }
    }

    private func weeksSpentLabel(for numberOfWeeks: Int) -> String {
        numberOfWeeks == 1
            ? "wk spent"
            : "wks spent"
    }

    private func weeksLeftLabel(for numberOfWeeks: Int) -> String {
        numberOfWeeks == 1
            ? "wk left"
            : "wks left"
    }

    private var currentYearTitle: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let currentYear = life.age + 1

        return "Your \(formatter.string(from: currentYear as NSNumber)!) Year"
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
