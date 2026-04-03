import SwiftUI

struct MiniPopoverView: View {
    var form: FormState
    var historyStore: HistoryStore
    @Environment(\.openWindow) private var openWindow
    @Environment(\.funMode) private var fun
    @AppStorage("funMode") private var funModeEnabled = false
    @State private var copyPressing = false
    @State private var toggleWiggle = false
    @State private var toggleBurst = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 6) {
                if fun { Text("✨").font(.system(size: 11)) }
                Text("NameCraft")
                    .font(.system(size: 12, weight: .bold, design: fun ? .rounded : .default))
                Spacer()
                modeToggleButton
                expandButton
            }
            .padding(.horizontal, 14).padding(.top, 12).padding(.bottom, 8)

            miniDivider

            // Form
            VStack(alignment: .leading, spacing: 10) {

                // Brand — 4 columns = 3 rows, bigger chips
                miniSection("Brand") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                        ForEach(Brand.allCases) { brand in
                            MiniBrandChip(brand: brand, isSelected: form.brand == brand) {
                                if form.brand != brand {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        form.brand = brand; form.onBrandChange()
                                    }
                                }
                            }
                        }
                    }
                }

                miniDivider

                // Type
                miniSection("Type") {
                    HStack(spacing: 6) {
                        miniPill("vid", selected: form.typeLabel == .vid, colors: FunColors.vidGradient) { form.typeLabel = .vid }
                        miniPill("img", selected: form.typeLabel == .img, colors: FunColors.imgGradient) { form.typeLabel = .img }
                    }
                }

                // Task + Variation
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        miniLabel("Task #")
                        TextField("123", text: Binding(
                            get: { form.taskNumber },
                            set: { form.taskNumber = $0; form.validateTaskNumber() }
                        ))
                        .textFieldStyle(.plain)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 10).padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        miniLabel("Variation")
                        HStack(spacing: 0) {
                            // Minus — big tap area
                            Button {
                                if form.variation > 1 { withAnimation { form.variation -= 1 } }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(fun ? .white : .primary)
                                    .frame(width: 36, height: 36)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .opacity(form.variation <= 1 ? 0.25 : 1)

                            Text("v\(form.variation)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .contentTransition(.numericText())
                                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: form.variation)
                                .frame(minWidth: 34)

                            // Plus — big tap area
                            Button {
                                withAnimation { form.variation += 1 }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(fun ? .white : .primary)
                                    .frame(width: 36, height: 36)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1)))
                    }
                }

                // Brand-dependent sections
                if let brand = form.brand {
                    let config = brand.config
                    miniDivider

                    // Platform
                    miniSection("Platform") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                            ForEach(Platform.allCases) { p in
                                miniPill(p.rawValue, selected: form.platform == p, colors: FunColors.platformGradient(p)) {
                                    withAnimation(.easeInOut(duration: 0.2)) { form.platform = p }
                                }
                            }
                        }
                    }

                    // Language + Other
                    miniSection("Language") {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                ForEach(Language.allCases) { lang in
                                    miniPill("\(lang.flag) \(lang.rawValue)",
                                             selected: !form.useOtherLanguage && form.language == lang.rawValue,
                                             colors: FunColors.langGradient(lang.rawValue)) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            form.language = lang.rawValue
                                            form.useOtherLanguage = false
                                            form.customLanguage = ""
                                        }
                                    }
                                }
                                miniPill("Other", selected: form.useOtherLanguage,
                                         colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)]) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        form.useOtherLanguage.toggle()
                                        if !form.useOtherLanguage { form.customLanguage = ""; form.language = "EN" }
                                    }
                                }
                            }
                            if form.useOtherLanguage {
                                TextField("e.g. PT", text: Binding(
                                    get: { form.customLanguage },
                                    set: { form.customLanguage = $0.uppercased() }
                                ))
                                .textFieldStyle(.plain)
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .padding(.horizontal, 8).padding(.vertical, 6)
                                .frame(maxWidth: 100)
                                .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                                .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                            }
                        }
                    }

                    miniDivider

                    // Funnel
                    if config.freeTextFunnel {
                        miniSection("Funnel") {
                            TextField("Funnel name", text: Binding(get: { form.customFunnel }, set: { form.customFunnel = $0 }))
                                .textFieldStyle(.plain)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 8).padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                                .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                        }
                    } else if !config.funnels.isEmpty {
                        miniSection("Funnel") {
                            VStack(alignment: .leading, spacing: 4) {
                                Picker(selection: Binding(
                                    get: { form.useOtherFunnel ? "__other__" : form.funnel },
                                    set: { val in
                                        if val == "__other__" {
                                            form.useOtherFunnel = true; form.funnel = ""
                                        } else {
                                            form.useOtherFunnel = false; form.funnel = val; form.customFunnel = ""
                                        }
                                    }
                                ), label: EmptyView()) {
                                    Text("Select...").tag("")
                                    ForEach(config.funnels, id: \.self) { f in Text(f).tag(f) }
                                    Divider()
                                    Text("Other...").tag("__other__")
                                }
                                .pickerStyle(.menu)
                                if form.useOtherFunnel {
                                    TextField("Custom funnel", text: Binding(get: { form.customFunnel }, set: { form.customFunnel = $0 }))
                                        .textFieldStyle(.plain)
                                        .font(.system(size: 12, weight: .medium))
                                        .padding(.horizontal, 8).padding(.vertical, 6)
                                        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                                        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                                }
                            }
                        }
                    }

                    // Additional Info
                    miniSection("Info") {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 4) {
                                TextField("CI / SC / CT...", text: Binding(
                                    get: { form.additionalInfo },
                                    set: { form.additionalInfo = $0; form.validateAdditionalInfo() }
                                ))
                                .textFieldStyle(.plain)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 8).padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                                .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(
                                    form.additionalInfoError.isEmpty
                                        ? (fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12))
                                        : Color.red.opacity(0.4)
                                ))
                                Text("\(form.additionalInfo.count)/50")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(fun ? Color.white.opacity(0.3) : .secondary)
                                    .fixedSize()
                            }
                            if !form.additionalInfoError.isEmpty {
                                Text(form.additionalInfoError)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.red)
                            }
                        }
                    }

                    // Date
                    miniSection("Date") {
                        HStack {
                            DatePicker("", selection: Binding(get: { form.date }, set: { form.date = $0 }), displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) { form.date = Date() }
                            } label: {
                                Text("Today")
                                    .font(.system(size: 11, weight: .semibold, design: fun ? .rounded : .default))
                                    .foregroundStyle(fun ? .white.opacity(0.6) : .secondary)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(Capsule().fill(fun ? Color.white.opacity(0.08) : Color.primary.opacity(0.04)))
                                    .overlay(Capsule().stroke(fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.08)))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    miniDivider

                    // Creative Producer
                    if config.creativeProducers.isEmpty {
                        miniSection("Producer") {
                            TextField("Initials (e.g. JD)", text: Binding(
                                get: { form.customCreativeProducer },
                                set: { form.customCreativeProducer = $0.uppercased() }
                            ))
                            .textFieldStyle(.plain)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 8).padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                            .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                        }
                    } else {
                        miniSection("Producer") {
                            Picker(selection: Binding(
                                get: { form.creativeProducer },
                                set: { form.creativeProducer = $0 }
                            ), label: EmptyView()) {
                                Text("Select...").tag("")
                                ForEach(config.creativeProducers) { p in
                                    Text(p.label).tag(p.value)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }

                    // Resolution
                    miniSection("Resolution") {
                        VStack(alignment: .leading, spacing: 4) {
                            Picker(selection: Binding(
                                get: { form.useOtherResolution ? "__other__" : form.resolution },
                                set: { val in
                                    if val == "__other__" {
                                        form.useOtherResolution = true; form.resolution = ""
                                    } else {
                                        form.useOtherResolution = false; form.resolution = val; form.customResolution = ""
                                    }
                                }
                            ), label: EmptyView()) {
                                ForEach(config.resolutions) { res in Text(res.label).tag(res.value) }
                                Divider()
                                Text("Other...").tag("__other__")
                            }
                            .pickerStyle(.menu)
                            if form.useOtherResolution {
                                TextField("e.g. 1920x1080", text: Binding(
                                    get: { form.customResolution },
                                    set: { form.customResolution = $0 }
                                ))
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                                    .padding(.horizontal, 8).padding(.vertical, 6)
                                    .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                                    .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 10)

            miniDivider

            // Preview + Copy
            VStack(spacing: 6) {
                if form.generatedFilename.isEmpty {
                    Text(fun ? "Pick a brand to start ✨" : "Select a brand to preview")
                        .font(.system(size: 11, design: fun ? .rounded : .default))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 6)
                } else {
                    Text(form.generatedFilename)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(fun ? .white.opacity(0.9) : .primary)
                        .lineLimit(2)
                        .textSelection(.enabled)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color.white.opacity(0.05) : Color.primary.opacity(0.03)))
                        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).stroke(fun ? Color.white.opacity(0.06) : Color.primary.opacity(0.08)))
                }

                Button {
                    if form.canCopy { historyStore.add(filename: form.generatedFilename, form: form) }
                    form.copyToClipboard()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: fun ? "sparkles" : "doc.on.doc.fill")
                            .font(.system(size: 11, weight: .semibold))
                        Text(fun ? (form.canCopy ? "Snag it! ✨" : "Almost...") : (form.canCopy ? "Copy" : "Fill fields"))
                            .font(.system(size: 12, weight: .bold, design: fun ? .rounded : .default))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background {
                        if fun {
                            KeyCapShape(topColors: form.canCopy ? FunColors.copyGradient : FunColors.keycapTop,
                                        shadowColor: form.canCopy ? FunColors.copyShadow : FunColors.keycapShadow,
                                        isPressed: copyPressing, cornerRadius: DS.funRadius, depth: 4)
                        } else {
                            RoundedRectangle(cornerRadius: DS.radius)
                                .fill(form.canCopy ? Color.accentColor : Color.secondary.opacity(0.25))
                        }
                    }
                    .offset(y: fun ? (copyPressing ? 3 : 0) : 0)
                    .shadow(color: fun && form.canCopy ? .green.opacity(0.3) : .clear, radius: 6, y: 3)
                }
                .buttonStyle(.plain)
                .disabled(!form.canCopy && !fun)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in withAnimation(.easeOut(duration: 0.06)) { copyPressing = true } }
                        .onEnded   { _ in withAnimation(.spring(response: 0.22, dampingFraction: 0.45)) { copyPressing = false } }
                )
            }
            .padding(.horizontal, 14).padding(.top, 10).padding(.bottom, 16)
        }
        .frame(width: 340)
        .background(fun ? Color(red: 0.10, green: 0.08, blue: 0.16) : Color(.windowBackgroundColor))
        .overlay {
            if form.showCopiedToast {
                VStack { Spacer(); CopiedToast().scaleEffect(0.8).padding(.bottom, 6) }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.65), value: form.showCopiedToast)
            }
        }
        // Tap empty area to resign text field focus
        .onTapGesture {
            NSApp.keyWindow?.makeFirstResponder(nil)
        }
    }

    // MARK: - Header buttons

    /// Segmented Clean / Fun ✨ toggle — always shows both states clearly
    private var modeToggleButton: some View {
        HStack(spacing: 2) {
            modeSegment(label: "Clean", icon: "circle.grid.2x2", isActive: !funModeEnabled, activate: {
                withAnimation(.easeInOut(duration: 0.25)) { funModeEnabled = false }
            })
            modeSegment(label: "Fun ✨", icon: "sparkles", isActive: funModeEnabled, activate: {
                withAnimation(.easeInOut(duration: 0.25)) { funModeEnabled = true }
                toggleBurst = true
            })
        }
        .padding(2)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.primary.opacity(0.06)))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.10), lineWidth: 1))
        .modifier(PopBurst(trigger: $toggleBurst, emojis: ["✨","🎉","🌈","💫"]))
    }

    private func modeSegment(label: String, icon: String, isActive: Bool, activate: @escaping () -> Void) -> some View {
        Button(action: activate) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 9, weight: .semibold))
                Text(label)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
            }
            .foregroundStyle(isActive ? (funModeEnabled ? Color.yellow : Color.white) : Color.secondary)
            .padding(.horizontal, 9).padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 13)
                    .fill(isActive
                        ? (funModeEnabled
                            ? AnyShapeStyle(LinearGradient(colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.65)], startPoint: .leading, endPoint: .trailing))
                            : AnyShapeStyle(Color(.controlAccentColor).opacity(0.85)))
                        : AnyShapeStyle(Color.clear)
                    )
            }
        }
        .buttonStyle(.plain)
    }

    private var expandButton: some View {
        Button {
            openWindow(id: "main")
            NSApp.activate(ignoringOtherApps: true)
        } label: {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.primary.opacity(0.04)))
                .overlay(Circle().stroke(Color.primary.opacity(0.06)))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Reusable helpers

    private func miniLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .bold, design: fun ? .rounded : .default))
            .foregroundStyle(fun ? Color.white.opacity(0.5) : .secondary)
            .tracking(0.6)
    }

    private func miniSection<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            miniLabel(label)
            content()
        }
    }

    private var miniDivider: some View {
        Rectangle()
            .fill(fun ? Color.white.opacity(0.08) : Color.primary.opacity(0.06))
            .frame(height: 1)
    }

    private func miniPill(_ text: String, selected: Bool, colors: [Color], action: @escaping () -> Void) -> some View {
        MiniPillButton(text: text, icon: nil, selected: selected, colors: colors, action: action)
    }
}

