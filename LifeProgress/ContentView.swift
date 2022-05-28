import SwiftUI

struct ContentView: View {
    @State private var showingSettings = false
    @AppStorage("lifeExpectancy") private var lifeExpectancy: Int?
    @AppStorage("birthday") private var birthday: Date?

    var body: some View {
        NavigationView {
            if let birthday = birthday, let lifeExpectancy = lifeExpectancy {
                if let lifeProgress = LifeProgress(
                    birthday: birthday,
                    lifeExpectancy: lifeExpectancy
                ) {
                    LifeCalendar(progress: lifeProgress)
                        .padding()
                        .navigationTitle(
                            "Life Progress: \(lifeProgress.formattedProgress)%"
                        )
                        .navigationBarItems(trailing:
                            Button(action: {
                                showingSettings.toggle()
                            }) {
                                Image(systemName: "gearshape").imageScale(.large)
                            })
                }
            } else {
                CalendarNotAvailable(onSetupRequest: {
                    showingSettings = true
                })
            }
        }
        .onAppear {
            if birthday == nil {
                showingSettings = true
            }
        }
        .sheet(isPresented: $showingSettings) {
            Settings(onDone: {
                showingSettings = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
