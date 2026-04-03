import SwiftUI

struct PlatformSection: View {
    @Bindable var form: FormState
    @Environment(\.funMode) private var fun

    private let columns = Array(repeating: GridItem(.flexible(), spacing: DS.gridGap), count: 4)

    var body: some View {
        FormSection(number: 3, title: "Platform", funTitle: "Where does it run?", dimmed: form.brand == nil) {
            LazyVGrid(columns: columns, spacing: DS.gridGap) {
                ForEach(Platform.allCases) { platform in
                    FilledPill(
                        label: platform.rawValue,
                        isSelected: form.platform == platform,
                        action: { form.platform = platform },
                        funGradient: FunColors.platformGradient(platform)
                    )
                }
            }
        }
    }
}
