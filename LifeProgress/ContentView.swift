import SwiftUI

struct ContentView: View {
    @State private var showingProfile = false
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
                                showingProfile.toggle()
                            }) {
                                Image(systemName: "square.and.pencil").imageScale(.large)
                            })
                }
            } else {
                CalendarNotAvailable(onSetupRequest: {
                    showingProfile = true
                })
            }
        }
        .onAppear {
            if birthday == nil {
                showingProfile = true
            }
        }
        .sheet(isPresented: $showingProfile) {
            Profile(onDone: {
                showingProfile = false
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
