import Foundation

struct CreativeProducer: Identifiable, Codable, Hashable {
    var id: String { value }
    let label: String
    let value: String
}

struct Resolution: Identifiable, Codable, Hashable {
    var id: String { value }
    let label: String
    let value: String
}

struct BrandConfig {
    let abbreviation: String
    let funnels: [String]
    let creativeProducers: [CreativeProducer]
    let resolutions: [Resolution]
    let freeTextFunnel: Bool
}

enum Brand: String, CaseIterable, Identifiable {
    case hint = "Hint"
    case clarityCheck = "ClarityCheck"
    case cerebrum = "Cerebrum"
    case vb = "VB"
    case useAI = "UseAI"
    case masterly = "Masterly"
    case zendocs = "Zendocs"
    case sagaBox = "SagaBox"
    case getQR = "GetQR"
    case jobAssist = "JobAssist"

    var id: String { rawValue }

    var config: BrandConfig {
        switch self {
        case .hint:
            return BrandConfig(
                abbreviation: "Hint",
                funnels: ["SL", "PL", "BF", "NC", "AC"],
                creativeProducers: [
                    CreativeProducer(label: "Vasilisa Murasheva - VM", value: "VM"),
                    CreativeProducer(label: "Liza Kovalska - LK", value: "LK"),
                    CreativeProducer(label: "Sarah Hartland - SH", value: "SH"),
                    CreativeProducer(label: "Natalie Hekaliuk - NH", value: "NH"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1080x1920_R", value: "1080x1920_R"),
                ],
                freeTextFunnel: false
            )
        case .clarityCheck:
            return BrandConfig(
                abbreviation: "CC",
                funnels: ["Image", "Phone", "Email", "all"],
                creativeProducers: [
                    CreativeProducer(label: "Oleh Makarichev - OM", value: "OM"),
                    CreativeProducer(label: "Mariam Khutchua - MK", value: "MK"),
                ],
                resolutions: [
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1080x1350", value: "1080x1350"),
                    Resolution(label: "1080x1920", value: "1080x1920"),
                ],
                freeTextFunnel: false
            )
        case .cerebrum:
            return BrandConfig(
                abbreviation: "CR",
                funnels: ["IQ", "personality", "love"],
                creativeProducers: [
                    CreativeProducer(label: "Anastasiia Yanhol - AY", value: "AY"),
                    CreativeProducer(label: "Elena Castilla - EC", value: "EC"),
                    CreativeProducer(label: "Din Musaiev - DM", value: "DM"),
                    CreativeProducer(label: "Nataliia Bielousova - NB", value: "NB"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: false
            )
        case .vb:
            return BrandConfig(
                abbreviation: "VB",
                funnels: [],
                creativeProducers: [],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        case .useAI:
            return BrandConfig(
                abbreviation: "AI",
                funnels: [],
                creativeProducers: [
                    CreativeProducer(label: "Melike Su Uzun - MU", value: "MU"),
                    CreativeProducer(label: "Josef Roditi - JR", value: "JR"),
                    CreativeProducer(label: "Gleb Torubarov - GT", value: "GT"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        case .masterly:
            return BrandConfig(
                abbreviation: "MR",
                funnels: [],
                creativeProducers: [
                    CreativeProducer(label: "Tudor Sorea - TS", value: "TS"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        case .zendocs:
            return BrandConfig(
                abbreviation: "ZD",
                funnels: [],
                creativeProducers: [],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        case .sagaBox:
            return BrandConfig(
                abbreviation: "SB",
                funnels: [],
                creativeProducers: [
                    CreativeProducer(label: "Francisco Garcia - FG", value: "FG"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        case .getQR:
            return BrandConfig(
                abbreviation: "QR",
                funnels: [],
                creativeProducers: [
                    CreativeProducer(label: "Liza Kovalska - LK", value: "LK"),
                    CreativeProducer(label: "Sarah Hartland - SH", value: "SH"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        case .jobAssist:
            return BrandConfig(
                abbreviation: "JA",
                funnels: [],
                creativeProducers: [
                    CreativeProducer(label: "Anastasiia Yanhol - AY", value: "AY"),
                    CreativeProducer(label: "Din Musaiev - DM", value: "DM"),
                    CreativeProducer(label: "Andrei Vialichka - AV", value: "AV"),
                ],
                resolutions: [
                    Resolution(label: "1080x1920", value: "1080x1920"),
                    Resolution(label: "1080x1080", value: "1080x1080"),
                    Resolution(label: "1920x1080", value: "1920x1080"),
                ],
                freeTextFunnel: true
            )
        }
    }

    var icon: String {
        switch self {
        case .hint: return "lightbulb"
        case .clarityCheck: return "eye"
        case .cerebrum: return "brain"
        case .vb: return "wand.and.stars"
        case .useAI: return "sparkles"
        case .masterly: return "cloud"
        case .zendocs: return "doc.text"
        case .sagaBox: return "book"
        case .getQR: return "qrcode"
        case .jobAssist: return "building.2"
        }
    }
}

enum TypeLabel: String, CaseIterable {
    case vid
    case img

    var icon: String {
        switch self {
        case .vid: return "video"
        case .img: return "photo"
        }
    }
}

enum Platform: String, CaseIterable, Identifiable {
    case FB, GL, QU, TT, OB, NB, SP, SF

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .FB: return "f.cursive"
        case .GL: return "globe"
        case .QU: return "bubble.left"
        case .TT: return "music.note"
        case .OB: return "circle.grid.2x2"
        case .NB: return "bolt"
        case .SP: return "iphone"
        case .SF: return "rectangle"
        }
    }

    var shortcutKey: String? {
        switch self {
        case .FB: return "F"
        case .GL: return "G"
        case .QU: return "Q"
        case .TT: return "T"
        default: return nil
        }
    }
}

enum Language: String, CaseIterable, Identifiable {
    case EN, ES, FR, DE

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .EN: return "🇬🇧"
        case .ES: return "🇪🇸"
        case .FR: return "🇫🇷"
        case .DE: return "🇩🇪"
        }
    }

    var shortcutNumber: String {
        switch self {
        case .EN: return "1"
        case .ES: return "2"
        case .FR: return "3"
        case .DE: return "4"
        }
    }
}
