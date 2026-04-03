import SwiftUI
import AppKit

// MARK: - Fun Color Palette

enum FunColors {
    static func brandGradient(_ brand: Brand) -> [Color] {
        switch brand {
        case .hint:         return [Color(red: 1.0, green: 0.82, blue: 0.0), Color(red: 1.0, green: 0.58, blue: 0.0)]
        case .clarityCheck: return [Color(red: 0.35, green: 0.88, blue: 1.0), Color(red: 0.15, green: 0.65, blue: 1.0)]
        case .cerebrum:     return [Color(red: 0.88, green: 0.38, blue: 1.0), Color(red: 0.6, green: 0.18, blue: 0.95)]
        case .vb:           return [Color(red: 1.0, green: 0.42, blue: 0.65), Color(red: 0.9, green: 0.22, blue: 0.5)]
        case .useAI:        return [Color(red: 0.25, green: 0.98, blue: 0.72), Color(red: 0.08, green: 0.82, blue: 0.55)]
        case .masterly:     return [Color(red: 0.52, green: 0.62, blue: 1.0), Color(red: 0.32, green: 0.42, blue: 0.95)]
        case .zendocs:      return [Color(red: 1.0, green: 0.58, blue: 0.35), Color(red: 0.95, green: 0.38, blue: 0.18)]
        case .sagaBox:      return [Color(red: 1.0, green: 0.62, blue: 0.92), Color(red: 0.88, green: 0.38, blue: 0.78)]
        case .getQR:        return [Color(red: 0.28, green: 0.95, blue: 0.95), Color(red: 0.12, green: 0.78, blue: 0.82)]
        case .jobAssist:    return [Color(red: 0.92, green: 0.82, blue: 0.38), Color(red: 0.88, green: 0.65, blue: 0.18)]
        }
    }

    static func brandGlow(_ brand: Brand) -> Color { brandGradient(brand).first! }

    static func brandEmoji(_ brand: Brand) -> [String] {
        switch brand {
        case .hint:         return ["💡","✨","🌟","💫"]
        case .clarityCheck: return ["👁","🔍","💎","🔮"]
        case .cerebrum:     return ["🧠","⚡","💜","🚀"]
        case .vb:           return ["💕","🌸","✨","💋"]
        case .useAI:        return ["🤖","⚡","🚀","💚"]
        case .masterly:     return ["👑","🏆","⭐","🌟"]
        case .zendocs:      return ["📄","✍️","🔥","💡"]
        case .sagaBox:      return ["📚","🎮","🌈","✨"]
        case .getQR:        return ["📱","🔗","💎","🎯"]
        case .jobAssist:    return ["💼","🚀","⚡","🏆"]
        }
    }

    static func platformGradient(_ platform: Platform) -> [Color] {
        switch platform {
        case .FB: return [Color(red: 0.32, green: 0.52, blue: 1.0), Color(red: 0.18, green: 0.38, blue: 0.95)]
        case .GL: return [Color(red: 1.0, green: 0.48, blue: 0.28), Color(red: 0.95, green: 0.32, blue: 0.12)]
        case .QU: return [Color(red: 0.62, green: 0.28, blue: 0.92), Color(red: 0.45, green: 0.12, blue: 0.82)]
        case .TT: return [Color(red: 1.0, green: 0.22, blue: 0.42), Color(red: 0.05, green: 0.88, blue: 0.88)]
        case .OB: return [Color(red: 0.28, green: 0.72, blue: 0.38), Color(red: 0.12, green: 0.55, blue: 0.28)]
        case .NB: return [Color(red: 1.0, green: 0.72, blue: 0.0), Color(red: 1.0, green: 0.48, blue: 0.0)]
        case .SP: return [Color(red: 0.48, green: 0.88, blue: 0.38), Color(red: 0.28, green: 0.72, blue: 0.22)]
        case .SF: return [Color(red: 0.72, green: 0.72, blue: 0.88), Color(red: 0.52, green: 0.52, blue: 0.78)]
        }
    }

    static func langGradient(_ code: String) -> [Color] {
        switch code {
        case "EN": return [Color(red: 0.18, green: 0.42, blue: 0.92), Color(red: 0.88, green: 0.12, blue: 0.22)]
        case "ES": return [Color(red: 1.0, green: 0.62, blue: 0.0), Color(red: 0.95, green: 0.32, blue: 0.12)]
        case "FR": return [Color(red: 0.18, green: 0.38, blue: 0.88), Color(red: 0.88, green: 0.18, blue: 0.28)]
        case "DE": return [Color(red: 1.0, green: 0.82, blue: 0.0), Color(red: 0.95, green: 0.55, blue: 0.0)]
        default:   return [Color(red: 0.5, green: 0.5, blue: 0.9), Color(red: 0.4, green: 0.4, blue: 0.75)]
        }
    }

