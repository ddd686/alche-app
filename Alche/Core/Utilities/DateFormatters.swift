import Foundation

enum AlcheDateFormatters {

    // MARK: - Display Formatters

    /// "Monday, 21 February" -- event dates, booking dates
    static let fullDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }()

    /// "21 Feb 2026" -- compact date display
    static let mediumDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    /// "10:00" -- slot times, event times
    static let time: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    /// "10:00 - 10:15" -- booking slot display
    static func slotRange(start: Date, end: Date) -> String {
        "\(time.string(from: start)) \u{2013} \(time.string(from: end))"
    }

    /// "21 Feb" -- compact, for charts and lists
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f
    }()

    /// "Feb 2026" -- month headers
    static let monthYear: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        return f
    }()

    // MARK: - Relative

    /// "in 30 minutes", "yesterday", "2 hours ago"
    nonisolated(unsafe) static let relative: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .full
        return f
    }()

    /// "30 min" -- compact relative for cards
    nonisolated(unsafe) static let relativeShort: RelativeDateTimeFormatter = {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .abbreviated
        return f
    }()

    // MARK: - ISO / API

    /// ISO 8601 for Supabase queries
    nonisolated(unsafe) static let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
}
