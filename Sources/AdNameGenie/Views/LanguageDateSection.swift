import SwiftUI

struct LanguageDateSection: View {
    @Bindable var form: FormState
    @Environment(\.funMode) private var fun
    @State private var showCalendar = false

    private let langCols = Array(repeating: GridItem(.flexible(), spacing: DS.gridGap), count: 2)

    private var formattedDate: String {
        let f = DateFormatter(); f.dateFormat = "dd-MM-yyyy"; return f.string(from: form.date)
    }

    var body: some View {
        FormSection(number: 5, title: "Language & Date", funTitle: "Language & When?") {
            VStack(alignment: .leading, spacing: DS.fieldGap) {

                // Language
                VStack(alignment: .leading, spacing: 8) {
                    FieldLabel(text: "Language")
                    LazyVGrid(columns: langCols, spacing: DS.gridGap) {
                        ForEach(Language.allCases) { lang in
                            FilledPill(
                                label: "\(lang.flag) \(lang.rawValue)",
                                isSelected: !form.useOtherLanguage && form.language == lang.rawValue,
                                action: { form.language = lang.rawValue; form.useOtherLanguage = false },
                                funGradient: FunColors.langGradient(lang.rawValue)
                            )
                        }
                        OtherFieldCard(
                            isActive: form.useOtherLanguage,
                            placeholder: "Language code (e.g. PT)",
                            text: $form.customLanguage,
                            onActivate: {
                                form.useOtherLanguage.toggle()
                                if !form.useOtherLanguage { form.customLanguage = ""; form.language = "EN" }
                            }
                        )
                    }
                }

                // Date
                VStack(alignment: .leading, spacing: 8) {
                    FieldLabel(text: "Date")

                    // Quick date buttons
                    HStack(spacing: 8) {
                        quickDate("Today") { form.date = Date() }
                        quickDate("Tomorrow") { form.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date() }
                        quickDate("+7 days") { form.date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date() }
                        Spacer()
                    }

                    // Custom calendar display — click to toggle inline calendar
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { showCalendar.toggle() }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "calendar")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(fun ? .cyan : .secondary)
                            Text(formattedDate)
                                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                .foregroundStyle(fun ? .white : .primary)
                            Spacer()
                            Image(systemName: showCalendar ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(fun ? .white.opacity(0.4) : .secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background {
                            if fun {
                                KeyCapShape(
                                    topColors: [Color(red: 0.18, green: 0.38, blue: 0.48), Color(red: 0.1, green: 0.25, blue: 0.35)],
                                    shadowColor: Color(red: 0.05, green: 0.1, blue: 0.15),
                                    isPressed: false,
                                    cornerRadius: DS.funRadius,
                                    depth: 5
                                )
                            } else {
                                RoundedRectangle(cornerRadius: DS.radius)
                                    .fill(Color.primary.opacity(0.03))
                            }
                        }
                        .overlay {
                            if !fun {
                                RoundedRectangle(cornerRadius: DS.radius)
                                    .stroke(Color.primary.opacity(0.1))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    // Inline calendar grid
                    if showCalendar {
                        InlineCalendar(selectedDate: $form.date)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
        }
    }

    private func quickDate(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.65)) { action() }
        } label: {
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: fun ? .rounded : .default))
                .foregroundStyle(fun ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background {
                    if fun {
                        Capsule().fill(Color.white.opacity(0.08))
                    } else {
                        Capsule().fill(Color.primary.opacity(0.04))
                    }
                }
                .overlay(Capsule().stroke(fun ? Color.white.opacity(0.1) : Color.primary.opacity(0.1)))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Inline calendar grid

struct InlineCalendar: View {
    @Binding var selectedDate: Date
    @Environment(\.funMode) private var fun
    @State private var displayedMonth: Date

    private let calendar = Calendar.current
    private let dayNames = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._displayedMonth = State(initialValue: selectedDate.wrappedValue)
    }

    private var monthTitle: String {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f.string(from: displayedMonth)
    }

    private var daysInMonth: [Date?] {
        let range = calendar.range(of: .day, in: .month, for: displayedMonth)!
        let comps = calendar.dateComponents([.year, .month], from: displayedMonth)
        let firstDay = calendar.date(from: comps)!
        let weekdayOfFirst = (calendar.component(.weekday, from: firstDay) + 5) % 7 // Mon=0
        var days: [Date?] = Array(repeating: nil, count: weekdayOfFirst)
        for day in range {
            var dc = comps; dc.day = day
            days.append(calendar.date(from: dc))
        }
        return days
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    private func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    var body: some View {
        VStack(spacing: 10) {
            // Month nav
            HStack {
                Button { shiftMonth(-1) } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(fun ? .white.opacity(0.6) : .secondary)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)

                Spacer()
                Text(monthTitle)
                    .font(.system(size: 13, weight: .semibold, design: fun ? .rounded : .default))
                    .foregroundStyle(fun ? .white : .primary)
                Spacer()

                Button { shiftMonth(1) } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(fun ? .white.opacity(0.6) : .secondary)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }

            // Day headers
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(dayNames, id: \.self) { name in
                    Text(name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(fun ? .white.opacity(0.3) : .secondary)
                        .frame(maxWidth: .infinity)
                }

                // Day cells
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date {
                        Button {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) { selectedDate = date }
                        } label: {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 13, weight: isSelected(date) ? .bold : (isToday(date) ? .semibold : .regular)))
                                .foregroundStyle(
                                    isSelected(date) ? .white :
                                    (fun ? .white.opacity(0.8) : .primary)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .contentShape(Rectangle())
                                .background {
                                    if isSelected(date) {
                                        if fun {
                                            RoundedRectangle(cornerRadius: 7)
                                                .fill(LinearGradient(colors: [.cyan, .blue.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                                        } else {
                                            RoundedRectangle(cornerRadius: 7)
                                                .fill(Color.primary)
                                        }
                                    } else if isToday(date) {
                                        RoundedRectangle(cornerRadius: 7)
                                            .stroke(fun ? Color.cyan.opacity(0.4) : Color.primary.opacity(0.2), lineWidth: 1)
                                    }
                                }
                                .shadow(color: isSelected(date) && fun ? .cyan.opacity(0.4) : .clear, radius: 6, y: 2)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Text("")
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                    }
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: DS.radius).fill(fun ? Color(white: 0.1) : Color.primary.opacity(0.02)))
        .overlay(RoundedRectangle(cornerRadius: DS.radius).stroke(fun ? Color.white.opacity(0.06) : Color.primary.opacity(0.06)))
    }

    private func shiftMonth(_ delta: Int) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            displayedMonth = calendar.date(byAdding: .month, value: delta, to: displayedMonth) ?? displayedMonth
        }
    }
}