// MARK: - Mini brand chip

private struct MiniBrandChip: View {
    let brand: Brand
    let isSelected: Bool
    let action: () -> Void
    @State private var pressing = false
    @State private var hovering = false
    @Environment(\.funMode) private var fun

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: brand.icon)
                    .font(.system(size: 15, weight: .medium))
                    .symbolEffect(.bounce, value: isSelected)
                Text(brand.config.abbreviation)
                    .font(.system(size: 12, weight: isSelected ? .black : .bold, design: fun ? .rounded : .default))
                    .lineLimit(1).minimumScaleFactor(0.7)
            }
            .foregroundStyle(fun ? .white : (isSelected ? Color(.windowBackgroundColor) : .primary))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 11)
            .background {
                if fun {
                    KeyCapShape(
                        topColors: isSelected ? FunColors.brandGradient(brand) : FunColors.brandGradient(brand).map { $0.opacity(0.2) },
                        shadowColor: isSelected ? FunColors.brandGlow(brand).opacity(0.6) : FunColors.keycapShadow,
                        isPressed: pressing, cornerRadius: DS.funRadius, depth: 6
                    )
                } else {
                    RoundedRectangle(cornerRadius: DS.funRadius)
                        .fill(isSelected ? Color.primary : Color.primary.opacity(hovering ? 0.1 : (pressing ? 0.07 : 0.05)))
                }
            }
            .overlay {
                if !fun && !isSelected {
                    RoundedRectangle(cornerRadius: DS.funRadius)
                        .stroke(Color.primary.opacity(hovering ? 0.2 : 0.12), lineWidth: hovering ? 1.5 : 1)
                }
            }
            .scaleEffect(hovering && !pressing ? (fun ? 1.06 : 1.02) : (pressing ? 0.95 : 1.0))
            .offset(y: fun ? (pressing ? 3 : 0) : 0)
            .shadow(color: fun && isSelected ? FunColors.brandGlow(brand).opacity(0.45) : .clear, radius: 6, y: 3)
            .modifier(CleanShadow(isSelected: isSelected, isHovered: hovering))
        }
        .buttonStyle(.plain)
        .onHover { h in withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { hovering = h } }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.06)) { pressing = true } }
                .onEnded   { _ in withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { pressing = false } }
        )
    }
}

