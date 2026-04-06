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
    @State private var calViewDate = Date()

    var body: some View {
        VStack(spacing: 0) {
            miniHeader
            miniDivider
            miniFormContent
            miniDivider
            miniFooter
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
        .allowsHitTesting(true)
    }

    // MARK: - Form content (dropdowns for everything except variation)

    private var miniFormContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Brand
            miniSection("Brand") {
                Menu {
                    ForEach(Brand.allCases) { b in
                        Button("\(b.rawValue) (\(b.config.abbreviation))") { form.brand = b; form.onBrandChange() }
                    }
                } label: {
                    styledMenuLabel(form.brand?.rawValue ?? "", placeholder: "Select brand...")
                }
                .menuStyle(.borderlessButton).menuIndicator(.hidden)
            }

            // Type — pills
            miniSection("Type") {
                HStack(spacing: 6) {
                    miniTypePill("vid", selected: form.typeLabel == .vid) { form.typeLabel = .vid }
                    miniTypePill("img", selected: form.typeLabel == .img) { form.typeLabel = .img }
                }
            }

            // Task # + Variation pills side by side
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

                MiniVariationSection(form: form, fun: fun)
            }

            // Brand-dependent sections
            if let brand = form.brand {
                let config = brand.config
                miniDivider

                // Platform
                miniSection("Platform") {
                    Menu {
                        ForEach(Platform.allCases) { p in
                            Button(p.rawValue) { form.platform = p }
                        }
                    } label: {
                        styledMenuLabel(form.platform?.rawValue ?? "", placeholder: "Select platform...")
                    }
                    .menuStyle(.borderlessButton).menuIndicator(.hidden)
                }

                // Language
                miniSection("Language") {
                    Menu {
                        ForEach(Language.allCases) { lang in
                            Button("\(lang.flag) \(lang.rawValue)") { form.language = lang.rawValue; form.useOtherLanguage = false }
                        }
                    } label: {
                        styledMenuLabel(
                            form.language.isEmpty ? "" : "\(Language.allCases.first { $0.rawValue == form.language }?.flag ?? "") \(form.language)",
                            placeholder: "Select language..."
                        )
                    }
                    .menuStyle(.borderlessButton).menuIndicator(.hidden)
                }

                miniDivider

                // Funnel
                if config.freeTextFunnel {
                    miniSection("Funnel") {
                        TextField("Funnel name", text: Binding(get: { form.customFunnel }, set: { form.customFunnel = $0 }))
                            .textFieldStyle(.plain).font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 8).padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                            .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                    }
                } else if !config.funnels.isEmpty {
                    miniSection("Funnel") {
                        Menu {
                            ForEach(config.funnels, id: \.self) { f in
                                Button(f) { form.funnel = f; form.useOtherFunnel = false; form.customFunnel = "" }
                            }
                        } label: {
                            styledMenuLabel(form.funnel, placeholder: "Select funnel...")
                        }
                        .menuStyle(.borderlessButton).menuIndicator(.hidden)
                    }
                }

                // Additional Info
                miniSection("Info") {
                    HStack(spacing: 4) {
                        TextField("CI / SC / CT...", text: Binding(
                            get: { form.additionalInfo },
                            set: { form.additionalInfo = $0; form.validateAdditionalInfo() }
                        ))
                        .textFieldStyle(.plain).font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8).padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(
                            form.additionalInfoError.isEmpty ? (fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)) : Color.red.opacity(0.4)
                        ))
                        Text("\(form.additionalInfo.count)/50")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(fun ? Color.white.opacity(0.3) : .secondary).fixedSize()
                    }
                }

                // Date
                miniSection("Date") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            miniDateButton("Today") { form.date = Date(); calViewDate = Date() }
                            miniDateButton("Tomorrow") {
                                let d = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                                form.date = d; calViewDate = d
                            }
                            miniDateButton("+7 days") {
                                let d = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                                form.date = d; calViewDate = d
                            }
                            Spacer()
                        }
                        MiniCalendarView(
                            selected: Binding(get: { form.date }, set: { form.date = $0 }),
                            viewDate: $calViewDate
                        )
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
                        .textFieldStyle(.plain).font(.system(size: 12, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 8).padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.14) : Color.primary.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).strokeBorder(fun ? Color.white.opacity(0.12) : Color.primary.opacity(0.12)))
                    }
                } else {
                    miniSection("Producer") {
                        Menu {
                            ForEach(config.creativeProducers) { p in
                                Button(p.label) { form.creativeProducer = p.value }
                            }
                        } label: {
                            let label = config.creativeProducers.first { $0.value == form.creativeProducer }?.label ?? ""
                            styledMenuLabel(label, placeholder: "Select producer...")
                        }
                        .menuStyle(.borderlessButton).menuIndicator(.hidden)
                    }
                }

                // Resolution
                miniSection("Resolution") {
                    Menu {
                        ForEach(config.resolutions) { r in
                            Button(r.label) { form.resolution = r.value; form.useOtherResolution = false; form.customResolution = "" }
                        }
                    } label: {
                        let label = config.resolutions.first { $0.value == form.resolution }?.label ?? ""
                        styledMenuLabel(label, placeholder: "Select resolution...")
                    }
                    .menuStyle(.borderlessButton).menuIndicator(.hidden)
                }
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
    }

    // MARK: - Header

    private var miniHeader: some View {
        HStack(spacing: 6) {
            if fun { Text("✨").font(.system(size: 11)) }
            Text("NameCraft")
                .font(.system(size: 12, weight: .bold, design: fun ? .rounded : .default))
            Spacer()
            modeToggleButton
            expandButton
        }
        .padding(.horizontal, 14).padding(.top, 12).padding(.bottom, 8)
    }

    // MARK: - Footer (preview + copy)

    private var miniFooter: some View {
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

    private func styledMenuLabel(_ value: String, placeholder: String) -> some View {
        HStack(spacing: 6) {
            Text(value.isEmpty ? placeholder : value)
                .font(.system(size: 13, weight: .medium, design: fun ? .rounded : .default))
                .foregroundStyle(value.isEmpty ? Color.secondary : (fun ? Color.white : Color.primary))
            Spacer()
            Image(systemName: "chevron.up.chevron.down")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(fun ? .white.opacity(0.4) : .secondary)
        }
        .padding(.horizontal, 10).padding(.vertical, 9)
        .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.12) : Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: DS.funRadius).stroke(fun ? Color.white.opacity(0.1) : Color.white.opacity(0.12)))
    }

    private func miniTypePill(_ text: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button { withAnimation(.easeInOut(duration: 0.2)) { action() } } label: {
            Text(text)
                .font(.system(size: 14, weight: selected ? .bold : .medium, design: fun ? .rounded : .default))
                .foregroundStyle(selected ? (fun ? .white : Color.black) : (fun ? .white : Color.white))
                .frame(maxWidth: .infinity).padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(selected ? Color.white : Color.white.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: DS.funRadius).stroke(selected ? Color.clear : Color.white.opacity(0.12)))
        }
        .buttonStyle(.plain)
    }

    private func miniDateButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { action() }
        } label: {
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: fun ? .rounded : .default))
                .foregroundStyle(fun ? .white.opacity(0.7) : .white.opacity(0.55))
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Capsule().fill(fun ? Color.white.opacity(0.08) : Color.white.opacity(0.06)))
                .overlay(Capsule().stroke(fun ? Color.white.opacity(0.1) : Color.white.opacity(0.1)))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Mini variation pill

