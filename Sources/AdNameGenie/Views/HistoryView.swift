import SwiftUI
import AppKit

struct HistoryView: View {
    var historyStore: HistoryStore
    @Bindable var form: FormState
    @State private var showClearConfirmation = false
    @State private var copiedId: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Filename History")
                        .font(.system(size: 15, weight: .semibold))
                    if !historyStore.entries.isEmpty {
                        Text("Your last \(historyStore.entries.count) generated filename\(historyStore.entries.count == 1 ? "" : "s")")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if !historyStore.entries.isEmpty {
                    Button("Clear All") {
                        showClearConfirmation = true
                    }
                    .controlSize(.small)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Divider()

            if historyStore.entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 32))
                        .foregroundStyle(.quaternary)
                    Text("No history yet")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text("Generate your first filename and it will appear here for quick access later.")
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(historyStore.entries) { entry in
                            HistoryRow(
                                entry: entry,
                                isCopied: copiedId == entry.id,
                                onCopy: { copyEntry(entry) },
                                onLoad: { historyStore.loadConfig(from: entry, into: form) },
                                onToggleFavorite: { historyStore.toggleFavorite(entry) }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
        }
        .alert("Clear History?", isPresented: $showClearConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear History", role: .destructive) { historyStore.clearAll() }
        } message: {
            Text("This will delete all \(historyStore.entries.count) entries. This action cannot be undone.")
        }
    }

    private func copyEntry(_ entry: HistoryEntry) {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(entry.filename, forType: .string)
        copiedId = entry.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            if copiedId == entry.id { copiedId = nil }
        }
    }
}

struct HistoryRow: View {
    let entry: HistoryEntry
    let isCopied: Bool
    let onCopy: () -> Void
    let onLoad: () -> Void
    let onToggleFavorite: () -> Void

    @State private var hovered = false

    var body: some View {
        HStack(spacing: 10) {
            // Favorite indicator
            if entry.isFavorite {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(.yellow)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.filename)
                    .font(.system(size: 12, design: .monospaced))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .textSelection(.enabled)
                HStack(spacing: 4) {
                    Text(entry.timestamp, style: .relative)
                    Text("ago")
                }
                .font(.system(size: 10))
                .foregroundStyle(.quaternary)
            }

            Spacer()

            if hovered || isCopied {
                HStack(spacing: 4) {
                    IconActionButton(icon: "arrow.down.doc", help: "Load config", action: onLoad)
                    IconActionButton(
                        icon: entry.isFavorite ? "star.fill" : "star",
                        help: "Favorite",
                        color: entry.isFavorite ? .yellow : .secondary,
                        action: onToggleFavorite
                    )
                    IconActionButton(
                        icon: isCopied ? "checkmark.circle.fill" : "doc.on.doc",
                        help: "Copy",
                        color: isCopied ? .green : .secondary,
                        action: onCopy
                    )
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(hovered ? Color.primary.opacity(0.03) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(entry.isFavorite ? Color.yellow.opacity(0.25) : (hovered ? Color.primary.opacity(0.08) : Color.clear), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onHover { h in withAnimation(.easeOut(duration: 0.12)) { hovered = h } }
    }
}

struct IconActionButton: View {
    let icon: String
    let help: String
    var color: Color = .secondary
    let action: () -> Void

    @State private var hovered = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(hovered ? .primary : color)
                .frame(width: 26, height: 26)
                .background(hovered ? Color.primary.opacity(0.06) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .help(help)
        .onHover { hovered = $0 }
    }
}
