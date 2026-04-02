import Foundation

enum NotificationType: String, Sendable {
    case bookingReminder
    case postSession
    case protocolNudge
    case eventReminder
    case newContent
    case glowScanPrompt
    case productDrop
}

protocol NotificationServiceProtocol: Sendable {
    func requestPermission() async throws -> Bool
    func registerDeviceToken(_ token: Data) async throws
    func scheduleLocalNotification(type: NotificationType, title: String, body: String, at date: Date) async throws
    func cancelAllPending() async throws
    func updatePreferences(bookings: Bool, protocols: Bool, events: Bool, content: Bool, promotions: Bool) async throws
}
