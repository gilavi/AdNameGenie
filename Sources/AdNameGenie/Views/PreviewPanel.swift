import SwiftUI
import AppKit

struct PreviewPanel: View {
    @Bindable var form: FormState
    var historyStore: HistoryStore
    var onScrollTo: ((NavSection) -> Void)? = nil
    @State private var copyPressing = false
    @State private var copyReadyPulse = false
    @State private var hoveredChip: Int? = nil
    @Environment(\.funMode) private var fun

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Top section: filename display
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        if fun {
                            Text("👀")
                                .font(.system(size: 13))
                        }
                        Text("Preview")
                            .font(.system(size: 13, weight: .semibold, design: fun ? .rounded : .default))
                    }
                    Text("Generated filename")
                        .font(.system(size: 11, design: fun ? .rounded : .default))
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 16)

                if form.generatedFilename.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: fun ? "wand.and.stars" : "doc.text.magnifyingglass")
                            .font(.system(size: 28))
                            .foregroundStyle(fun ? .purple.opacity(0.4) : Color.secondary.opacity(0.35))
                        Text(fun ? "Fill the fields and\nwatch the magic ✨" : "Fill in fields\nto preview")
                            .font(.system(size: 12, design: fun ? .rounded : .default))
                            .foregroundStyle(fun ? Color.white.opacity(0.3) : Color.secondary.opacity(0.35))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(form.generatedFilename)
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .textSelection(.enabled)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id(form.generatedFilename)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(y: 4)),
                                removal: .opacity.combined(with: .offset(y: -4))
                            ))
                            .animation(.easeInOut(duration: 0.18), value: form.generatedFilename)

                        let parts = form.generatedFilename.split(separator: "_", omittingEmptySubsequences: false).map(String.init)
                        FlowLayout(spacing: 6) {
                            let sectionMap = form.segmentSectionMap
                            ForEach(Array(parts.enumerated()), id: \.offset) { i, part in
                                let target: NavSection? = i < sectionMap.count ? sectionMap[i] : nil
                                Button {
                                    if let target { onScrollTo?(target) }
                                } label: {
                                    Text(part)
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .padding(.horizontal, 7)
                                        .padding(.vertical, 4)
                                        .background(segColor(i).opacity(hoveredChip == i ? (fun ? 0.35 : 0.2) : (fun ? 0.2 : 0.1)))
                                        .foregroundStyle(segColor(i))
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .scaleEffect(hoveredChip == i ? 1.08 : 1.0)
                                }
                                .buttonStyle(.plain)
                                .onHover { h in
                                    withAnimation(.spring(response: 0.15, dampingFraction: 0.7)) { hoveredChip = h ? i : nil }
                                    if h { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                                }
                                .transition(.scale(scale: 0.7).combined(with: .opacity))
                                .animation(.spring(response: 0.35, dampingFraction: 0.65).delay(Double(i) * 0.03), value: parts.count)
                            }
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: parts.count)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(fun ? Color(white: 0.1) : Color.primary.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(fun ? Color.white.opacity(0.06) : Color.primary.opacity(0.07))
                    )
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            // Bottom: copy button
            VStack(spacing: 12) {
                Divider()

                Button {
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) { copyPressing = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.55)) { copyPressing = false }
                    }
                    if form.canCopy {
                        historyStore.add(filename: form.generatedFilename, form: form)
                    }
                    form.copyToClipboard()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: fun ? "sparkles" : "doc.on.doc.fill")
                            .font(.system(size: 14, weight: .semibold))
                        Text(fun
                            ? (form.canCopy ? "Snag that name! ✨" : "Almost there... keep going")
                            : (form.canCopy ? "Copy filename" : "Complete fields to copy")
                        )
                            .font(.system(size: 14, weight: .bold, design: fun ? .rounded : .default))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        if fun {
                            KeyCapShape(
                                topColors: form.canCopy ? FunColors.copyGradient : FunColors.keycapTop,
                                shadowColor: form.canCopy ? FunColors.copyShadow : FunColors.keycapShadow,
                                isPressed: copyPressing,
                                cornerRadius: 11
                            )
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    form.canCopy
                                    ? LinearGradient(
                                        colors: [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.22, green: 0.22, blue: 0.22)],
                                        startPoint: .top, endPoint: .bottom
                                      )
                                    : LinearGradient(
                                        colors: [Color.gray.opacity(0.25), Color.gray.opacity(0.18)],
                                        startPoint: .top, endPoint: .bottom
                                      )
                                )
                        }
                    }
                    .overlay {
                        if !fun {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(form.canCopy ? Color.white.opacity(0.08) : Color.clear, lineWidth: 1)
                        }
                    }
                    .offset(y: fun ? (copyPressing ? 3 : 0) : 0)
                    .shadow(color: fun && form.canCopy ? .green.opacity(0.35) : .clear, radius: 10, y: 4)
                }
                .buttonStyle(.plain)
                .scaleEffect(fun ? 1.0 : (copyPressing ? 0.97 : (copyReadyPulse ? 1.03 : 1.0)))
                .disabled(!form.canCopy)
                .onChange(of: form.canCopy) { _, newVal in
                    guard newVal else { return }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) { copyReadyPulse = true }
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.25)) { copyReadyPulse = false }
                }

                // Pattern reference
                Text("[Brand]_[Type+Task]_[v#]_[Platform]_[Funnel]_[Lang]_[Date]_[CP]_[Res]")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(fun ? Color.white.opacity(0.2) : Color.secondary.opacity(0.3))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(fun ? Color(red: 0.07, green: 0.06, blue: 0.12) : Color.clear)
    }

    private func segColor(_ i: Int) -> Color {
        let colors: [Color] = [.blue, .purple, .orange, .green, .pink, .cyan, .mint, .indigo, .teal, .brown]
        return colors[i % colors.count]
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 4

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(proposal: proposal, subviews: subviews).size
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let r = layout(proposal: proposal, subviews: subviews)
        for (i, sv) in subviews.enumerated() {
            sv.place(at: CGPoint(x: bounds.minX + r.positions[i].x, y: bounds.minY + r.positions[i].y), proposal: .unspecified)
        }
    }
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxW = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0, maxX: CGFloat = 0
        for sv in subviews {
            let s = sv.sizeThatFits(.unspecified)
            if x + s.width > maxW && x > 0 { x = 0; y += rowH + spacing; rowH = 0 }
            positions.append(CGPoint(x: x, y: y))
            rowH = max(rowH, s.height); x += s.width + spacing; maxX = max(maxX, x)
        }
        return (CGSize(width: maxX, height: y + rowH), positions)
    }
}
