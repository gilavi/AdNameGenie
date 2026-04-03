import SwiftUI

struct FunModeKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var funMode: Bool {
        get { self[FunModeKey.self] }
        set { self[FunModeKey.self] = newValue }
    }
}
