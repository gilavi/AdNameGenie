import SwiftUI

struct ProgressBar: View {
    var form: FormState
    var onScrollTo: (NavSection) -> Void
    var onClearAll: () -> Void
    @Environment(\.funMode) private var fun

    private let steps: [(NavSection, String)] = [
        (.brand, "Brand"), (.typeTask, "Type"), (.platform, "Platform"),
        (.funnelInfo, "Funnel"), (.languageDate, "Date"), (.creativeOutput, "Output"),
    ]
    private let stepColors: [Color] = [.red, .orange, .yellow, .green, .cyan, .purple]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { i, pair in
                let (section, label) = pair
                let done = form.isComplete(section)
                let isActive = !done && (i == 0 || form.isComplete(steps[i - 1].0))
                let prevDone = i > 0 && form.isComplete(steps[i - 1].0)

                if i > 0 {
                    Rectangle()
                        .fill(prevDone
                              ? (fun ? stepColors[i - 1].opacity(0.4) : Color.primary.opacity(0.2))
                              : (fun ? Color.white.opacity(0.06) : Color.primary.opacity(0.06)))
                        .frame(height: 1.5)
                }

                Button { onScrollTo(section) } label: {
                    StepDot(
                        index: i,
                        label: label,
                        done: done,
                        isActive: isActive,
                        color: stepColors[i],
                        fun: fun
                    )
                }
                .buttonStyle(.plain)
            }

            Spacer(minLength: 4)

            Button(action: onClearAll) {
                Image(systemName: fun ? "flame.fill" : "xmark.circle")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(fun ? Color.red : Color.secondary)
                    .frame(width: 28, height: 28)
                    .background {
                        if fun {
                            Circle().fill(Color.red.opacity(0.15))
                        } else {
                            Circle().fill(Color.primary.opacity(0.04))
                        }
                    }
                    .overlay(Circle().stroke(fun ? Color.red.opacity(0.2) : Color.primary.opacity(0.06)))
            }
            .buttonStyle(.plain)
            .help(fun ? "Nuke it all!" : "Clear all fields")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            if fun {
                Color(red: 0.07, green: 0.06, blue: 0.12)
            } else {
                Rectangle().fill(.bar)
            }
        }
    }
}

private struct StepDot: View {
    let index: Int
    let label: String
    let done: Bool
    let isActive: Bool
    let color: Color
    let fun: Bool

    private var labelColor: Color {
        if done   { return fun ? color : Color.primary }
        if isActive { return fun ? color.opacity(0.85) : Color.primary }
        return fun ? Color.white.opacity(0.2) : Color.secondary.opacity(0.35)
    }
    private var labelWeight: Font.Weight {
        done ? .bold : (isActive ? .semibold : .regular)
    }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if done {
                    Circle()
                        .fill(fun
                              ? AnyShapeStyle(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                              : AnyShapeStyle(Color.primary))
                        .frame(width: 20, height: 20)
                        .shadow(color: fun ? color.opacity(0.45) : .clear, radius: 5, y: 2)
                    Image(systemName: "checkmark")
                        .font(.system(size: 9, weight: .black))
                        .foregroundStyle(.white)
                } else if isActive {
                    Circle()
                        .strokeBorder(fun ? color : Color.primary, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    Text("\(index + 1)")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .foregroundStyle(fun ? color : Color.primary)
                } else {
                    Circle()
                        .fill(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.15))
                        .frame(width: 7, height: 7)
                }
            }
            .frame(width: 20, height: 20)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: done)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)

            Text(label)
                .font(.system(size: 9, weight: labelWeight, design: fun ? .rounded : .default))
                .foregroundStyle(labelColor)
                .lineLimit(1)
        }
        .frame(width: 52)
    }
}
