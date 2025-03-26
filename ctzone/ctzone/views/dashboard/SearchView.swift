//
//  SearchView.swift
//  ctzone
//
//  Created by Ali An Nuur on 16/03/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var navigationController: NavigationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    @State private var is24HourFormat = false
    
    var body: some View {
        VStack {
            Text("Search")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            
            SearchBarView(searchText: $locationViewModel.searchText).padding(.top, -15)
            
            ScrollView {
                
                
                
                LazyVStack(alignment: .leading) {
                    ForEach(locationViewModel.filteredCountries) { location in
                        
                        Button(action: {
                            print("Country selected: \(location.name)")
                            navigationController.push(.searchDetail(location.id))
                            
                        }) {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading, spacing : 2) {
                                        Text(location.name)
                                            .font(.headline)
                                            .fontWeight(.medium)
                                            .foregroundColor(Color(UIColor.label))
                                        
                                        let timeInfo = location.currentTimeFormat(is24HourFormat: is24HourFormat)
                                        
                                        HStack(spacing: 2) {
                                            Text(timeInfo.hourMinute)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            
                                            if let amPm = timeInfo.amPm {
                                                Text("\(amPm)")
                                                    .font(.caption)
                                                    .fontWeight(.light)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                        }
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Spacer()
                                    
                                    Image(location.image)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 35, height: 35)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.black.opacity(0.2))
                                                .blur(radius: 2)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                
                                Divider()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                }
                .padding(.horizontal)
            }
        }
        .onAppear{
            is24HourFormat = userDefaultsManager.use24HourFormat
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 4)
        
    }
}

//#Preview {
//    SearchView()
//}
