import SwiftUI

struct TypeTaskSection: View {
    @Bindable var form: FormState
    @Environment(\.funMode) private var fun

    var body: some View {
        FormSection(number: 2, title: "Type & Task", funTitle: "What are we making?") {
            VStack(alignment: .leading, spacing: DS.fieldGap) {

                // Type Label
                VStack(alignment: .leading, spacing: 8) {
                    FieldLabel(text: "Type Label")
                    HStack(spacing: DS.gridGap) {
                        ForEach(TypeLabel.allCases, id: \.rawValue) { type in
                            FilledPill(
                                label: type.rawValue,
                                isSelected: form.typeLabel == type,
                                action: { form.typeLabel = type },
                                icon: type.icon,
                                funGradient: type == .vid ? FunColors.vidGradient : FunColors.imgGradient
                            )
                        }
                    }
                }

                // Task Number
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        FieldLabel(text: "Task Number")
                        Text("required")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.red.opacity(0.9))
                        Spacer()
                        if form.isTaskNumberValid {
                            HStack(spacing: 4) {
                                Image(systemName: fun ? "checkmark.seal.fill" : "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 14))
                                Text("Valid")
                                    .font(.system(size: 13, design: fun ? .rounded : .default))
                                    .foregroundStyle(.green)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    TextField("Enter task number...", text: $form.taskNumber)
                        .textFieldStyle(.plain)
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.03)))
                        .overlay(
                            RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                                .strokeBorder(
                                    form.taskNumberError.isEmpty
                                        ? (fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1))
                                        : Color.red.opacity(0.4),
                                    lineWidth: 1.5
                                )
                        )
                        .onChange(of: form.taskNumber) { _, _ in form.validateTaskNumber() }

                    if !form.taskNumberError.isEmpty {
                        Label(form.taskNumberError, systemImage: "exclamationmark.circle")
                            .font(.system(size: 13))
                            .foregroundStyle(.red)
                    } else {
                        Text(fun ? "Just the number — the label joins it automatically ✌️" : "Only the number — type label added automatically")
                            .font(.system(size: 13, design: fun ? .rounded : .default))
                            .foregroundStyle(fun ? Color.white.opacity(0.3) : Color.secondary.opacity(0.35))
                    }
                }

                // Variation — pill buttons
                VStack(alignment: .leading, spacing: 8) {
                    FieldLabel(text: "Variation")
                    HStack(spacing: 6) {
                        ForEach([1, 2, 3, 4, 5], id: \.self) { n in
                            VariationPill(
                                label: "\(n)",
                                isSelected: !form.useOtherVariation && form.variation == n,
                                fun: fun
                            ) {
                                withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                                    form.variation = n
                                    form.useOtherVariation = false
                                    form.customVariation = ""
                                }
                            }
                        }
                        // Other pill — morphs into input
                        if form.useOtherVariation {
                            TextField("6, 7...", text: Binding(
                                get: { form.customVariation },
                                set: { form.customVariation = $0.filter { $0.isNumber } }
                            ))
                            .textFieldStyle(.plain)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .frame(width: 72, height: 40)
                            .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                                .fill(fun ? Color(red: 0.35, green: 0.2, blue: 0.7).opacity(0.25) : Color.primary.opacity(0.06)))
                            .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                                .strokeBorder(fun ? Color.purple.opacity(0.7) : Color.primary.opacity(0.35), lineWidth: 1.5))
                        } else {
                            VariationPill(label: "Other", isSelected: false, fun: fun) {
                                withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                                    form.useOtherVariation = true
                                    form.customVariation = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct VariationPill: View {
    let label: String
    let isSelected: Bool
    let fun: Bool
    let action: () -> Void
    @State private var pressing = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .bold, design: fun ? .rounded : .monospaced))
                .foregroundStyle(isSelected ? (fun ? .white : Color(.windowBackgroundColor)) : (fun ? .white : .primary))
                .frame(height: 40)
                .frame(minWidth: 44)
                .padding(.horizontal, label.count > 1 ? 10 : 0)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                            .fill(fun
                                  ? AnyShapeStyle(LinearGradient(colors: [Color.purple, Color.purple.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                                  : AnyShapeStyle(Color.primary))
                    } else {
                        RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                            .fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                    .strokeBorder(isSelected
                                  ? Color.clear
                                  : (fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.12)), lineWidth: 1))
                .scaleEffect(pressing ? 0.92 : 1)
                .animation(.spring(response: 0.18, dampingFraction: 0.6), value: pressing)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in pressing = true }
            .onEnded   { _ in pressing = false }
        )
    }
}
