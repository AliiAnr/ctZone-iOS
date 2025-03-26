//
//  ctzoneApp.swift
//  ctzone
//
//  Created by Ali An Nuur on 15/03/25.
//

import SwiftUI

@main
struct ctzoneApp: App {
    
    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
    @StateObject private var locationViewModel = Injection.shared.locationViewModel
    @StateObject private var timeViewModel = TimeViewModel()
    @StateObject private var navigationController = NavigationViewModel()
    
    var body: some Scene {
        WindowGroup {
//            MainContentView()
           ContentView()
                .environmentObject(locationViewModel)
                .environmentObject(userDefaultsManager)
                .environmentObject(navigationController)
                .environmentObject(timeViewModel)
        }
    }
}

//struct MainContentView: View {
//    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
//    @StateObject private var locationViewModel = Injection.shared.locationViewModel
//    @StateObject private var timeViewModel = TimeViewModel()
//    @StateObject private var navigationController = NavigationViewModel()
//    
//    var body: some View {
//        NavigationStack(path: $navigationController.path) {
//        if userDefaultsManager.hasSeenOnboarding{
//            ContentView()
//                .environmentObject(locationViewModel)
//                .environmentObject(userDefaultsManager)
//                .environmentObject(navigationController)
//                .environmentObject(timeViewModel)
//            
//        } else {
//            OnBoarding1View()
//                .environmentObject(locationViewModel)
//                .environmentObject(userDefaultsManager)
//                .environmentObject(navigationController)
//                .environmentObject(timeViewModel)
//        }
//            
//        
//    }
//    
//}
//
//#Preview {
//    MainContentView()
//}

