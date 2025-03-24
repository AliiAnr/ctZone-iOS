//
//  OnBoarding1View.swift
//  ctzone
//
//  Created by steven on 22/03/25.
//

import SwiftUI

struct OnBoarding1View: View {
    @State private var isSheetPresented = false
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        VStack{
            Image("On_Boarding_Image")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .foregroundColor(.red)
            
            Text("Choose your country")
                .bold()
                .font(.system(size: 24))
                .padding(.vertical)
            Button(action: {
                isSheetPresented.toggle()
                // Add your desired action here
            }) {
                VStack(spacing: 20) {
                    HStack{
                        Text("\(userDefaultsManager.selectedCountry?.name ?? "Select Country")")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle((userDefaultsManager.selectedCountry?.name ?? "Select Country") == "Select Country" ? .gray : .black)
                        Spacer()
                        Image(userDefaultsManager.selectedCountry?.image ?? "")
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
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 50)
                }.padding(.horizontal, 20)
                    
                   
                    }
            }.sheet(isPresented: $isSheetPresented) {
                CountrySelectionSheets(isPresented: $isSheetPresented, viewModel: viewModel)

            
        }
        Button(action: {
            //action()
        }
        ) {
            Text("Get Started")

                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor((userDefaultsManager.selectedCountry?.name ?? "Select Country") == "Select Country" ? .gray : .white)
                .background((userDefaultsManager.selectedCountry?.name ?? "Select Country") == "Select Country" ? Color(UIColor.systemGray6) : .blue)
                .cornerRadius(10)
                
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

struct CountrySelectionSheets: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    @State private var is24HourFormat: Bool = false

    
    var body: some View {
        NavigationStack {
            VStack {
                // **Search Bar**
                SearchBarView(searchText:$viewModel.searchText)
                
//                 **List Negara dengan LazyVStack**
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.filteredCountries) { location in
                            
                            
                            Button(action: {
                                userDefaultsManager.setSelectedCountry(location)
                                print("ini adalah print dari button \(location)")
                                isPresented.toggle()
                            }) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(location.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                               
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    OnBoarding1View()
        .environmentObject(UserDefaultsManager.shared)
}

