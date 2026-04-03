import SwiftUI

// MARK: - Preference Key (captures fun-mode toggle frame in window coordinates)

struct ToggleFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        let n = nextValue()
        if n != .zero { value = n }
    }
}

// MARK: - Onboarding Tour Overlay

struct OnboardingTour: View {
    @Binding var isVisible: Bool
    var toggleFrame: CGRect

    @State private var step = 0
    @State private var appeared = false
    @State private var bounce = false

    var body: some View {
        ZStack {
            if step == 0 {
                menuBarStep
                    .id("step0")
            } else {
                funModeStep
                    .id("step1")
            }
        }
        .animation(.easeInOut(duration: 0.22), value: step)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) { appeared = true }
            withAnimation(.easeInOut(duration: 0.65).repeatForever(autoreverses: true)) { bounce = true }
        }
    }

    // ─────────────────────────────────────────────────────────────────────
    // MARK: Step 0 — Menu Bar discovery
    // ─────────────────────────────────────────────────────────────────────

    private var menuBarStep: some View {
        ZStack {
            Color.black.opacity(0.70)
                .ignoresSafeArea()

            // Tap outside to dismiss (belt-and-suspenders)
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { } // swallow taps so they don't land on the form

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 22) {
                    menuBarIllustration

                    // Bouncing arrows
                    HStack(spacing: 4) {
                        ForEach(0..<3) { i in
                            Image(systemName: "chevron.up")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white.opacity(0.85 - Double(i) * 0.25))
                                .offset(y: bounce ? (-4 + CGFloat(i) * 2) : (CGFloat(i) * 2))
                                .animation(.easeInOut(duration: 0.65).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: bounce)
                        }
                    }

                    VStack(spacing: 8) {
                        Text("Quick access from your Menu Bar")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("NameCraft sits in your Mac's menu bar.\nClick the icon up there any time for a\ncompact, always-ready view.")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.68))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }

                    // Step dots
                    stepDots(current: 0, total: 2)

                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) { appeared = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                            step = 1
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) { appeared = true }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text("Next")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 24).padding(.vertical, 9)
                        .background(.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(36)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.09, green: 0.07, blue: 0.17))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.55), radius: 48, y: 20)
                }
                .frame(maxWidth: 380)
                .scaleEffect(appeared ? 1.0 : 0.93)
                .opacity(appeared ? 1.0 : 0)

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }

    // Simulated macOS menu bar
    private var menuBarIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.14, green: 0.12, blue: 0.22))
                .frame(width: 300, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.white.opacity(0.07), lineWidth: 1)
                )

            HStack(spacing: 0) {
                // Left — Apple + app name
                HStack(spacing: 12) {
                    Image(systemName: "applelogo")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.4))
                    Text("Finder")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.28))
                }
                .padding(.leading, 14)

                Spacer()

                // Right — system icons + NameCraft
                HStack(spacing: 11) {
                    Image(systemName: "wifi")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.3))
                    Image(systemName: "battery.100")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.3))

                    // NameCraft icon (highlighted)
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.55, green: 0.35, blue: 0.95), Color(red: 0.38, green: 0.20, blue: 0.85)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(width: 22, height: 20)
                        Text("N")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.purple.opacity(0.9), lineWidth: 1.5)
                            .frame(width: 26, height: 24)
                    )
                    .shadow(color: .purple.opacity(0.7), radius: 8)
                }
                .padding(.trailing, 14)
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────
    // MARK: Step 1 — Fun Mode toggle
    // ─────────────────────────────────────────────────────────────────────

    private var funModeStep: some View {
        GeometryReader { geo in
            ZStack {
                spotlightLayer(geo: geo)
                calloutCard(geo: geo)
            }
        }
    }

    // Dark overlay with a transparent hole over the toggle
    private func spotlightLayer(geo: GeometryProxy) -> some View {
        let sr = spotRect(in: geo)
        return Rectangle()
            .fill(Color.black.opacity(0.70))
            .mask(
                Rectangle()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: sr.width, height: sr.height)
                            .position(x: sr.midX, y: sr.midY)
                            .blendMode(.destinationOut)
                    )
            )
            .ignoresSafeArea()
    }

    private func spotRect(in geo: GeometryProxy) -> CGRect {
        guard toggleFrame != .zero else {
            // Fallback: highlight the whole header left side
            return CGRect(x: 0, y: 0, width: 260, height: 44)
        }
        let pad: CGFloat = 10
        return CGRect(
            x: toggleFrame.minX - pad,
            y: toggleFrame.minY - pad,
            width: toggleFrame.width + pad * 2,
            height: toggleFrame.height + pad * 2
        )
    }

    // Callout card below the spotlight
    private func calloutCard(geo: GeometryProxy) -> some View {
        let sr = spotRect(in: geo)
        let cardW: CGFloat = 280
        let rawX = sr.midX - cardW / 2
        let cardX = max(16, min(rawX, geo.size.width - cardW - 16))
        let cardY = sr.maxY + 12
        let arrowNudge = sr.midX - (cardX + cardW / 2)
        let clampedNudge = max(-cardW / 2 + 18, min(cardW / 2 - 18, arrowNudge))

        return VStack(alignment: .leading, spacing: 0) {
            // Pointer triangle pointing up at the highlighted region
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: cardW / 2 + clampedNudge - 6)
                Image(systemName: "triangle.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(Color(red: 0.14, green: 0.11, blue: 0.24))
                    .rotationEffect(.degrees(180))
                Spacer()
            }
            .frame(width: cardW)

            // Card body
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color.purple, Color(red: 0.5, green: 0.2, blue: 0.9)], startPoint: .top, endPoint: .bottom))
                            .frame(width: 30, height: 30)
                        Text("✨")
                            .font(.system(size: 14))
                    }

                    Text("Fun Mode")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Text("Switch between Clean and Fun mode. Fun turns on glowing gradients, confetti, animations — great for when you're in the zone.")
                    .font(.system(size: 12.5))
                    .foregroundStyle(.white.opacity(0.70))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)

                // Step dots + done button
                HStack {
                    stepDots(current: 1, total: 2)
                    Spacer()
                    Button {
                        withAnimation(.easeOut(duration: 0.25)) { isVisible = false }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                            Text("Got it!")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 16).padding(.vertical, 7)
                        .background(.white)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
            }
            .padding(16)
            .frame(width: cardW)
            .background(Color(red: 0.14, green: 0.11, blue: 0.24))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.purple.opacity(0.28), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 20, y: 8)
        }
        .position(x: cardX + cardW / 2, y: cardY + 70)
        .scaleEffect(appeared ? 1.0 : 0.92)
        .opacity(appeared ? 1.0 : 0)
        .animation(.spring(response: 0.45, dampingFraction: 0.72), value: appeared)
    }

    // ─────────────────────────────────────────────────────────────────────
    // MARK: Shared helpers
    // ─────────────────────────────────────────────────────────────────────

    private func stepDots(current: Int, total: Int) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i == current ? Color.white : Color.white.opacity(0.25))
                    .frame(width: i == current ? 16 : 6, height: 6)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: current)
            }
        }
    }
}