private struct MiniVariationPill: View {
    let label: String
    let isSelected: Bool
    let fun: Bool
    let action: () -> Void
    @State private var pressing = false

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .bold, design: fun ? .rounded : .monospaced))
                .foregroundStyle(isSelected ? (fun ? .white : Color.black) : (fun ? .white : Color.white))
                .frame(width: 30, height: 30)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: DS.funRadius)
                            .fill(fun
                                  ? AnyShapeStyle(LinearGradient(colors: [Color.purple, Color.purple.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                                  : AnyShapeStyle(Color.white))
                    } else {
                        RoundedRectangle(cornerRadius: DS.funRadius)
                            .fill(fun ? Color(white: 0.14) : Color.white.opacity(0.05))
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: DS.funRadius)
                    .strokeBorder(isSelected ? Color.clear : (fun ? Color.white.opacity(0.1) : Color.white.opacity(0.12)), lineWidth: 1))
                .scaleEffect(pressing ? 0.88 : 1)
                .animation(.spring(response: 0.18, dampingFraction: 0.6), value: pressing)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in pressing = true }
            .onEnded   { _ in pressing = false }
        )
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
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(fun ? Color.white.opacity(isSelected ? 0.22 : 0.1) : (isSelected ? Color.black.opacity(0.15) : Color.white.opacity(0.07)))
                        .frame(width: 32, height: 32)
                    Image(systemName: brand.icon)
                        .font(.system(size: 13, weight: .medium))
                        .symbolEffect(.bounce, value: isSelected)
                }
                Text(brand.config.abbreviation)
                    .font(.system(size: 11, weight: isSelected ? .black : .bold, design: fun ? .rounded : .default))
                    .lineLimit(1).minimumScaleFactor(0.7)
            }
            .foregroundStyle(fun ? .white : (isSelected ? Color.black : .white))
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
                        .fill(isSelected ? Color.white : Color.white.opacity(hovering ? 0.1 : (pressing ? 0.07 : 0.05)))
                }
            }
            .overlay {
                if !fun && !isSelected {
                    RoundedRectangle(cornerRadius: DS.funRadius)
                        .stroke(Color.white.opacity(hovering ? 0.2 : 0.12), lineWidth: hovering ? 1.5 : 1)
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
            .foregroundStyle(fun ? .white : (selected ? Color.black : .primary))
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
                        .fill(selected ? Color.white : Color.white.opacity(hovering ? 0.1 : 0.05))
                }
            }
            .overlay {
                if !fun && !selected {
                    RoundedRectangle(cornerRadius: DS.funRadius)
                        .stroke(Color.white.opacity(hovering ? 0.2 : 0.12), lineWidth: hovering ? 1.5 : 1)
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

// MARK: - Custom Calendar

private struct MiniCalendarView: View {
    @Binding var selected: Date
    @Binding var viewDate: Date
    @Environment(\.funMode) private var fun

    private let cal = Calendar.current
    private let dayNames = ["M","T","W","T","F","S","S"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)

    private var monthTitle: String {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f.string(from: viewDate)
    }

    private var daysInGrid: [(date: Date, dayNum: Int, inMonth: Bool)] {
        var items: [(Date, Int, Bool)] = []
        let firstOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: viewDate))!
        let startWeekday = (cal.component(.weekday, from: firstOfMonth) + 5) % 7
        let daysInMonth = cal.range(of: .day, in: .month, for: viewDate)!.count
        for i in (0..<startWeekday) {
            let d = cal.date(byAdding: .day, value: -(startWeekday - i), to: firstOfMonth)!
            items.append((d, cal.component(.day, from: d), false))
        }
        for day in 1...daysInMonth {
            let d = cal.date(byAdding: .day, value: day - 1, to: firstOfMonth)!
            items.append((d, day, true))
        }
        let rem = (7 - items.count % 7) % 7
        let afterStart = cal.date(byAdding: .day, value: daysInMonth, to: firstOfMonth)!
        for i in 0..<rem {
            let d = cal.date(byAdding: .day, value: i, to: afterStart)!
            items.append((d, i + 1, false))
        }
        return items
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 0) {
                Button { changeMonth(-1) } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(fun ? .white.opacity(0.5) : .secondary)
                        .frame(width: 26, height: 26)
                        .background(RoundedRectangle(cornerRadius: 7).fill(Color.primary.opacity(0.05)))
                }.buttonStyle(.plain)
                Spacer()
                Text(monthTitle)
                    .font(.system(size: 12, weight: .bold, design: fun ? .rounded : .default))
                    .foregroundStyle(fun ? .white : .primary)
                Spacer()
                Button { changeMonth(1) } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(fun ? .white.opacity(0.5) : .secondary)
                        .frame(width: 26, height: 26)
                        .background(RoundedRectangle(cornerRadius: 7).fill(Color.primary.opacity(0.05)))
                }.buttonStyle(.plain)
            }
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(dayNames.indices, id: \.self) { i in
                    Text(dayNames[i])
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(fun ? .white.opacity(0.28) : .secondary.opacity(0.55))
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(daysInGrid.enumerated()), id: \.offset) { _, item in
                    let isSel = cal.isDate(item.date, inSameDayAs: selected)
                    let isToday = cal.isDateInToday(item.date)
                    Button {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                            selected = item.date
                            if !item.inMonth { changeMonth(item.date > viewDate ? 1 : -1) }
                        }
                    } label: {
                        Text("\(item.dayNum)")
                            .font(.system(size: 12, weight: isSel ? .bold : .medium, design: fun ? .rounded : .default))
                            .foregroundStyle(
                                isSel ? .white :
                                item.inMonth ? (fun ? .white.opacity(0.85) : .primary) :
                                (fun ? .white.opacity(0.16) : .secondary.opacity(0.28))
                            )
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background {
                                if isSel {
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(fun
                                            ? LinearGradient(colors: [Color(red:0.49,green:0.36,blue:0.99), Color(red:0.61,green:0.43,blue:1.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            : LinearGradient(colors: [Color.accentColor, Color.accentColor], startPoint: .top, endPoint: .bottom)
                                        )
                                        .shadow(color: fun ? .purple.opacity(0.45) : .accentColor.opacity(0.3), radius: 4, y: 2)
                                } else if isToday {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(fun ? Color.purple.opacity(0.5) : Color.accentColor.opacity(0.5), lineWidth: 1)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(fun ? Color(white: 0.09) : Color.primary.opacity(0.04)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(fun ? Color.white.opacity(0.07) : Color.primary.opacity(0.08)))
    }

    private func changeMonth(_ delta: Int) {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
            viewDate = Calendar.current.date(byAdding: .month, value: delta, to: viewDate) ?? viewDate
        }
    }
}

// MARK: - Custom Dropdown

struct MiniDropdownOption: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

private struct MiniDropdown: View {
    let options: [MiniDropdownOption]
    @Binding var selection: String
    var placeholder: String = "Select..."
    var customValue: Binding<String>? = nil
    var customPlaceholder: String = "Type here..."
    @State private var isOpen = false
    @Environment(\.funMode) private var fun

    private var selectedLabel: String {
        options.first { $0.value == selection }?.label ?? placeholder
    }
    private var isOther: Bool { selection == "__other__" }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Trigger button with floating overlay menu
            Button { withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) { isOpen.toggle() } } label: {
                HStack(spacing: 6) {
                    Text(isOther ? "Other..." : (selection.isEmpty ? placeholder : selectedLabel))
                        .font(.system(size: 13, weight: .medium, design: fun ? .rounded : .default))
                        .foregroundStyle(selection.isEmpty ? (fun ? .white.opacity(0.3) : .secondary) : (fun ? .white : .primary))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(fun ? .white.opacity(0.4) : .secondary)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                        .animation(.spring(response: 0.25), value: isOpen)
                }
                .padding(.horizontal, 10).padding(.vertical, 9)
                .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.12) : Color.primary.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: DS.funRadius).stroke(
                    isOpen ? (fun ? Color.purple.opacity(0.5) : Color.accentColor.opacity(0.5)) : (fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.12)),
                    lineWidth: isOpen ? 1.5 : 1
                ))
            }
            .buttonStyle(.plain)
            .overlay(alignment: .topLeading) {
                if isOpen {
                    VStack(spacing: 1) {
                        ForEach(options) { opt in
                            optionRow(label: opt.label, value: opt.value)
                        }
                        Divider().padding(.horizontal, 6).padding(.vertical, 2).opacity(0.35)
                        optionRow(label: "Other...", value: "__other__", dimmed: true)
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: DS.funRadius + 2).fill(fun ? Color(white: 0.10) : Color(.windowBackgroundColor)))
                    .overlay(RoundedRectangle(cornerRadius: DS.funRadius + 2).stroke(fun ? Color.white.opacity(0.08) : Color.primary.opacity(0.1)))
                    .shadow(color: .black.opacity(fun ? 0.5 : 0.25), radius: 12, y: 4)
                    .offset(y: 38)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.96, anchor: .top).combined(with: .opacity),
                        removal: .scale(scale: 0.96, anchor: .top).combined(with: .opacity)
                    ))
                }
            }
            .zIndex(isOpen ? 100 : 0)

            if isOther, let cv = customValue {
                TextField(customPlaceholder, text: cv)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .padding(.horizontal, 10).padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: DS.funRadius).fill(fun ? Color(white: 0.12) : Color.primary.opacity(0.05)))
                    .overlay(RoundedRectangle(cornerRadius: DS.funRadius).stroke(fun ? Color.purple.opacity(0.35) : Color.accentColor.opacity(0.35), lineWidth: 1))
            }
        }
    }

    private func optionRow(label: String, value: String, dimmed: Bool = false) -> some View {
        let isSel = selection == value
        return Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) { selection = value; isOpen = false }
        } label: {
            HStack {
                Text(label)
                    .font(.system(size: 12, weight: isSel ? .semibold : .medium, design: fun ? .rounded : .default))
                    .foregroundStyle(
                        dimmed ? (fun ? .white.opacity(0.4) : .secondary) :
                        (fun ? .white.opacity(isSel ? 1 : 0.78) : .primary.opacity(isSel ? 1 : 0.85))
                    )
                Spacer()
                if isSel {
                    Image(systemName: "checkmark").font(.system(size: 10, weight: .bold))
                        .foregroundStyle(fun ? Color.purple : Color.accentColor)
                }
            }
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(isSel ? (fun ? Color.purple.opacity(0.15) : Color.accentColor.opacity(0.08)) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Mini variation section

private struct MiniVariationSection: View {
    var form: FormState
    let fun: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("VARIATION")
                .font(.system(size: 10, weight: .semibold, design: fun ? .rounded : .default))
                .foregroundStyle(fun ? Color.white.opacity(0.4) : Color.secondary)
                .tracking(0.5)
            HStack(spacing: 4) {
                ForEach([1, 2, 3, 4, 5], id: \.self) { n in
                    MiniVariationPill(
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
                if form.useOtherVariation {
                    TextField("#", text: Binding(
                        get: { form.customVariation },
                        set: { form.customVariation = $0.filter { $0.isNumber } }
                    ))
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .frame(width: 36, height: 30)
                    .background(RoundedRectangle(cornerRadius: DS.funRadius)
                        .fill(fun ? Color.purple.opacity(0.2) : Color.white.opacity(0.06)))
                    .overlay(RoundedRectangle(cornerRadius: DS.funRadius)
                        .strokeBorder(fun ? Color.purple.opacity(0.6) : Color.white.opacity(0.3), lineWidth: 1.5))
                } else {
                    MiniVariationPill(label: "…", isSelected: false, fun: fun) {
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

// MARK: - Extracted grids (reduce body complexity for type-checker)

private struct MiniBrandGrid: View {
    var form: FormState
    var body: some View {
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
}

private struct MiniPlatformGrid: View {
    var form: FormState
    @Environment(\.funMode) private var fun
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
            ForEach(Platform.allCases) { p in
                MiniPillButton(text: p.rawValue, selected: form.platform == p, colors: FunColors.platformGradient(p)) {
                    withAnimation(.easeInOut(duration: 0.2)) { form.platform = p }
                }
            }
        }
    }
}
