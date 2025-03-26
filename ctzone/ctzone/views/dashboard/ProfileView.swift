import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var timeViewModel: TimeViewModel
    @State private var isSheetPresented = false
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    @State private var is24HourFormat: Bool = false
    
    var body: some View {
        VStack{
            
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            
            ZStack {
                
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack{
                        Text("\(userDefaultsManager.selectedCountry?.name ?? "No Country Selected")")
                            .font(.system(size: 26, weight: .light))
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Image(userDefaultsManager.selectedCountry?.image ?? "Flag_of_Indonesia")
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
                    
                    CustomButton(text: "Select Country", action: {
                        isSheetPresented.toggle()
                    })
                    
                }
                .onAppear{
                    is24HourFormat = userDefaultsManager.use24HourFormat
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                .sheet(isPresented: $isSheetPresented) {
                    CountrySelectionSheet(isPresented: $isSheetPresented, is24HourFormat: $is24HourFormat)
                }
            }
            .padding(.top,-6)
        }
    }
}

struct CountrySelectionSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var timeViewModel: TimeViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    @Binding var is24HourFormat: Bool
   
    
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(searchText:$locationViewModel.searchProfileText)
                
                ScrollView {
                    LazyVStack {
                        ForEach(locationViewModel.filteredProfileCountries) { location in
                            
                            
                            Button(action: {
                                userDefaultsManager.setSelectedCountry(location)
                                isPresented.toggle()
                            }) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
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
