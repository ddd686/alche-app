import Foundation

enum ContentType: String, Codable, Sendable {
    case article
    case video
    case review

    var displayName: String {
        switch self {
        case .article: "Article"
        case .video: "Video"
        case .review: "Alche Reviewed"
        }
    }
}

struct Content: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var title: String
    var body: String?
    var contentType: ContentType?
    var imageURL: String?
    var videoURL: String?
    var tags: [String]
    var readingTimeMinutes: Int?
    var tierRequired: MembershipTier?
    var published: Bool
    var publishedAt: Date?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case contentType = "content_type"
        case imageURL = "image_url"
        case videoURL = "video_url"
        case tags
        case readingTimeMinutes = "reading_time_minutes"
        case tierRequired = "tier_required"
        case published
        case publishedAt = "published_at"
        case createdAt = "created_at"
    }
}

extension Content {
    static let preview = Content(
        id: UUID(),
        title: "Why Your Vitamin D Is Probably Low (Especially in Berlin)",
        body: "If you live above the 50th parallel...",
        contentType: .article,
        imageURL: nil,
        videoURL: nil,
        tags: ["vitamins", "winter", "berlin"],
        readingTimeMinutes: 5,
        tierRequired: .free,
        published: true,
        publishedAt: Date(),
        createdAt: Date()
    )
}
