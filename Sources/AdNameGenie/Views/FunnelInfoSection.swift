import SwiftUI

struct FunnelInfoSection: View {
    @Bindable var form: FormState
    @Environment(\.funMode) private var fun

    private let columns = Array(repeating: GridItem(.flexible(), spacing: DS.gridGap), count: 2)

    var body: some View {
        FormSection(number: 4, title: "Funnel & Info", funTitle: "Funnel & the good stuff", dimmed: form.brand == nil) {
            VStack(alignment: .leading, spacing: DS.fieldGap) {
                if let brand = form.brand {
                    let config = brand.config

                    // Funnel
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            FieldLabel(text: "Funnel")
                            if config.freeTextFunnel {
                                Text("free text")
                                    .font(.system(size: 12, weight: .medium, design: fun ? .rounded : .default))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.secondary.opacity(0.08))
                                    .clipShape(Capsule())
                            } else {
                                Text("options adapt to brand")
                                    .font(.system(size: 13, design: fun ? .rounded : .default))
                                    .foregroundStyle(fun ? Color.white.opacity(0.3) : Color.secondary.opacity(0.35))
                            }
                        }

                        if config.freeTextFunnel {
                            TextField("Enter funnel name...", text: $form.customFunnel)
                                .textFieldStyle(.plain)
                                .font(.system(size: 14, design: fun ? .rounded : .default))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 13)
                                .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.03)))
                                .overlay(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).strokeBorder(fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1)))
                        } else if !config.funnels.isEmpty {
                            LazyVGrid(columns: columns, spacing: DS.gridGap) {
                                ForEach(Array(config.funnels.enumerated()), id: \.element) { i, f in
                                    FilledPill(
                                        label: f,
                                        isSelected: form.funnel == f && !form.useOtherFunnel,
                                        action: { form.funnel = f; form.useOtherFunnel = false },
                                        funGradient: FunColors.funnelGradients[i % FunColors.funnelGradients.count]
                                    )
                                }
                                OtherFieldCard(
                                    isActive: form.useOtherFunnel,
                                    placeholder: "Custom funnel...",
                                    text: $form.customFunnel,
                                    onActivate: {
                                        form.useOtherFunnel.toggle()
                                        if !form.useOtherFunnel { form.customFunnel = "" }
                                        form.funnel = ""
                                    }
                                )
                            }
                        }
                    }

                    // Additional info
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            FieldLabel(text: "Additional Info")
                            Text("optional")
                                .font(.system(size: 12, weight: .medium, design: fun ? .rounded : .default))
                                .foregroundStyle(.tertiary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.primary.opacity(0.04))
                                .clipShape(Capsule())
                            Spacer()
                            Text("\(form.additionalInfo.count)/50")
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundStyle(fun ? Color.white.opacity(0.3) : Color.secondary.opacity(0.35))
                        }
                        TextField("CI / SC / CT / C1650 ...", text: $form.additionalInfo)
                            .textFieldStyle(.plain)
                            .font(.system(size: 14, design: fun ? .rounded : .default))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .background(RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.03)))
                            .overlay(
                                RoundedRectangle(cornerRadius: fun ? DS.funRadius : DS.radius)
                                    .strokeBorder(form.additionalInfoError.isEmpty
                                        ? (fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1))
                                        : Color.red.opacity(0.4))
                            )
                            .onChange(of: form.additionalInfo) { _, _ in form.validateAdditionalInfo() }
                        if !form.additionalInfoError.isEmpty {
                            Label(form.additionalInfoError, systemImage: "exclamationmark.circle")
                                .font(.system(size: 13))
                                .foregroundStyle(.red)
                        } else {
                            Text(fun ? "Leave blank and we skip it — no worries 👌" : "Skipped in filename if left empty")
                                .font(.system(size: 13, design: fun ? .rounded : .default))
                                .foregroundStyle(fun ? Color.white.opacity(0.3) : Color.secondary.opacity(0.35))
                        }
                    }
                }
            }
        }
    }
}
