import Defaults
import SwiftUI

struct ContentView: View {
    @Default(.lifeExpectancy) private var lifeExpectancy
    @Default(.birthday) private var birthday

    var body: some View {
        if let life = getCurrentLife() {
            HomeScreen(life: life)
        } else {
            WelcomeScreen()
        }
    }

    func getCurrentLife() -> Life? {
        guard let birthday = birthday,
              let life = Life(
                  birthday: birthday,
                  lifeExpectancy: lifeExpectancy
              )
        else {
            return nil
        }

        return life
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
