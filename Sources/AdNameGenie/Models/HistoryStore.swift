import Foundation

struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let filename: String
    let timestamp: Date
    let config: HistoryConfig
    var isFavorite: Bool

    init(filename: String, config: HistoryConfig, isFavorite: Bool = false) {
        self.id = UUID()
        self.filename = filename
        self.timestamp = Date()
        self.config = config
        self.isFavorite = isFavorite
    }
}

struct HistoryConfig: Codable {
    let brand: String
    let typeLabel: String
    let taskNumber: String
    let variation: Int
    let platform: String
    let funnel: String
    let additionalInfo: String
    let language: String
    let date: Date
    let creativeProducer: String
    let resolution: String
}

@Observable
class HistoryStore {
    var entries: [HistoryEntry] = []
    private let maxEntries = 50

    private var fileURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("AdNameGenie", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("history.json")
    }

    init() {
        load()
    }

    func add(filename: String, form: FormState) {
        let config = HistoryConfig(
            brand: form.brand?.rawValue ?? "",
            typeLabel: form.typeLabel.rawValue,
            taskNumber: form.taskNumber,
            variation: form.variation,
            platform: form.platform?.rawValue ?? "",
            funnel: form.effectiveFunnel,
            additionalInfo: form.additionalInfo,
            language: form.effectiveLanguage,
            date: form.date,
            creativeProducer: form.effectiveCreativeProducer,
            resolution: form.effectiveResolution
        )
        let entry = HistoryEntry(filename: filename, config: config)
        entries.insert(entry, at: 0)
        if entries.count > maxEntries {
            entries = Array(entries.prefix(maxEntries))
        }
        save()
    }

    func toggleFavorite(_ entry: HistoryEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx].isFavorite.toggle()
            save()
        }
    }

    func clearAll() {
        entries.removeAll()
        save()
    }

    func loadConfig(from entry: HistoryEntry, into form: FormState) {
        form.brand = Brand(rawValue: entry.config.brand)
        form.typeLabel = TypeLabel(rawValue: entry.config.typeLabel) ?? .vid
        form.taskNumber = entry.config.taskNumber
        form.variation = entry.config.variation
        if let plat = Platform(rawValue: entry.config.platform) {
            form.platform = plat
        }
        form.date = entry.config.date

        // Handle funnel
        if let brand = form.brand {
            let config = brand.config
            if config.funnels.contains(entry.config.funnel) {
                form.funnel = entry.config.funnel
                form.useOtherFunnel = false
            } else if config.freeTextFunnel {
                form.customFunnel = entry.config.funnel
            } else {
                form.useOtherFunnel = true
                form.customFunnel = entry.config.funnel
            }
        }

        form.additionalInfo = entry.config.additionalInfo

        // Handle language
        if Language(rawValue: entry.config.language) != nil {
            form.language = entry.config.language
            form.useOtherLanguage = false
        } else {
            form.useOtherLanguage = true
            form.customLanguage = entry.config.language
        }

        // Handle creative producer
        if let brand = form.brand {
            if brand.config.creativeProducers.contains(where: { $0.value == entry.config.creativeProducer }) {
                form.creativeProducer = entry.config.creativeProducer
            } else {
                form.customCreativeProducer = entry.config.creativeProducer
            }
        }

        // Handle resolution
        if let brand = form.brand {
            if brand.config.resolutions.contains(where: { $0.value == entry.config.resolution }) {
                form.resolution = entry.config.resolution
                form.useOtherResolution = false
            } else {
                form.useOtherResolution = true
                form.customResolution = entry.config.resolution
            }
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save history: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            entries = try JSONDecoder().decode([HistoryEntry].self, from: data)
        } catch {
            print("Failed to load history: \(error)")
        }
    }
}
