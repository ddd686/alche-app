import Foundation

@Observable
@MainActor
final class DiscoverViewModel {
    // MARK: - State

    var selectedSection: DiscoverSection = .content
    var articles: [Content] = []
    var events: [Event] = []
    var userRSVPs: Set<UUID> = []
    var bookmarkedContentIds: Set<UUID> = []
    var isLoading = false
    var errorMessage: String?

    // Eat Out state
    var restaurants: [PartnerRestaurant] = []

    enum DiscoverSection: String, CaseIterable {
        case content = "Read"
        case events = "Events"
        case eatOut = "Eat Out"
        case saved = "Saved"
    }

    // MARK: - Services

    private let restaurantService: RestaurantServiceProtocol = MockRestaurantService()

    // MARK: - Actions

    func loadContent() async {
        isLoading = true

        // TODO: Wire to real services
        try? await Task.sleep(for: .seconds(0.5))

        articles = Self.sampleArticles
        events = Self.sampleEvents

        // Load partner restaurants
        do {
            restaurants = try await restaurantService.allRestaurants()
        } catch {
            restaurants = []
        }

        isLoading = false
    }

    func rsvp(eventId: UUID) async {
        // TODO: Wire to EventServiceProtocol
        try? await Task.sleep(for: .seconds(0.5))
        userRSVPs.insert(eventId)

        if let idx = events.firstIndex(where: { $0.id == eventId }) {
            events[idx].rsvpCount += 1
        }
    }

    func cancelRSVP(eventId: UUID) async {
        // TODO: Wire to EventServiceProtocol
        try? await Task.sleep(for: .seconds(0.3))
        userRSVPs.remove(eventId)

        if let idx = events.firstIndex(where: { $0.id == eventId }) {
            events[idx].rsvpCount = max(0, events[idx].rsvpCount - 1)
        }
    }

    func isRSVPd(_ eventId: UUID) -> Bool {
        userRSVPs.contains(eventId)
    }

    // MARK: - Bookmarks

    func toggleBookmark(_ content: Content) {
        if bookmarkedContentIds.contains(content.id) {
            bookmarkedContentIds.remove(content.id)
        } else {
            bookmarkedContentIds.insert(content.id)
        }
        // TODO: Wire to Supabase favorites table (FavoriteType.content)
    }

    func isBookmarked(_ contentId: UUID) -> Bool {
        bookmarkedContentIds.contains(contentId)
    }

    var bookmarkedArticles: [Content] {
        articles.filter { bookmarkedContentIds.contains($0.id) }
    }

    var bookmarkCount: Int {
        bookmarkedContentIds.count
    }

    // MARK: - Sample Data

    private static let sampleArticles: [Content] = [
        Content(
            id: UUID(), title: "Why Your Vitamin D Is Probably Low (Especially in Berlin)",
            body: "If you live above the 50th parallel — and Berlin sits at 52°N — your body produces virtually no vitamin D from sunlight between October and March. This isn't a niche concern. An estimated 60% of Germans are vitamin D insufficient during winter months...",
            contentType: .article, imageURL: nil, videoURL: nil,
            tags: ["vitamins", "winter", "berlin"],
            readingTimeMinutes: 5, tierRequired: .free,
            published: true, publishedAt: Date(), createdAt: Date()
        ),
        Content(
            id: UUID(), title: "Red Light: What the Science Actually Says",
            body: "Photobiomodulation — the process behind red and near-infrared light exposure — has over 5,000 peer-reviewed studies behind it. But what does the evidence actually support?",
            contentType: .review, imageURL: nil, videoURL: nil,
            tags: ["LED", "science", "alche reviewed"],
            readingTimeMinutes: 7, tierRequired: .free,
            published: true, publishedAt: Date().addingTimeInterval(-86400), createdAt: Date()
        ),
        Content(
            id: UUID(), title: "The Berlin Winter Wellness Playbook",
            body: "Dark mornings, 4pm sunsets, damp cold that settles in your bones. Berlin winters are beautiful but challenging for your body. Here's how to lean into the season instead of fighting it...",
            contentType: .article, imageURL: nil, videoURL: nil,
            tags: ["berlin", "winter", "lifestyle"],
            readingTimeMinutes: 6, tierRequired: .free,
            published: true, publishedAt: Date().addingTimeInterval(-172800), createdAt: Date()
        ),
        Content(
            id: UUID(), title: "The Sleep Protocol: A Deep Dive",
            body: "Sleep is the single most impactful wellness lever most people underutilise. Our Sleep Protocol isn't about hacking your way to 4 hours — it's about making your 7-8 hours count...",
            contentType: .article, imageURL: nil, videoURL: nil,
            tags: ["sleep", "protocol", "magnesium"],
            readingTimeMinutes: 8, tierRequired: .core,
            published: true, publishedAt: Date().addingTimeInterval(-259200), createdAt: Date()
        ),
        Content(
            id: UUID(), title: "Collagen: Overhyped or Underrated?",
            body: "The collagen supplement market is projected to hit $7B by 2028. But does swallowing hydrolysed collagen actually do anything for your skin? We reviewed 23 clinical trials...",
            contentType: .review, imageURL: nil, videoURL: nil,
            tags: ["collagen", "supplements", "alche reviewed"],
            readingTimeMinutes: 9, tierRequired: .free,
            published: true, publishedAt: Date().addingTimeInterval(-345600), createdAt: Date()
        ),
    ]

    private static let sampleEvents: [Event] = [
        Event(
            id: UUID(),
            title: "Winter Light: An Evening on Sleep",
            description: "Join us for an intimate conversation about the science of sleep, circadian rhythm, and how light exposure shapes your rest. Featuring a sleep-optimised smoothie tasting.",
            eventDate: Date().addingTimeInterval(86400 * 3),
            location: "Alche, Berlin Mitte",
            capacity: 30, rsvpCount: 22, imageURL: nil,
            eventType: .salon, createdAt: Date()
        ),
        Event(
            id: UUID(),
            title: "Functional Nutrition Workshop",
            description: "A hands-on workshop exploring how to use food as fuel. Learn to build meals around your wellness goals — from gut health to sustained energy.",
            eventDate: Date().addingTimeInterval(86400 * 10),
            location: "Alche, Berlin Mitte",
            capacity: 20, rsvpCount: 8, imageURL: nil,
            eventType: .workshop, createdAt: Date()
        ),
        Event(
            id: UUID(),
            title: "Community Morning: Breathwork + Glow Smoothies",
            description: "Start your Saturday with 30 minutes of guided breathwork, followed by complimentary Glow smoothies for all attendees. Open to members and guests.",
            eventDate: Date().addingTimeInterval(86400 * 5),
            location: "Alche, Berlin Mitte",
            capacity: 40, rsvpCount: 15, imageURL: nil,
            eventType: .community, createdAt: Date()
        ),
    ]
}
