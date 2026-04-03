import SwiftUI
import Sparkle

// Sparkle updater — shared instance
final class AppUpdater: ObservableObject {
    let updaterController: SPUStandardUpdaterController

    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }

    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }

    var canCheckForUpdates: Bool {
        updaterController.updater.canCheckForUpdates
    }
}

@main
struct AdNameGenieApp: App {
    @State private var form = FormState()
    @State private var historyStore = HistoryStore()
    @AppStorage("funMode") private var funModeEnabled = false
    @StateObject private var appUpdater = AppUpdater()

    var body: some Scene {
        Window("NameCraft", id: "main") {
            ContentView(form: form, historyStore: historyStore)
                .environment(\.funMode, funModeEnabled)
                .onAppear { form.restoreLastBrand() }
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 1050, height: 750)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check for Updates...") {
                    appUpdater.checkForUpdates()
                }
                .disabled(!appUpdater.canCheckForUpdates)
            }
        }

        MenuBarExtra {
            MiniPopoverView(form: form, historyStore: historyStore)
                .environment(\.funMode, funModeEnabled)
        } label: {
            Label("NameCraft", systemImage: "wand.and.stars")
        }
        .menuBarExtraStyle(.window)
    }
}
