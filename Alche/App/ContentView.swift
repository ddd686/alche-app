import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tag(AppState.Tab.home)
            .tabItem {
                Label(AppState.Tab.home.title, systemImage: AppState.Tab.home.selectedIcon)
            }

            NavigationStack {
                BookingListView()
            }
            .tag(AppState.Tab.book)
            .tabItem {
                Label(AppState.Tab.book.title, systemImage: AppState.Tab.book.selectedIcon)
            }

            NavigationStack {
                ShopView()
            }
            .tag(AppState.Tab.shop)
            .tabItem {
                Label(AppState.Tab.shop.title, systemImage: AppState.Tab.shop.selectedIcon)
            }

            NavigationStack {
                DiscoverView()
            }
            .tag(AppState.Tab.discover)
            .tabItem {
                Label(AppState.Tab.discover.title, systemImage: AppState.Tab.discover.selectedIcon)
            }

            NavigationStack {
                ProfileView()
            }
            .tag(AppState.Tab.profile)
            .tabItem {
                Label(AppState.Tab.profile.title, systemImage: AppState.Tab.profile.selectedIcon)
            }
        }
        .tint(Color.alchePrimary)
        .onAppear {
            // UIKit appearance requires UIColor — hex values match Alche tokens:
            // 0xFFFFFF = alcheWhite, 0x8D96A6 = alcheEditorialMuted, 0x001D3D = alchePrimary
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(hex: 0xFFFFFF)
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: 0x8D96A6)
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(hex: 0x8D96A6)]
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: 0x001D3D)
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(hex: 0x001D3D)]
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

            // 0xFCFCFD = alcheLightGray, 0x0D121B = alcheEditorialBlack
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithOpaqueBackground()
            navAppearance.backgroundColor = UIColor(hex: 0xFCFCFD)
            navAppearance.titleTextAttributes = [.foregroundColor: UIColor(hex: 0x0D121B)]
            navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(hex: 0x0D121B)]
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
            UINavigationBar.appearance().compactAppearance = navAppearance
        }
    }
}

// MARK: - Placeholder Tab Content

struct PlaceholderTabView: View {
    let tab: AppState.Tab

    var body: some View {
        VStack(spacing: AlcheSpacing.lg) {
            Image(systemName: tab.selectedIcon)
                .font(.system(size: 48))
                .foregroundStyle(Color.alchePrimary)

            Text(tab.title)
                .font(.alcheDisplayL)
                .foregroundStyle(Color.alchePrimaryText)

            Text("Coming soon")
                .font(.alcheBody)
                .foregroundStyle(Color.alcheSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.alcheBackground)
        .navigationTitle(tab.title)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
