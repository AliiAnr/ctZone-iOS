//
//  OnBoarding1View.swift
//  ctzone
//
//  Created by steven on 22/03/25.
//

import SwiftUI

struct OnBoarding1View: View {
    @Binding var showOnboarding: Bool
    @State private var isSheetPresented = false
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var navigationController: NavigationViewModel
    
    var body: some View {
        VStack{
            Image("onBoardHeader")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .foregroundColor(.red)
            
            Text("Choose Your Location")
                .bold()
                .font(.system(size: 24))
                .padding(.vertical)
            Button(action: {
                isSheetPresented.toggle()
            }) {
                VStack(spacing: 20) {
                    HStack{
                        Text("\(userDefaultsManager.selectedCountry?.name ?? "Select Location")")
                            .font(.system(size: 26, weight: .light))
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        if (userDefaultsManager.selectedCountry?.image ?? "") != "" {
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
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 50)
                }.padding(.horizontal, 20)
                    
                   
                    }
            }
        .sheet(isPresented: $isSheetPresented) {
                CountrySelectionSheets(isPresented: $isSheetPresented)

            
        }
        Button(action: {
            if userDefaultsManager.selectedCountry != nil {
                                withAnimation {
                                    showOnboarding = false
                                }
                            }
        }
        ) {
            Text("Get Started")

                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor((userDefaultsManager.selectedCountry?.name ?? "Select Location") == "Select Location" ? .gray : .white)
                .background((userDefaultsManager.selectedCountry?.name ?? "Select Location") == "Select Location" ? Color(UIColor.systemGray6) : Color("primeColor"))
                .cornerRadius(10)
                
            
        }
        .disabled(userDefaultsManager.selectedCountry == nil)
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

struct CountrySelectionSheets: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var navigationController: NavigationViewModel
    
    @State private var is24HourFormat: Bool = false

    
    var body: some View {
        NavigationStack {
            VStack {

                SearchBarView(searchText:$locationViewModel.searchProfileText)
                
                ScrollView {
                    LazyVStack {
                        ForEach(locationViewModel.filteredProfileCountries) { location in
                            
                            
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
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(UIColor.label))
                                               
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
