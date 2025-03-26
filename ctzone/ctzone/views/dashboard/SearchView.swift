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
    //    @StateObject private var viewModel = CountryViewModel()
    @EnvironmentObject var timeViewModel: TimeViewModel
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    @State private var is24HourFormat = false
    
    var body: some View {
        VStack {
            // **Search Bar Tetap di Atas**        VStack{
            Text("Search")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            
            SearchBarView(searchText: $locationViewModel.searchText).padding(.top, -15)
            
            // **ScrollView untuk LazyVStack**
            ScrollView {
                
                
                
                LazyVStack(alignment: .leading) {
                    ForEach(locationViewModel.filteredCountries) { location in
                        
                        Button(action: {
                            print("Country selected: \(location.name)")
                            navigationController.push(.searchDetail(location.id))
//                            navigationController.popToRoot()
                            
                            
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
                                            // Menampilkan waktu
                                            Text(timeInfo.hourMinute)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            
                                            // Menampilkan AM/PM jika ada
                                            if let amPm = timeInfo.amPm {
                                                Text("\(amPm)")
                                                    .font(.caption)
                                                    .fontWeight(.light)// Styling untuk AM/PM
                                                    .foregroundColor(.gray)  // Warna AM/PM
                                            }
                                            
                                            // Menampilkan informasi UTC jika ada
                                            //                                            if let utcInfo = location.utcInformation {
                                            //                                                Text(utcInfo)
                                            //                                                    .font(.system(size: 10, weight: .medium))
                                            //                                                    .foregroundColor(.blue)
                                            //                                                    .baselineOffset(5) // Memindahkan sedikit ke atas
                                            //                                            }
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
                                .frame(maxWidth: .infinity) // **Pastikan HStack memenuhi lebar**
                                .contentShape(Rectangle()) // **Memastikan seluruh area bisa diklik**
                                
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
            Image(systemName: "magnifyingglass") // **Ikon di kiri**
                .foregroundColor(.gray)
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = "" // **Hapus teks saat tombol ditekan**
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
