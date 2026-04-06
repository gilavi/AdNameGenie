import SwiftUI

struct CreativeOutputSection: View {
    @Bindable var form: FormState
    @Environment(\.funMode) private var fun

    var body: some View {
        FormSection(number: 6, title: "Creative & Output", funTitle: "Who made it?", dimmed: form.brand == nil) {
            if let brand = form.brand {
                VStack(alignment: .leading, spacing: DS.fieldGap) {

                    // Creative Producer
                    VStack(alignment: .leading, spacing: 8) {
                        FieldLabel(text: "Creative Producer")
                        let producers = brand.config.creativeProducers
                        if producers.isEmpty {
                            // Free-text brand: avatar preview + text input
                            HStack(spacing: 12) {
                                ProducerAvatarChip(
                                    initials: form.customCreativeProducer.isEmpty ? "?" : form.customCreativeProducer,
                                    isSelected: false,
                                    isPreview: true,
                                    action: {}
                                )
                                TextField("Initials (e.g. JD)", text: Binding(
                                    get: { form.customCreativeProducer },
                                    set: { form.customCreativeProducer = $0.uppercased() }
                                ))
                                .textFieldStyle(.plain)
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 16).padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.03)))
                                .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).strokeBorder(fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1), lineWidth: 1))
                            }
                        } else {
                            // Predefined producers: avatar chip grid
                            FlowLayout(spacing: 10) {
                                ForEach(producers) { p in
                                    ProducerAvatarChip(
                                        initials: p.value,
                                        fullName: p.label,
                                        isSelected: form.creativeProducer == p.value,
                                        action: {
                                            withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                                                form.creativeProducer = p.value
                                            }
                                        }
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

// MARK: - Producer Avatar Chip

private struct ProducerAvatarChip: View {
    let initials: String
    var fullName: String = ""
    let isSelected: Bool
    var isPreview: Bool = false
    let action: () -> Void

    @State private var hovered = false
    @State private var pressing = false
    @Environment(\.funMode) private var fun

    // Deterministic color from initials
    private static let avatarColors: [Color] = [
        Color(red: 0.95, green: 0.4,  blue: 0.4),
        Color(red: 0.4,  green: 0.65, blue: 1.0),
        Color(red: 0.85, green: 0.5,  blue: 0.95),
        Color(red: 0.25, green: 0.82, blue: 0.58),
        Color(red: 1.0,  green: 0.68, blue: 0.25),
        Color(red: 0.55, green: 0.45, blue: 1.0),
        Color(red: 0.25, green: 0.88, blue: 0.88),
        Color(red: 1.0,  green: 0.45, blue: 0.62),
    ]
    private static let funEmojis = [
        "🎨","🖌️","🧑‍🎨","🦄","🌈","🎭","🎬","📸","🪄","🧙‍♀️","🎸","🥳","🦸","🤹","🎪","🎵","🌟","💅","🔥","⚡","🎯","🚀",
        "👽","🤖","🧛","🧜‍♀️","🦹","🐉","🦊","🐙","🎩","💎","🍕","🧁","🎮","🕹️","🛸","🌶️","🦑","🐱‍👤","🧞","🪩","🫧","🍭",
        "🏄","🤸","🎤","🧑‍🚀","🦋","🐸","🍄","🫠","🤯","👾","🧃","🎪","🏆","🎲","🃏","🦜","🐧","🦖","🧊","💫"
    ]

    private var avatarColor: Color {
        let hash = initials.unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
        return Self.avatarColors[abs(hash) % Self.avatarColors.count]
    }
    private var funEmoji: String {
        let hash = initials.unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
        return Self.funEmojis[abs(hash) % Self.funEmojis.count]
    }
    // Short display name (first name only)
    private var shortName: String {
        fullName.components(separatedBy: " ").first ?? initials
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                            ? (fun
                                ? LinearGradient(colors: [avatarColor, avatarColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(colors: [avatarColor.opacity(0.9), avatarColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : LinearGradient(colors: [avatarColor.opacity(fun ? 0.22 : 0.12), avatarColor.opacity(fun ? 0.14 : 0.08)], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 52, height: 52)
                        .shadow(color: isSelected ? avatarColor.opacity(fun ? 0.5 : 0.3) : .clear, radius: fun ? 8 : 5, y: 3)

                    if fun {
                        Text(funEmoji)
                            .font(.system(size: isPreview ? 18 : 22))
                    } else {
                        Text(initials.prefix(2).uppercased())
                            .font(.system(size: 15, weight: .black, design: .monospaced))
                            .foregroundStyle(isSelected ? .white : avatarColor.opacity(0.85))
                    }
                }
                .overlay {
                    Circle().stroke(
                        hovered && !isSelected ? avatarColor.opacity(0.3) : Color.clear,
                        lineWidth: 1
                    )
                }
                // Selection ring: gap + outer border
                .padding(3)
                .overlay {
                    if isSelected {
                        Circle().stroke(
                            fun ? avatarColor : .white,
                            lineWidth: 2.5
                        )
                    }
                }
                .padding(-3)
                .scaleEffect(pressing ? 0.92 : (hovered && !isPreview ? (fun ? 1.08 : 1.04) : 1.0))
                .offset(y: fun && pressing ? 3 : 0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: pressing)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: hovered)

                // Name below avatar (not shown for preview chip)
                if !isPreview && !fullName.isEmpty {
                    Text(shortName)
                        .font(.system(size: 11, weight: isSelected ? .bold : .medium, design: fun ? .rounded : .default))
                        .foregroundStyle(isSelected ? (fun ? .white : .primary) : .secondary)
                        .lineLimit(1)
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .buttonStyle(.plain)
        .onHover { h in withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { hovered = h } }
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in pressing = true }
            .onEnded   { _ in pressing = false }
        )
    }
}

