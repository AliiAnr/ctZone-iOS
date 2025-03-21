import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @StateObject private var navigationController = NavigationViewModel()
    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
//    
//    init() {
//        userDefaultsManager.setSelectedCountry(        Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true))
//    }

    var body: some View {
        NavigationStack(path: $navigationController.path) {
            TabView(selection: $selectedTab){
                HomeView()
                    .tag(0)
                    .environmentObject(navigationController)
                    .environmentObject(userDefaultsManager)
                    .tabItem {
                        Label("Home", systemImage: "app.badge.clock.fill")
                    }
                SearchView()
                    .tag(1)
                    .environmentObject(navigationController)
                    .environmentObject(userDefaultsManager)
                    .tabItem {
                        Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                ProfileView()
                    .tag(2)
                    .environmentObject(navigationController)
                    .environmentObject(userDefaultsManager)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
//            .navigationTitle(getTitle(for: selectedTab))
//            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Destination.self) { destination in
                destination.destinationView.environmentObject(navigationController)
            }
        }

        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray// **Warna icon tidak aktif**
        }
    }
    
    private func getTitle(for tab: Int) -> String {
            switch tab {
            case 0: return "Home"
            case 1: return "Search"
            case 2: return "Profile"
            default: return "App"
            }
        }
}

#Preview {
    ContentView()
}

//ikan