    static let vidGradient: [Color] = [Color(red: 0.88, green: 0.22, blue: 0.98), Color(red: 0.62, green: 0.12, blue: 0.88)]
    static let imgGradient: [Color] = [Color(red: 0.12, green: 0.82, blue: 0.68), Color(red: 0.05, green: 0.65, blue: 0.52)]

    static let keycapTop: [Color] = [Color(white: 0.38), Color(white: 0.28)]
    static let keycapShadow = Color(white: 0.06)

    static let copyGradient: [Color] = [Color(red: 0.18, green: 0.88, blue: 0.52), Color(red: 0.08, green: 0.72, blue: 0.38)]
    static let copyShadow = Color(red: 0.04, green: 0.28, blue: 0.14)
    static let clearGradient: [Color] = [Color(red: 1.0, green: 0.32, blue: 0.32), Color(red: 0.88, green: 0.18, blue: 0.18)]
    static let clearShadow = Color(red: 0.32, green: 0.04, blue: 0.04)

    static let funnelGradients: [[Color]] = [
        [Color(red: 0.95, green: 0.5, blue: 0.2), Color(red: 0.85, green: 0.35, blue: 0.1)],
        [Color(red: 0.4, green: 0.7, blue: 1.0), Color(red: 0.25, green: 0.55, blue: 0.9)],
        [Color(red: 0.9, green: 0.45, blue: 0.8), Color(red: 0.75, green: 0.3, blue: 0.65)],
        [Color(red: 0.3, green: 0.85, blue: 0.6), Color(red: 0.15, green: 0.7, blue: 0.45)],
        [Color(red: 1.0, green: 0.7, blue: 0.3), Color(red: 0.9, green: 0.55, blue: 0.15)],
        [Color(red: 0.55, green: 0.5, blue: 0.95), Color(red: 0.4, green: 0.35, blue: 0.85)],
    ]

    static let creativeGradient: [Color] = [Color(red: 0.62, green: 0.22, blue: 0.95), Color(red: 0.42, green: 0.12, blue: 0.82)]
    static let creativeGlow = Color(red: 0.22, green: 0.06, blue: 0.42)
}

// MARK: - Design System

enum DS {
    static let radius: CGFloat = 12
    static let funRadius: CGFloat = 10
    static let sectionGap: CGFloat = 28
    static let fieldGap: CGFloat = 16
    static let innerGap: CGFloat = 14
    static let gridGap: CGFloat = 8
    static let formMaxWidth: CGFloat = 700
    static let formPad: CGFloat = 36
    // Standard padding for text fields and rows
    static let fieldPadV: CGFloat = 12
    static let fieldPadH: CGFloat = 16
}

// MARK: - 3D Keycap shape

struct KeyCapShape: View {
    var topColors: [Color]
    var shadowColor: Color
    var isPressed: Bool
    var cornerRadius: CGFloat = 9
    var depth: CGFloat = 7        // shadow depth

    var body: some View {
        ZStack {
            // base (shadow layer)
            RoundedRectangle(cornerRadius: cornerRadius + 1)
                .fill(shadowColor)
                .offset(y: isPressed ? 1 : depth)
            // face
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(LinearGradient(colors: topColors, startPoint: .top, endPoint: .bottom))
            // top shine
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.3), Color.white.opacity(0.0)],
                        startPoint: .top, endPoint: .center
                    )
                )
            // edge highlight
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.white.opacity(0.04)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Ambient glow background (fun mode)

struct AmbientGlow: View {
    var color: Color
    @State private var pulse = false

    var body: some View {
        ZStack {
            // Main blob
            Ellipse()
                .fill(color.opacity(0.18))
                .frame(width: 500, height: 400)
                .blur(radius: 80)
                .scaleEffect(pulse ? 1.08 : 1.0)
                .offset(x: 0, y: -60)
            // Secondary blob
            Ellipse()
                .fill(color.opacity(0.10))
                .frame(width: 300, height: 250)
                .blur(radius: 60)
                .scaleEffect(pulse ? 0.95 : 1.0)
                .offset(x: 80, y: 100)
        }
        .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: pulse)
        .onAppear { pulse = true }
    }
}

// MARK: - Confetti dots background (fun mode)

