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

                if i > 0 {
                    Rectangle()
                        .fill(form.isComplete(steps[i - 1].0)
                              ? (fun ? stepColors[i - 1].opacity(0.4) : Color.primary.opacity(0.2))
                              : (fun ? Color.white.opacity(0.06) : Color.primary.opacity(0.06)))
                        .frame(height: 1.5)
                }

                Button { onScrollTo(section) } label: {
                    VStack(spacing: 3) {
                        ZStack {
                            if fun {
                                Circle()
                                    .fill(done
                                          ? LinearGradient(colors: [stepColors[i], stepColors[i].opacity(0.7)], startPoint: .top, endPoint: .bottom)
                                          : LinearGradient(colors: [Color(white: 0.18), Color(white: 0.12)], startPoint: .top, endPoint: .bottom))
                                    .frame(width: done ? 18 : (isActive ? 18 : 14), height: done ? 18 : (isActive ? 18 : 14))
                                    .shadow(color: done ? stepColors[i].opacity(0.5) : .clear, radius: 5, y: 2)
                            } else {
                                Circle()
                                    .fill(done ? Color.primary : (isActive ? Color.primary.opacity(0.12) : Color.primary.opacity(0.06)))
                                    .frame(width: done ? 18 : (isActive ? 18 : 14), height: done ? 18 : (isActive ? 18 : 14))
                            }

                            if done {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 8, weight: .black))
                                    .foregroundStyle(.white)
                            } else {
                                Text("\(i + 1)")
                                    .font(.system(size: 8, weight: .bold, design: .rounded))
                                    .foregroundStyle(fun ? Color.white.opacity(isActive ? 0.6 : 0.25) : (isActive ? .primary : Color.secondary.opacity(0.4)))
                            }
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: done)

                        Text(label)
                            .font(.system(size: 9, weight: done ? .bold : .medium, design: fun ? .rounded : .default))
                            .foregroundStyle(done ? (fun ? stepColors[i] : Color.primary) : (fun ? Color.white.opacity(0.3) : Color.secondary))
                            .lineLimit(1)
                    }
                    .frame(width: 52)
                }
                .buttonStyle(.plain)
            }

            Spacer(minLength: 4)

            // Clear all — icon only to prevent text wrapping
            Button(action: onClearAll) {
                Image(systemName: fun ? "flame.fill" : "xmark.circle")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(fun ? .red : .secondary)
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
