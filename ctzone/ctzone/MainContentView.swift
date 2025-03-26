//
//  App.swift
//  ctzone
//
//  Created by Ali An Nuur on 26/03/25.
//

import SwiftUI

//struct MainContentView: View {
//    @StateObject private var userDefaultsManager = UserDefaultsManager.shared
//    @StateObject private var locationViewModel = Injection.shared.locationViewModel
//    @StateObject private var timeViewModel = TimeViewModel()
//    @StateObject private var navigationController = NavigationViewModel()
//    
//    var body: some View {
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
//    }
//    
//}
//
//#Preview {
//    MainContentView()
//}