struct ConfettiDots: View {
    private struct Dot: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let color: Color
        let opacity: Double
    }

    private let dots: [Dot] = {
        let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .purple, .pink, .mint]
        return (0..<36).map { _ in
            Dot(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 4...10),
                color: colors.randomElement()!,
                opacity: Double.random(in: 0.12...0.28)
            )
        }
    }()

    var body: some View {
        GeometryReader { geo in
            ForEach(dots) { dot in
                Circle()
                    .fill(dot.color)
                    .frame(width: dot.size, height: dot.size)
                    .opacity(dot.opacity)
                    .position(x: dot.x * geo.size.width, y: dot.y * geo.size.height)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Pop burst (localized particle effect)

private struct BurstParticle: Identifiable {
    let id = UUID()
    let emoji: String
    let angle: Double
}

private struct BurstParticleView: View {
    let particle: BurstParticle
    @State private var distance: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 0.2
    @State private var spin: Double = 0

    var body: some View {
        Text(particle.emoji)
            .font(.system(size: 18))
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(
                x: cos(particle.angle * .pi / 180) * distance,
                y: -sin(particle.angle * .pi / 180) * distance
            )
            .rotationEffect(.degrees(spin))
            .onAppear {
                withAnimation(.spring(response: 0.38, dampingFraction: 0.62)) {
                    distance = CGFloat.random(in: 50...80)
                    scale = CGFloat.random(in: 0.85...1.2)
                    spin = Double.random(in: -25...25)
                }
                withAnimation(.easeOut(duration: 0.45).delay(0.25)) { opacity = 0 }
            }
    }
}

struct PopBurst: ViewModifier {
    @Binding var trigger: Bool
    var emojis: [String] = ["✨","🎉","💥","⚡","🔥","💫","🎊","🥳","💎","🌈"]
    @State private var particles: [BurstParticle] = []
    @Environment(\.funMode) private var fun

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
                if fun {
                    ZStack {
                        ForEach(particles) { p in BurstParticleView(particle: p) }
                    }
                    .allowsHitTesting(false)
                }
            }
            .onChange(of: trigger) { _, newVal in
                guard newVal, fun else { if newVal { trigger = false }; return }
                trigger = false
                fire()
            }
    }

    private func fire() {
        let count = 6
        particles = (0..<count).map { i in
            BurstParticle(
                emoji: emojis.randomElement()!,
                angle: Double(i) * (360.0 / Double(count)) + Double.random(in: -15...15)
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { particles = [] }
    }
}

// MARK: - FilledPill

struct FilledPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    var icon: String? = nil
    var funGradient: [Color]? = nil
    @State private var pressing = false
    @State private var hovering = false
    @State private var burstTrigger = false
    @Environment(\.funMode) private var fun

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.65)) { action() }
            if fun { burstTrigger = true }
        }) {
            VStack(spacing: fun ? 4 : 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                        .symbolEffect(.bounce, value: isSelected)
                }
                Text(label)
                    .font(.system(size: 15, weight: isSelected ? .bold : .medium, design: fun ? .rounded : .default))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(fun ? .white : (isSelected ? Color(.windowBackgroundColor) : .primary))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .background {
                if fun {
                    let dimGrad: [Color] = funGradient != nil
                        ? funGradient!.map { $0.opacity(0.2) }
                        : FunColors.keycapTop
                    let colors = isSelected ? (funGradient ?? FunColors.keycapTop) : dimGrad
                    let shadow = isSelected ? (funGradient?.first?.opacity(0.45) ?? FunColors.keycapShadow) : FunColors.keycapShadow
                    KeyCapShape(topColors: colors, shadowColor: shadow, isPressed: pressing, depth: 7)
                } else {
                    RoundedRectangle(cornerRadius: DS.radius)
                        .fill(isSelected ? Color.primary : Color.primary.opacity(hovering ? 0.09 : (pressing ? 0.07 : 0.04)))
                }
            }
            .overlay {
                if !fun {
                    RoundedRectangle(cornerRadius: DS.radius)
                        .stroke(Color.primary.opacity(isSelected ? 0 : (hovering ? 0.16 : 0.09)), lineWidth: isSelected ? 0 : (hovering ? 1.5 : 1))
                }
            }
            .offset(y: fun ? (pressing ? 6 : 0) : 0)
            .scaleEffect(fun ? (hovering && !pressing ? 1.05 : 1.0) : (hovering && !pressing ? 1.02 : (pressing ? 0.96 : 1.0)))
            .rotation3DEffect(.degrees(fun && hovering && !pressing ? -5 : 0), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
            .shadow(color: fun && isSelected ? (funGradient?.first?.opacity(0.5) ?? .clear) : .clear, radius: 10, y: 5)
        }
        .buttonStyle(.plain)
        .onHover { h in withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) { hovering = h } }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.07)) { pressing = true } }
                .onEnded   { _ in withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { pressing = false } }
        )
        .modifier(PopBurst(trigger: $burstTrigger, emojis: funGradient != nil ? ["✨","💥","⚡","🔥","💫","🎊"] : ["✨","🎉","💥","💫","⚡","🌈"]))
        .modifier(CleanShadow(isSelected: isSelected, isHovered: hovering))
    }
}

// MARK: - Brand card

