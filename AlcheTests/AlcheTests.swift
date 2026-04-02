import XCTest
@testable import Alche

@MainActor
final class AlcheTests: XCTestCase {
    func testAppStateInitialValues() {
        let state = AppState()
        XCTAssertFalse(state.isAuthenticated)
        XCTAssertFalse(state.hasCompletedOnboarding)
        XCTAssertEqual(state.selectedTab, .home)
    }

    func testAppStateTabProperties() {
        XCTAssertEqual(AppState.Tab.home.title, "Home")
        XCTAssertEqual(AppState.Tab.book.title, "Book")
        XCTAssertEqual(AppState.Tab.shop.title, "Shop")
        XCTAssertEqual(AppState.Tab.discover.title, "Discover")
        XCTAssertEqual(AppState.Tab.profile.title, "Profile")
    }
}
