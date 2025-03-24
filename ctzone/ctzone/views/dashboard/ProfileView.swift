import SwiftUI

struct ProfileView: View {
//    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @State private var isSheetPresented = false
    
//    @StateObject private var locationViewModel = Injection.shared.locationViewModel
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    @State private var is24HourFormat: Bool = false
    
    var body: some View {
        VStack{
            
            Text("KOAWKOWAOW")
                .padding(.vertical)
            ZStack {
                
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack{
                        Text("\(userDefaultsManager.selectedCountry?.name ?? "No Country Selected")")
                            .font(.system(size: 26, weight: .light))
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
                    //                if let country = userDefaultsManager.selectedCountry {
                    //                    Text("Selected Country: \(country.name)")
                    //                        .font(.title2)
                    //                        .padding()
                    //                } else {
                    //                    Text("No Country Selected")
                    //                        .foregroundColor(.gray)
                    //                        .font(.title2)
                    //                }
                    
                    CustomButton(text: "Select Country", action: {
                        isSheetPresented.toggle()
                    })
                    
                    //                if userDefaultsManager.selectedCountry != nil {
                    //                    Button("Clear Selection") {
                    //                        userDefaultsManager.clearSelectedCountry()
                    //                    }
                    //                    .buttonStyle(.bordered)
                    //                    .padding()
                    //                }
                }
                .onAppear{
                    is24HourFormat = userDefaultsManager.use24HourFormat
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
                .sheet(isPresented: $isSheetPresented) {
                    CountrySelectionSheet(isPresented: $isSheetPresented, locationViewModel: locationViewModel, is24HourFormat: $is24HourFormat)
                }
            }
        }
    }
}

struct CountrySelectionSheet: View {
    @Binding var isPresented: Bool
//    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var locationViewModel: LocationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    @Binding var is24HourFormat: Bool
   
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // **Search Bar**
                SearchBarView(searchText:$locationViewModel.searchText)
                
                //                 **List Negara dengan LazyVStack**
                ScrollView {
                    LazyVStack {
                        ForEach(locationViewModel.filteredCountries) { location in
                            
                            
                            Button(action: {
                                userDefaultsManager.setSelectedCountry(location)
                                isPresented.toggle()
                            }) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(location.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            let timeInfo = location.currentTimeFormat(is24HourFormat: is24HourFormat)
                                            
                                            HStack(spacing: 2) {
                                                // Menampilkan waktu
                                                Text(timeInfo.hourMinute)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                
                                                // Menampilkan AM/PM jika ada
                                                if let amPm = timeInfo.amPm {
                                                    Text("\(amPm)")
                                                        .font(.system(size: 12, weight: .light))  // Styling untuk AM/PM
                                                        .foregroundColor(.blue)  // Warna AM/PM
                                                }
                                                
                                                // Menampilkan informasi UTC jika ada
//                                                if let utcInfo = location.utcInformation {
//                                                    Text(utcInfo)
//                                                        .font(.system(size: 10, weight: .medium))
//                                                        .foregroundColor(.blue)
//                                                        .baselineOffset(5) // Memindahkan sedikit ke atas
//                                                }
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