struct BrandCard: View {
    let brand: Brand
    let isSelected: Bool
    let action: () -> Void
    @State private var pressing = false
    @State private var hovering = false
    @State private var wiggle = false
    @State private var burstTrigger = false
    @Environment(\.funMode) private var fun

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.55)) { action() }
            if fun { burstTrigger = true }
        }) {
                VStack(spacing: 7) {
                    ZStack {
                        Circle()
                            .fill(fun ? Color.white.opacity(isSelected ? 0.22 : 0.1) : (isSelected ? Color(.windowBackgroundColor).opacity(0.18) : Color.primary.opacity(0.06)))
                            .frame(width: 52, height: 52)
                        Image(systemName: brand.icon)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(fun ? .white : (isSelected ? Color(.windowBackgroundColor) : .primary))
                            .symbolEffect(.bounce, value: isSelected)
                    }
                    VStack(spacing: 3) {
                        Text(brand.rawValue)
                            .font(.system(size: 14, weight: isSelected ? .black : .semibold, design: fun ? .rounded : .default))
                            .lineLimit(1)
                            .minimumScaleFactor(0.93)   // never below ~13pt
                        if brand.rawValue != brand.config.abbreviation {
                            Text(brand.config.abbreviation)
                                .font(.system(size: 13, weight: .medium, design: .monospaced))
                                .opacity(0.55)
                        }
                    }
                    .foregroundStyle(fun ? .white : (isSelected ? Color(.windowBackgroundColor) : .primary))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .padding(.horizontal, 8)
                .background {
                    if fun {
                        let dimBrand = FunColors.brandGradient(brand).map { $0.opacity(0.2) }
                        let colors = isSelected ? FunColors.brandGradient(brand) : dimBrand
                        let shadow = isSelected ? FunColors.brandGlow(brand).opacity(0.6) : FunColors.keycapShadow
                        KeyCapShape(topColors: colors, shadowColor: shadow, isPressed: pressing, depth: 8)
                    } else {
                        RoundedRectangle(cornerRadius: DS.radius)
                            .fill(isSelected ? Color.primary : Color.primary.opacity(hovering ? 0.08 : (pressing ? 0.07 : 0.03)))
                    }
                }
                .overlay {
                    if !fun {
                        RoundedRectangle(cornerRadius: DS.radius)
                            .stroke(Color.primary.opacity(isSelected ? 0 : (hovering ? 0.16 : 0.09)), lineWidth: isSelected ? 0 : (hovering ? 1.5 : 1))
                    }
                }
                .offset(y: fun ? (pressing ? 7 : 0) : 0)
                .rotationEffect(.degrees(fun && wiggle ? 1.5 : 0))
                .scaleEffect(fun ? (hovering && !pressing ? 1.08 : 1.0) : (hovering && !pressing ? 1.03 : (pressing ? 0.95 : 1.0)))
                .rotation3DEffect(.degrees(fun && hovering && !pressing ? -7 : 0), axis: (x: 1, y: 0, z: 0), perspective: 0.5)
                .shadow(color: fun && isSelected ? FunColors.brandGlow(brand).opacity(0.6) : .clear, radius: 16, y: 6)
            }
            .buttonStyle(.plain)
            .onHover { h in
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) { hovering = h }
                if h && fun {
                    withAnimation(.easeInOut(duration: 0.12).repeatCount(3, autoreverses: true)) { wiggle = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { wiggle = false }
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in withAnimation(.easeOut(duration: 0.07)) { pressing = true } }
                    .onEnded   { _ in withAnimation(.spring(response: 0.2, dampingFraction: 0.4)) { pressing = false } }
            )
        .modifier(PopBurst(trigger: $burstTrigger, emojis: FunColors.brandEmoji(brand)))
        .modifier(CleanShadow(isSelected: isSelected, isHovered: hovering))
    }
}

// MARK: - Selectable row

