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
           ContentView()
                .environmentObject(locationViewModel)
                .environmentObject(userDefaultsManager)
                .environmentObject(navigationController)
                .environmentObject(timeViewModel)
        }
    }
}
