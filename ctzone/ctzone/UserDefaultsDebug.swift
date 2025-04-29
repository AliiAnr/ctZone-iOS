//
//  UserDefaultsDebug.swift
//  ctzone
//
//  Created by Ali An Nuur on 26/03/25.
//

import SwiftUI

struct UserDefaultsDetailView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("User Defaults")
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Text("24 Hour Format:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(userDefaultsManager.use24HourFormat ? "Enabled" : "Disabled")
                    }
                    
                    HStack {
                        Text("Selected Country:")
                            .fontWeight(.semibold)
                        Spacer()
                        if let country = userDefaultsManager.selectedCountry {
                            Text(country.name)
                        } else {
                            Text("None")
                        }
                    }
                    
                    HStack {
                        Text("Selected Date:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(userDefaultsManager.selectedDate)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    userDefaultsManager.resetUserDefaults()
                }) {
                    HStack {
                        Spacer()
                        Text("Delete All Data")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .navigationTitle("User Defaults Detail")
        }
    }
}

#Preview {
    UserDefaultsDetailView()
        .environmentObject(UserDefaultsManager.shared)
        
}
