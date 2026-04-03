import SwiftUI

enum NavSection: String, CaseIterable, Identifiable {
    case brand = "Brand"
    case typeTask = "Type & Task"
    case platform = "Platform"
    case funnelInfo = "Funnel & Info"
    case languageDate = "Language & Date"
    case creativeOutput = "Creative & Output"

    var id: String { rawValue }
}
