import Foundation
import SwiftUI
import AppKit

@Observable
class FormState {
    var brand: Brand?
    var typeLabel: TypeLabel = .vid
    var taskNumber: String = ""
    var variation: Int = 1
    var platform: Platform?
    var funnel: String = ""
    var customFunnel: String = ""
    var additionalInfo: String = ""
    var language: String = "EN"
    var customLanguage: String = ""
    var date: Date = Date()
    var creativeProducer: String = ""
    var customCreativeProducer: String = ""
    var resolution: String = ""
    var customResolution: String = ""

    var useOtherFunnel: Bool = false
    var useOtherLanguage: Bool = false
    var useOtherResolution: Bool = false

    var taskNumberError: String = ""
    var additionalInfoError: String = ""

    var showCopiedToast: Bool = false

    var variationString: String { "v\(variation)" }

    var effectiveFunnel: String {
        guard let brand else { return "" }
        if brand.config.freeTextFunnel || useOtherFunnel {
            return customFunnel
        }
        return funnel
    }

    var effectiveLanguage: String {
        useOtherLanguage ? customLanguage : language
    }

    var effectiveCreativeProducer: String {
        guard let brand else { return "" }
        if brand.config.creativeProducers.isEmpty {
            return customCreativeProducer
        }
        return creativeProducer
    }

    var effectiveResolution: String {
        useOtherResolution ? customResolution : resolution
    }

    var isTaskNumberValid: Bool {
        guard !taskNumber.isEmpty else { return false }
        guard taskNumber.allSatisfy(\.isNumber) else { return false }
        guard taskNumber.count <= 6 else { return false }
        return true
    }

    func validateTaskNumber() {
        if taskNumber.isEmpty {
            taskNumberError = ""
        } else if !taskNumber.allSatisfy(\.isNumber) {
            taskNumberError = "Task number must contain only digits"
        } else if taskNumber.count > 6 {
            taskNumberError = "Task number must be 6 digits or less"
        } else {
            taskNumberError = ""
        }
    }

    func validateAdditionalInfo() {
        let invalidChars = CharacterSet(charactersIn: "/\\:*?\"<>|")
        if additionalInfo.unicodeScalars.contains(where: { invalidChars.contains($0) }) {
            additionalInfoError = "Contains invalid characters: / \\ : * ? \" < > |"
        } else if additionalInfo.count > 50 {
            additionalInfoError = "Maximum 50 characters"
        } else {
            additionalInfoError = ""
        }
    }

    var generatedFilename: String {
        guard let brand else { return "" }
        let config = brand.config

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateStr = dateFormatter.string(from: date)

        let typeTask = "\(typeLabel.rawValue)\(taskNumber)"
        let funnelValue = effectiveFunnel
        let cpValue = config.creativeProducers.isEmpty ? customCreativeProducer : creativeProducer
        let langValue = effectiveLanguage
        let resValue = effectiveResolution

        var parts: [String] = [config.abbreviation, typeTask, variationString]

        if let platform {
            parts.append(platform.rawValue)
        }
        if !funnelValue.isEmpty {
            parts.append(funnelValue)
        }
        if !additionalInfo.trimmingCharacters(in: .whitespaces).isEmpty {
            let sanitized = additionalInfo.trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: "[/\\\\:*?\"<>|]", with: "_", options: .regularExpression)
            parts.append(sanitized)
        }
        if !langValue.isEmpty {
            parts.append(langValue)
        }
        parts.append(dateStr)
        if !cpValue.isEmpty {
            parts.append(cpValue)
        }
        if !resValue.isEmpty {
            parts.append(resValue)
        }

        return parts.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: "_")
    }

    // Copy is allowed as long as we have a brand — user may want partial filenames
    var canCopy: Bool {
        brand != nil && !generatedFilename.isEmpty
    }

    func copyToClipboard() {
        guard canCopy else { return }
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(generatedFilename, forType: .string)
        showCopiedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.showCopiedToast = false
        }
    }

    var isBrandComplete: Bool { brand != nil }
    var isTypeTaskComplete: Bool { !taskNumber.isEmpty && isTaskNumberValid }
    var isPlatformComplete: Bool { platform != nil }
    var isFunnelComplete: Bool {
        if brand == nil { return false }
        if brand!.config.funnels.isEmpty && !brand!.config.freeTextFunnel { return true }
        return !effectiveFunnel.isEmpty
    }
    var isLanguageDateComplete: Bool { !effectiveLanguage.isEmpty }
    var isCreativeOutputComplete: Bool { !effectiveResolution.isEmpty }

    var completionCount: Int {
        [isBrandComplete, isTypeTaskComplete, isPlatformComplete, isFunnelComplete, isLanguageDateComplete, isCreativeOutputComplete].filter { $0 }.count
    }

    func isComplete(_ section: NavSection) -> Bool {
        switch section {
        case .brand: return isBrandComplete
        case .typeTask: return isTypeTaskComplete
        case .platform: return isPlatformComplete
        case .funnelInfo: return isFunnelComplete
        case .languageDate: return isLanguageDateComplete
        case .creativeOutput: return isCreativeOutputComplete
        }
    }

    // Maps each segment index in generatedFilename to a NavSection (mirrors conditional logic)
    var segmentSectionMap: [NavSection] {
        guard let brand else { return [] }
        let config = brand.config
        var map: [NavSection] = [.brand, .typeTask, .typeTask] // abbreviation, typeTask, variation

        if platform != nil { map.append(.platform) }

        let funnelValue = effectiveFunnel
        if !funnelValue.isEmpty { map.append(.funnelInfo) }

        let info = additionalInfo.trimmingCharacters(in: .whitespaces)
        if !info.isEmpty { map.append(.funnelInfo) }

        let langValue = effectiveLanguage
        if !langValue.isEmpty { map.append(.languageDate) }

        map.append(.languageDate) // date is always present

        let cpValue = config.creativeProducers.isEmpty ? customCreativeProducer : creativeProducer
        if !cpValue.isEmpty { map.append(.creativeOutput) }

        let resValue = effectiveResolution
        if !resValue.isEmpty { map.append(.creativeOutput) }

        return map
    }

    func clearAll() {
        brand = nil
        typeLabel = .vid
        taskNumber = ""
        variation = 1
        platform = nil
        funnel = ""
        customFunnel = ""
        additionalInfo = ""
        language = "EN"
        customLanguage = ""
        date = Date()
        creativeProducer = ""
        customCreativeProducer = ""
        resolution = ""
        customResolution = ""
        useOtherFunnel = false
        useOtherLanguage = false
        useOtherResolution = false
        taskNumberError = ""
        additionalInfoError = ""
    }

    func onBrandChange() {
        funnel = ""
        customFunnel = ""
        creativeProducer = ""
        customCreativeProducer = ""
        resolution = ""
        customResolution = ""
        useOtherFunnel = false
        useOtherResolution = false
        if let brand {
            if let first = brand.config.creativeProducers.first {
                creativeProducer = first.value
            }
            if let first = brand.config.resolutions.first {
                resolution = first.value
            }
            UserDefaults.standard.set(brand.rawValue, forKey: "lastBrand")
        }
    }

    func restoreLastBrand() {
        if let saved = UserDefaults.standard.string(forKey: "lastBrand"),
           let b = Brand(rawValue: saved) {
            brand = b
            if let first = b.config.creativeProducers.first {
                creativeProducer = first.value
            }
            if let first = b.config.resolutions.first {
                resolution = first.value
            }
        }
    }
}