struct SelectableRow: View {
    let label: String
    let code: String
    let isSelected: Bool
    let action: () -> Void
    var icon: String? = nil
    var funSelectedGradient: [Color]? = nil
    var funAvatar: (emoji: String, color: Color)? = nil
    @State private var hovered = false
    @State private var pressing = false
    @Environment(\.funMode) private var fun

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) { action() }
        }) {
            HStack(spacing: 12) {
                // Fun avatar (emoji circle)
                if fun, let avatar = funAvatar {
                    ZStack {
                        Circle()
                            .fill(avatar.color.opacity(isSelected ? 0.3 : 0.15))
                            .frame(width: 30, height: 30)
                        Text(avatar.emoji)
                            .font(.system(size: 14))
                    }
                    .shadow(color: isSelected ? avatar.color.opacity(0.3) : .clear, radius: 4, y: 2)
                } else if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(isSelected ? .green : .secondary)
                        .frame(width: 22)
                }
                if !code.isEmpty {
                    Text(code)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(isSelected ? .primary : .tertiary)
                        .frame(width: 30, alignment: .leading)
                }
                Text(label)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular, design: fun ? .rounded : .default))
                Spacer()
                if isSelected {
                    Image(systemName: fun ? "checkmark.seal.fill" : "checkmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: isSelected)
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .foregroundStyle(fun ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background {
                if fun {
                    let defaultSelected: [Color] = [Color(red: 0.18, green: 0.48, blue: 0.32), Color(red: 0.1, green: 0.35, blue: 0.22)]
                    let dimRow: [Color] = funSelectedGradient != nil
                        ? funSelectedGradient!.map { $0.opacity(0.18) }
                        : defaultSelected.map { $0.opacity(0.18) }
                    let colors = isSelected
                        ? (funSelectedGradient ?? defaultSelected)
                        : dimRow
                    let shadow = isSelected ? (funSelectedGradient?.first?.opacity(0.4) ?? Color(red: 0.05, green: 0.18, blue: 0.1)) : FunColors.keycapShadow
                    KeyCapShape(topColors: colors, shadowColor: shadow, isPressed: pressing, depth: 5)
                } else {
                    RoundedRectangle(cornerRadius: DS.radius)
                        .fill(isSelected ? Color.primary.opacity(0.07) : Color.primary.opacity(hovered ? 0.05 : 0))
                }
            }
            .overlay {
                if !fun {
                    RoundedRectangle(cornerRadius: DS.radius)
                        .stroke(Color.primary.opacity(isSelected ? 0.16 : (hovered ? 0.14 : 0.07)), lineWidth: isSelected ? 1.5 : (hovered ? 1.5 : 1))
                }
            }
            .offset(y: fun ? (pressing ? 4 : 0) : 0)
            .overlay(alignment: .leading) {
                if !fun && isSelected {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.green)
                        .frame(width: 2.5)
                        .padding(.vertical, 8)
                        .transition(.opacity.combined(with: .scale(scale: 0.5, anchor: .leading)))
                }
            }
            .modifier(CleanShadow(isSelected: isSelected, isHovered: hovered))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovered = $0 }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.06)) { pressing = true } }
                .onEnded   { _ in withAnimation(.spring(response: 0.22, dampingFraction: 0.45)) { pressing = false } }
        )
    }
}

// MARK: - Other field card

struct OtherFieldCard: View {
    let isActive: Bool
    let placeholder: String
    @Binding var text: String
    let onActivate: () -> Void
    @State private var hovered = false
    @State private var pressing = false
    @FocusState private var focused: Bool
    @Environment(\.funMode) private var fun

    var body: some View {
        Group {
            if isActive {
                HStack(spacing: 10) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12))
                        .foregroundStyle(fun ? .yellow : .secondary)
                    TextField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14, design: fun ? .rounded : .default))
                        .focused($focused)
                    Button { text = ""; onActivate() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(fun ? .white.opacity(0.5) : Color.secondary.opacity(0.5))
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
                .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.16) : Color.primary.opacity(0.04)))
                .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).strokeBorder(fun ? Color.yellow.opacity(0.4) : Color.primary.opacity(0.18), lineWidth: fun ? 2 : 1.5))
                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { focused = true } }
            } else {
                Button(action: onActivate) {
                    HStack(spacing: 8) {
                        Image(systemName: fun ? "plus.circle.fill" : "plus.circle")
                            .font(.system(size: 12))
                            .foregroundStyle(fun ? Color.yellow.opacity(0.7) : Color.secondary.opacity(0.5))
                        Text(fun ? "Something else?" : "Other...")
                            .font(.system(size: 14, design: fun ? .rounded : .default))
                            .foregroundStyle(fun ? Color.white.opacity(0.6) : Color.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background {
                        if fun {
                            KeyCapShape(topColors: [Color.yellow.opacity(0.15), Color.orange.opacity(0.1)], shadowColor: FunColors.keycapShadow, isPressed: pressing, depth: 5)
                        } else {
                            RoundedRectangle(cornerRadius: DS.radius).fill(Color.primary.opacity(hovered ? 0.03 : 0))
                        }
                    }
                    .overlay {
                        if fun {
                            RoundedRectangle(cornerRadius: DS.funRadius)
                                .strokeBorder(Color.white.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
                        } else {
                            RoundedRectangle(cornerRadius: DS.radius).stroke(Color.primary.opacity(0.07), lineWidth: 1)
                        }
                    }
                    .offset(y: fun ? (pressing ? 4 : 0) : 0)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .onHover { hovered = $0 }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in guard fun else { return }; withAnimation(.easeOut(duration: 0.06)) { pressing = true } }
                        .onEnded   { _ in guard fun else { return }; withAnimation(.spring(response: 0.22, dampingFraction: 0.45)) { pressing = false } }
                )
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.78), value: isActive)
    }
}

// MARK: - Section container

struct FormSection<Content: View>: View {
    let number: Int
    let title: String
    var funTitle: String? = nil
    var dimmed: Bool = false
    @ViewBuilder let content: Content
    @Environment(\.funMode) private var fun

    private var lockedText: String {
        switch number {
        case 3: return "Platforms unlock after brand! 🔓"
        case 4: return "Brand first, then funnels 🔮"
        case 6: return "Brand sets the options here ✨"
        default: return "Pick a brand first, bestie! 🔒"
        }
    }

