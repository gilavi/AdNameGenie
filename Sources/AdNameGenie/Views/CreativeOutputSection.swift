import SwiftUI

struct CreativeOutputSection: View {
    @Bindable var form: FormState
    @Environment(\.funMode) private var fun

    private static let avatarEmojis = ["🎨","🖌️","🎭","🦄","🌈","🎸","🎷","🧑‍🎨","👩‍🎨","👨‍🎨","🎬","🎥","📸","🖼️","✏️","🪄","🧙‍♀️","🦸‍♀️","🤹‍♀️","🎪","🎠","🥁","🎹","🎵","📐","🎶","🧙‍♂️","🦸‍♂️","🤹‍♂️","🎺"]
    private static let avatarColors: [Color] = [
        Color(red: 0.95, green: 0.4, blue: 0.4),
        Color(red: 0.4, green: 0.7, blue: 1.0),
        Color(red: 0.9, green: 0.55, blue: 0.9),
        Color(red: 0.3, green: 0.85, blue: 0.6),
        Color(red: 1.0, green: 0.7, blue: 0.3),
        Color(red: 0.6, green: 0.5, blue: 1.0),
        Color(red: 0.3, green: 0.9, blue: 0.9),
        Color(red: 1.0, green: 0.5, blue: 0.65),
    ]

    private func avatar(for initials: String) -> (emoji: String, color: Color) {
        let hash = initials.unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
        let emoji = Self.avatarEmojis[abs(hash) % Self.avatarEmojis.count]
        let color = Self.avatarColors[abs(hash) % Self.avatarColors.count]
        return (emoji, color)
    }

    var body: some View {
        FormSection(number: 6, title: "Creative & Output", funTitle: "Who made it?", dimmed: form.brand == nil) {
            if let brand = form.brand {
                VStack(alignment: .leading, spacing: DS.fieldGap) {

                    // Creative Producer
                    VStack(alignment: .leading, spacing: 8) {
                        FieldLabel(text: "Creative Producer")
                        let producers = brand.config.creativeProducers
                        if producers.isEmpty {
                            TextField("Enter CP initials (e.g., JD)", text: $form.customCreativeProducer)
                                .textFieldStyle(.plain)
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.03)))
                                .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).strokeBorder(fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1), lineWidth: 1))
                        } else {
                            VStack(spacing: 6) {
                                ForEach(producers) { p in
                                    SelectableRow(
                                        label: p.label,
                                        code: p.value,
                                        isSelected: form.creativeProducer == p.value,
                                        action: { form.creativeProducer = p.value },
                                        funSelectedGradient: FunColors.creativeGradient,
                                        funAvatar: fun ? avatar(for: p.value) : nil
                                    )
                                }
                            }
                        }
                    }

                    // Resolution
                    VStack(alignment: .leading, spacing: 8) {
                        FieldLabel(text: "Resolution")
                        VStack(spacing: 6) {
                            ForEach(brand.config.resolutions) { res in
                                SelectableRow(
                                    label: res.label,
                                    code: "",
                                    isSelected: !form.useOtherResolution && form.resolution == res.value,
                                    action: {
                                        form.resolution = res.value
                                        form.useOtherResolution = false
                                    },
                                    icon: resIcon(res.value)
                                )
                            }
                            OtherFieldCard(
                                isActive: form.useOtherResolution,
                                placeholder: "e.g., 1920x1080",
                                text: $form.customResolution,
                                onActivate: {
                                    form.useOtherResolution.toggle()
                                    if !form.useOtherResolution {
                                        form.customResolution = ""
                                        form.resolution = brand.config.resolutions.first?.value ?? ""
                                    } else {
                                        form.resolution = ""
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    private func resIcon(_ v: String) -> String {
        if v.starts(with: "1080x19") { return "rectangle.portrait" }
        if v.contains("1080x1080") { return "square" }
        return "rectangle"
    }
}
