import Defaults
import SwiftUI

struct ContentView: View {
    @Default(.lifeExpectancy) private var lifeExpectancy
    @Default(.birthday) private var birthday

    var body: some View {
        if let life = getCurrentLife() {
            Home(life: life)
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
