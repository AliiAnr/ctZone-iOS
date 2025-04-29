import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject var navigationController: NavigationViewModel
    
    @State private var selectedTab = 0
    @State private var showOnboarding: Bool = false

    var body: some View {
        NavigationStack(path: $navigationController.path) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .environmentObject(locationViewModel)
                    .environmentObject(navigationController)
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
 
                if userDefaultsManager.selectedCountry == nil {
            
                    withAnimation(.none) {
                        showOnboarding = true
                    }
                }
            }
   
            .fullScreenCover(isPresented: $showOnboarding) {
                OnBoarding1View(showOnboarding: $showOnboarding)
                    .environmentObject(userDefaultsManager)
                    .environmentObject(locationViewModel)
                    .environmentObject(timeViewModel)
                    .environmentObject(navigationController)
            }
            .onAppear {
                UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
            }
            .accentColor(Color("primeColor"))
            .navigationDestination(for: Destination.self) { destination in
                destination.destinationView
                    .environmentObject(navigationController)
            }
        }
    }
}
