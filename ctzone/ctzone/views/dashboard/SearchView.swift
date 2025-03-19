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
    @StateObject private var viewModel = CountryViewModel()
    
    var body: some View {
        VStack {
                  // **Search Bar Tetap di Atas**
                  SearchBarView(searchText: $viewModel.searchText)
                  
                  // **ScrollView untuk LazyVStack**
                  ScrollView {
                      LazyVStack(alignment: .leading) {
                          ForEach(viewModel.filteredCountries) { location in
                              
                              Button(action: {
                                  print("Country selected: \(location.name)")
                                  navigationController.push(.searchDetail(location))
                                      
                              }) {
                                  VStack {
                                      HStack {
                                          VStack(alignment: .leading) {
                                              Text(location.name)
                                                  .font(.headline)
                                                  .foregroundColor(.black)
                                              Text("Time: \(location.currentTime)")
                                                  .font(.subheadline)
                                                  .foregroundColor(.gray)
                                          }
                                          .padding(.vertical, 5)
                                          
                                          Spacer()
                                          
                                          Image("Flag_of_Argentina")
                                              .resizable()
                                              .scaledToFit()
                                              .frame(width: 35, height: 35)
                                              .clipShape(RoundedRectangle(cornerRadius: 10))
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

#Preview {
    SearchView()
}
