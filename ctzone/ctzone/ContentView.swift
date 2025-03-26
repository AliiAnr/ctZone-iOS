import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject var navigationController: NavigationViewModel
    @State private var selectedTab = 0
    @State private var showOnboarding: Bool = false
    
    
    
    //
    //    init() {
    //        userDefaultsManager.setSelectedCountry(        Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true))
    //    }
    
    
    
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            TabView(selection: $selectedTab){
                HomeView()
                    .tag(0)
                    .environmentObject(locationViewModel)    .environmentObject(navigationController)
                    .environmentObject(userDefaultsManager)
                    .environmentObject(timeViewModel)
                    .tabItem {
                        Label("Home", systemImage: "app.badge.clock.fill")
                    }
                SearchView()
                    .tag(1)
                    .environmentObject(locationViewModel)
                    .environmentObject(navigationController)
                    .environmentObject(userDefaultsManager)
                    .environmentObject(timeViewModel)
                    .tabItem {
                        Label("Search", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                ProfileView()
                    .tag(2)
                    .environmentObject(locationViewModel)
                    .environmentObject(navigationController)
                    .environmentObject(userDefaultsManager)
                    .environmentObject(timeViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .onAppear {
                // Jika belum ada selectedCountry, tampilkan onboarding
                if userDefaultsManager.selectedCountry == nil {
                    showOnboarding = true
                }
            }
            .fullScreenCover(isPresented: $showOnboarding) {
                // Onboarding ditampilkan sebagai fullScreenCover
                OnBoarding1View(showOnboarding: $showOnboarding)
                    .environmentObject(userDefaultsManager)
                    .environmentObject(Injection.shared.locationViewModel)
                    .environmentObject(TimeViewModel())
                    .environmentObject(NavigationViewModel())
            }
            .onAppear {
                UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
            }
            .accentColor(Color("primeColor"))
            //            .navigationTitle(getTitle(for: selectedTab))
            //            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Destination.self) { destination in
                destination.destinationView.environmentObject(navigationController)
            }
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

