import Defaults
import SwiftUI

struct ContentView: View {
    @State private var showingProfile = false

    @Default(.lifeExpectancy) private var lifeExpectancy
    @Default(.birthday) private var birthday

    var body: some View {
        if let life = getCurrentLife() {
            NavigationView {
                LifeCalendar(life: life)
                    .padding()
                    .navigationTitle(
                        "Life Progress: \(life.formattedProgress)%"
                    )
                    .navigationBarItems(trailing:
                        Button(action: {
                            showingProfile.toggle()
                        }) {
                            Image(systemName: "square.and.pencil").imageScale(.large)
                        })
            }
            .sheet(isPresented: $showingProfile) {
                Profile(onDone: {
                    showingProfile = false
                })
            }
        } else {
            Welcome()
        }
    }

    func getCurrentLife() -> Life? {
        if let birthday = birthday,
           let life = Life(
               birthday: birthday,
               lifeExpectancy: lifeExpectancy
           )
        {
            return life
        }

        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)

            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
