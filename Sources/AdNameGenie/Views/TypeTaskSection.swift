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

                // Variation — big tap targets
                HStack(spacing: 10) {
                    FieldLabel(text: "Variation")

                    Spacer()

                    HStack(spacing: 0) {
                        Button {
                            if form.variation > 1 {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { form.variation -= 1 }
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(fun ? .white : .primary)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .disabled(form.variation <= 1)
                        .opacity(form.variation <= 1 ? 0.25 : 1)

                        Text(form.variationString)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundStyle(fun ? .white : .primary)
                            .contentTransition(.numericText())
                            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: form.variation)
                            .frame(minWidth: 44)

                        Button {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { form.variation += 1 }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(fun ? .white : .primary)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.04)))
                    .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).strokeBorder(fun ? Color.white.opacity(0.08) : Color.primary.opacity(0.1)))
                }
            }
        }
    }
}