    private var emoji: String {
        ["🎯","⚡","🌐","🔮","🗓️","🎨"][max(0, min(number-1, 5))]
    }
    private var sectionColor: Color {
        [Color.red, Color.orange, Color.yellow, Color.green, Color.cyan, Color.purple][max(0, min(number-1, 5))]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DS.fieldGap) {
            HStack(spacing: 10) {
                if fun {
                    Text(emoji)
                        .font(.system(size: 24))
                        .scaleEffect(dimmed ? 0.6 : 1.0)
                        .opacity(dimmed ? 0.3 : 1)
                        .animation(.spring(response: 0.38, dampingFraction: 0.5), value: dimmed)
                } else {
                    ZStack {
                        Circle()
                            .fill(dimmed ? Color.primary.opacity(0.05) : Color.primary)
                            .frame(width: 27, height: 27)
                        Text("\(number)")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(dimmed ? Color.secondary : Color(.windowBackgroundColor))
                    }
                    .scaleEffect(dimmed ? 0.82 : 1.0)
                    .animation(.spring(response: 0.38, dampingFraction: 0.5), value: dimmed)
                }

                Text(fun && funTitle != nil ? funTitle! : title)
                    .font(.system(size: fun ? 18 : 16, weight: .bold, design: fun ? .rounded : .default))
                    .foregroundStyle(dimmed ? Color.secondary : (fun ? sectionColor : Color.primary))
            }

            if !dimmed {
                content.transition(.move(edge: .top).combined(with: .opacity))
            } else {
                HStack(spacing: 6) {
                    Text(fun ? lockedText : "Select a brand first")
                }
                .font(.system(size: 14, design: fun ? .rounded : .default))
                .foregroundStyle(fun ? Color.secondary.opacity(0.5) : Color.secondary.opacity(0.35))
                .padding(.vertical, 4)
            }
        }
        .opacity(dimmed ? 0.45 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dimmed)
    }
}

struct FieldLabel: View {
    let text: String
    @Environment(\.funMode) private var fun
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold, design: fun ? .rounded : .default))
            .foregroundStyle(fun ? Color.white.opacity(0.5) : .secondary)
            .textCase(.uppercase)
            .tracking(0.6)
    }
}

// MARK: - Staggered entrance wrapper

struct AnimatedEntry<Content: View>: View {
    var delay: Double = 0
    @ViewBuilder let content: Content
    @State private var appeared = false

    var body: some View {
        content
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.92)
            .offset(y: appeared ? 0 : 18)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.72).delay(delay)) { appeared = true }
            }
    }
}

// MARK: - Toast

struct CopiedToast: View {
    @Environment(\.funMode) private var fun
    @State private var spin = false
    @State private var funMessage = CopiedToast.randomFunMessage()

    private static let funMessages = [
        "COPIED! You legend! 🔥", "Snagged it! 💪", "In the clipboard! 🎯",
        "Boom! Got it! 💥", "Copy that, chief! 🫡", "Locked and loaded! 🔒",
        "You're on fire! 🔥", "Smooth operator! 😎", "Nailed it! 🎯",
        "That's a wrap! 🎬", "Mission complete! 🚀", "Chef's kiss! 👨‍🍳",
        "Perfection! ✨", "Big brain move! 🧠", "Clipboard? Loaded. 📋",
        "Ctrl+V ready! ⌨️", "One-click wonder! 🪄", "Like butter! 🧈",
        "Too easy! 😏", "Another one! 🎵", "Say less! 🤫",
        "Done and dusted! ✅", "Clipboard go brrrr! 🖨️", "Magic! 🪄✨",
        "Absolute unit! 💎", "Speed run! ⚡", "No cap! 🧢",
        "W move! 🏆", "You ate that! 🍽️", "Main character energy! 👑",
    ]

    private static func randomFunMessage() -> String {
        funMessages.randomElement()!
    }

    var body: some View {
        HStack(spacing: 10) {
            if fun {
                Text("🎉")
                    .font(.system(size: 22))
                    .rotationEffect(.degrees(spin ? 20 : -20))
                    .animation(.easeInOut(duration: 0.15).repeatCount(5, autoreverses: true), value: spin)
                    .onAppear { spin = true; funMessage = CopiedToast.randomFunMessage() }
            } else {
                ZStack {
                    Circle().fill(.green).frame(width: 24, height: 24)
                    Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                }
            }
            Text(fun ? funMessage : "Copied!")
                .font(.system(size: 14, weight: .black, design: fun ? .rounded : .default))
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 13)
        .background {
            if fun {
                Capsule()
                    .fill(LinearGradient(
                        colors: [Color(red: 0.18, green: 0.9, blue: 0.55), Color(red: 0.1, green: 0.72, blue: 0.4)],
                        startPoint: .leading, endPoint: .trailing
                    ))
                    .shadow(color: .green.opacity(0.5), radius: 20, y: 5)
            } else {
                Capsule().fill(.ultraThickMaterial)
            }
        }
        .foregroundStyle(fun ? .white : .primary)
        .shadow(color: fun ? .green.opacity(0.4) : .black.opacity(0.14), radius: 20, y: 8)
    }
}

