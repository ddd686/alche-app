import UIKit

enum HapticManager {

    /// Light tap -- toggling, selections
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// Medium tap -- confirmations, successful actions
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// Success -- booking confirmed, check-in complete
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// Error -- failed action, validation error
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    /// Selection changed -- picker, slider
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
