import Defaults
import SwiftUI

struct ContentView: View {
    @State private var showingProfile = false
    
    @Default(.lifeExpectancy) var lifeExpectancy
    @Default(.birthday) var birthday

    var body: some View {
        NavigationView {
            if let birthday = birthday,
               let lifeProgress = LifeProgress(
                   birthday: birthday,
                   lifeExpectancy: lifeExpectancy
               )
            {
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
            } else {
                Welcome()
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