// MARK: - Mini pill with hover

private struct MiniPillButton: View {
    let text: String
    var icon: String? = nil
    let selected: Bool
    let colors: [Color]
    let action: () -> Void
    @State private var hovering = false
    @State private var pressing = false
    @Environment(\.funMode) private var fun

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .medium))
                        .symbolEffect(.bounce, value: selected)
                }
                Text(text)
                    .font(.system(size: 14, weight: selected ? .bold : .medium, design: fun ? .rounded : .default))
                    .lineLimit(1).minimumScaleFactor(0.75)
            }
            .foregroundStyle(fun ? .white : (selected ? Color(.windowBackgroundColor) : .primary))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                if fun {
                    KeyCapShape(
                        topColors: selected ? colors : colors.map { $0.opacity(0.2) },
                        shadowColor: selected ? colors.first!.opacity(0.5) : FunColors.keycapShadow,
                        isPressed: pressing, cornerRadius: DS.funRadius, depth: 6
                    )
                } else {
                    RoundedRectangle(cornerRadius: DS.funRadius)
                        .fill(selected ? Color.primary : Color.primary.opacity(hovering ? 0.1 : 0.05))
                }
            }
            .overlay {
                if !fun && !selected {
                    RoundedRectangle(cornerRadius: DS.funRadius)
                        .stroke(Color.primary.opacity(hovering ? 0.2 : 0.12), lineWidth: hovering ? 1.5 : 1)
                }
            }
            .scaleEffect(fun ? (hovering && !pressing ? 1.04 : 1.0) : (hovering && !pressing ? 1.02 : (pressing ? 0.96 : 1.0)))
            .offset(y: fun ? (pressing ? 3 : 0) : 0)
            .shadow(color: fun && selected ? colors.first!.opacity(0.4) : .clear, radius: 6, y: 3)
            .modifier(CleanShadow(isSelected: selected, isHovered: hovering))
        }
        .buttonStyle(.plain)
        .onHover { h in withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { hovering = h } }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.06)) { pressing = true } }
                .onEnded   { _ in withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { pressing = false } }
        )
    }
}
