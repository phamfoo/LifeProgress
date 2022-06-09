import Defaults
import SwiftUI

struct ContentView: View {
    @Default(.lifeExpectancy) private var lifeExpectancy
    @Default(.birthday) private var birthday
    @Default(.profileSetupCompleted) var profileSetupCompleted

    var body: some View {
        if profileSetupCompleted {
            let life = Life(
                birthday: birthday,
                lifeExpectancy: lifeExpectancy
            )!
            
            HomeScreen(life: life)
        } else {
            OnboardingScreen()
        }
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
