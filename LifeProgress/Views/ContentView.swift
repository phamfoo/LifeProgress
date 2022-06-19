import Defaults
import SwiftUI

struct ContentView: View {
    @Default(.profileSetupCompleted) private var profileSetupCompleted

    var body: some View {
        if profileSetupCompleted {
            HomeScreen()
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