// MARK: - Clean mode shadow modifier

struct CleanShadow: ViewModifier {
    let isSelected: Bool
    let isHovered: Bool
    @Environment(\.funMode) private var fun

    func body(content: Content) -> some View {
        content.shadow(
            color: fun ? .clear : Color.black.opacity(isSelected ? 0.06 : (isHovered ? 0.08 : 0.03)),
            radius: fun ? 0 : (isSelected ? 3 : (isHovered ? 4 : 2)),
            x: 0,
            y: fun ? 0 : (isSelected ? 1 : (isHovered ? 2 : 1))
        )
    }
}

// MARK: - Main ContentView

struct ContentView: View {
    var form: FormState
    var historyStore: HistoryStore
    @State private var activeTab: Tab = .generator
    @State private var headerAppeared = false
    @State private var toggleBurst = false
    @State private var scrollTarget: NavSection?
    @AppStorage("funMode") private var funModeEnabled = false

    enum Tab { case generator, history }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerBar
                Divider()
                if activeTab == .generator {
                    generatorLayout
                } else {
                    HistoryView(historyStore: historyStore, form: form)
                }
            }

            if form.showCopiedToast {
                VStack {
                    Spacer()
                    CopiedToast().padding(.bottom, 32)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.65), value: form.showCopiedToast)
            }
        }
        .frame(minWidth: 940, minHeight: 620)
        .environment(\.funMode, funModeEnabled)
        .animation(.easeInOut(duration: 0.3), value: funModeEnabled)
        .onAppear {
            setupKeys()
            // Prevent auto-focus on text fields when window opens
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NSApp.keyWindow?.makeFirstResponder(nil)
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(spacing: 14) {
            HStack(spacing: 6) {
                if funModeEnabled { Text("✨").font(.system(size: 14)) }
                Text("Ad Name Genie")
                    .font(.system(size: 14, weight: .bold, design: funModeEnabled ? .rounded : .default))
                Text("Internal")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 7).padding(.vertical, 3)
                    .background(Color.secondary.opacity(0.08))
                    .clipShape(Capsule())
            }

            // Fun mode toggle — native switch
            HStack(spacing: 6) {
                Toggle(isOn: Binding(
                    get: { funModeEnabled },
                    set: { newValue in
                        withAnimation(.easeInOut(duration: 0.3)) { funModeEnabled = newValue }
                        if newValue { toggleBurst = true }
                    }
                )) {
                    HStack(spacing: 4) {
                        Image(systemName: funModeEnabled ? "sparkles" : "circle.grid.2x2")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(funModeEnabled ? .yellow : .secondary)
                            .contentTransition(.symbolEffect(.replace))
                        Text(funModeEnabled ? "Fun Mode" : "Clean")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(funModeEnabled ? .yellow : .primary)
                    }
                }
                .toggleStyle(.switch)
                .controlSize(.small)
            }
            .modifier(PopBurst(trigger: $toggleBurst, emojis: ["✨","🎉","🌈","💥","⚡","💫","🎊","🥳"]))

            Spacer()

            HStack(spacing: 2) {
                headerTab("Generator", tab: .generator)
                headerTab("History" + (!historyStore.entries.isEmpty ? " \(historyStore.entries.count)" : ""), tab: .history)
            }
            .padding(3)
            .background(Color.primary.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 24).padding(.vertical, 11)
        .background {
            if funModeEnabled {
                Color(red: 0.07, green: 0.06, blue: 0.12)
            } else {
                Rectangle().fill(.bar)
            }
        }
        .offset(y: headerAppeared ? 0 : -28)
        .opacity(headerAppeared ? 1 : 0)
        .onAppear { withAnimation(.spring(response: 0.5, dampingFraction: 0.78).delay(0.05)) { headerAppeared = true } }
    }

    private func headerTab(_ label: String, tab: Tab) -> some View {
        Button { withAnimation(.easeOut(duration: 0.15)) { activeTab = tab } } label: {
            Text(label)
                .font(.system(size: 12, weight: activeTab == tab ? .semibold : .regular, design: funModeEnabled ? .rounded : .default))
                .padding(.horizontal, 14).padding(.vertical, 6)
                .background(activeTab == tab ? Color(.controlBackgroundColor) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: activeTab == tab ? .black.opacity(0.06) : .clear, radius: 2, y: 1)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Generator layout

    private var generatorLayout: some View {
        HStack(spacing: 0) {
            // Left: progress bar + form
            VStack(spacing: 0) {
                ProgressBar(form: form, onScrollTo: { s in scrollTarget = s }, onClearAll: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { form.clearAll() }
                })

                if funModeEnabled { Color.white.opacity(0.06).frame(height: 1) } else { Divider() }

                // Form area
                ZStack {
                    if funModeEnabled {
                        Color(red: 0.10, green: 0.08, blue: 0.16)
                        ConfettiDots()
                        if let brand = form.brand {
                            AmbientGlow(color: FunColors.brandGlow(brand))
                                .animation(.easeInOut(duration: 0.8), value: brand)
                        }
                    }

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: DS.sectionGap) {
                                BrandSection(form: form)
                                    .id(NavSection.brand)
                                sectionDivider

                                if form.brand == nil {
                                    VStack(spacing: 8) {
                                        Text(funModeEnabled ? "👆" : "")
                                            .font(.system(size: 28))
                                        Text(funModeEnabled ? "Psst! Pick a brand up there to unlock\nthe magic! 🪄" : "Pick a brand above to continue")
                                            .font(.system(size: 13, weight: funModeEnabled ? .semibold : .regular, design: funModeEnabled ? .rounded : .default))
                                            .foregroundStyle(.tertiary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.horizontal, 16).padding(.vertical, 10)
                                    .background(funModeEnabled ? Color.purple.opacity(0.1) : Color.primary.opacity(0.04))
                                    .clipShape(Capsule())
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 40)
                                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
                                } else {
                                    Group {
                                        AnimatedEntry(delay: 0.00) {
                                            TypeTaskSection(form: form).id(NavSection.typeTask)
                                        }
                                        sectionDivider
                                        AnimatedEntry(delay: 0.07) {
                                            PlatformSection(form: form).id(NavSection.platform)
                                        }
                                        sectionDivider
                                        AnimatedEntry(delay: 0.13) {
                                            FunnelInfoSection(form: form).id(NavSection.funnelInfo)
                                        }
                                        sectionDivider
                                        AnimatedEntry(delay: 0.19) {
                                            LanguageDateSection(form: form).id(NavSection.languageDate)
                                        }
                                        sectionDivider
                                        AnimatedEntry(delay: 0.25) {
                                            CreativeOutputSection(form: form).id(NavSection.creativeOutput)
                                        }
                                    }
                                    .transition(.opacity)
                                }

                                Spacer(minLength: 48)
                            }
                            .padding(.horizontal, DS.formPad)
                            .padding(.vertical, DS.formPad)
                            .frame(maxWidth: DS.formMaxWidth + DS.formPad * 2)
                            .frame(maxWidth: .infinity)
                            // Tap empty space → resign text field focus
                            .onTapGesture { NSApp.keyWindow?.makeFirstResponder(nil) }
                        }
                        .onChange(of: scrollTarget) { _, target in
                            guard let target else { return }
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                proxy.scrollTo(target, anchor: .top)
                            }
                            scrollTarget = nil
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: form.brand == nil)
            }

            if funModeEnabled { Color.white.opacity(0.06).frame(width: 1) } else { Divider() }

            PreviewPanel(form: form, historyStore: historyStore, onScrollTo: { s in scrollTarget = s })
                .frame(width: 265)
        }
    }

    @ViewBuilder private var sectionDivider: some View {
        if funModeEnabled {
            Rectangle()
                .fill(LinearGradient(
                    colors: [.clear, .purple.opacity(0.3), .pink.opacity(0.2), .cyan.opacity(0.2), .clear],
                    startPoint: .leading, endPoint: .trailing
                ))
                .frame(height: 1)
        } else {
            Rectangle()
                .fill(Color.primary.opacity(0.05))
                .frame(height: 1)
        }
    }

    // MARK: - Keyboard

    private func setupKeys() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { e in
            if e.modifierFlags.contains([.command, .shift]), e.charactersIgnoringModifiers?.lowercased() == "c" {
                if form.canCopy { historyStore.add(filename: form.generatedFilename, form: form) }
                form.copyToClipboard(); return nil
            }
            guard !e.modifierFlags.contains(.command) else { return e }
            if let r = NSApp.keyWindow?.firstResponder, r is NSTextView { return e }
            switch e.charactersIgnoringModifiers?.lowercased() {
            case "v": form.typeLabel = .vid; return nil
            case "i": form.typeLabel = .img; return nil
            case "f": form.platform = .FB; return nil
            case "g": form.platform = .GL; return nil
            case "q": form.platform = .QU; return nil
            case "t": form.platform = .TT; return nil
            case "1": form.language = "EN"; form.useOtherLanguage = false; return nil
            case "2": form.language = "ES"; form.useOtherLanguage = false; return nil
            case "3": form.language = "FR"; form.useOtherLanguage = false; return nil
            case "4": form.language = "DE"; form.useOtherLanguage = false; return nil
            default: return e
            }
        }
    }
}
