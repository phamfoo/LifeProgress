import Defaults
import Foundation

let extensionDefaults = UserDefaults(suiteName: "group.io.phaw.life-progress")!

extension Defaults.Keys {
    static let lifeExpectancy = Key<Int>("lifeExpectancy",
                                         default: 79,
                                         suite: extensionDefaults)
    static let birthday = Key<Date>("birthday", default: Life.getDefaultBirthday(), suite: extensionDefaults)
    static let profileSetupCompleted = Key<Bool>("profileSetupCompleted", default: false, suite: extensionDefaults)
}
