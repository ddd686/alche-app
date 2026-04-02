import SwiftUI

@Observable
@MainActor
final class AppState {
    var isAuthenticated = false
    var hasCompletedOnboarding = false
    var selectedTab: Tab = .home
    var userWellnessProfile = UserWellnessProfile()

    // Onboarding flow state
    enum OnboardingStep: Int, CaseIterable, Sendable {
        case brandMoment = 0
        case quickScan = 1
        case focusAreaReveal = 2
        case glowScanInvitation = 3
        case personalizedHome = 4
    }

    var onboardingStep: OnboardingStep = .brandMoment

    enum Tab: Int, CaseIterable, Sendable {
        case home, book, shop, discover, profile

        var title: String {
            switch self {
            case .home: "Home"
            case .book: "Book"
            case .shop: "Shop"
            case .discover: "Discover"
            case .profile: "Profile"
            }
        }

        var icon: String {
            switch self {
            case .home: "house"
            case .book: "calendar"
            case .shop: "bag"
            case .discover: "compass"
            case .profile: "person"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home: "house.fill"
            case .book: "calendar"
            case .shop: "bag.fill"
            case .discover: "compass.fill"
            case .profile: "person.fill"
            }
        }
    }
}
