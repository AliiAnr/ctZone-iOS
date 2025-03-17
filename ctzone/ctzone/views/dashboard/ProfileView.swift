import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @State private var isSheetPresented = false
    
    var body: some View {
        
        ZStack {

            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack{
                    Text("\(userDefaultsManager.selectedCountry?.name ?? "No Country Selected")")
                        .font(.system(size: 26, weight: .light))
                    Spacer()
                    Image("Flag_of_Argentina")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .sheet(isPresented: $isSheetPresented) {
                CountrySelectionSheet(isPresented: $isSheetPresented, viewModel: viewModel)
            }
        }
    }
}

struct CountrySelectionSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        NavigationStack {
            VStack {
                // **Search Bar**
                SearchBarView(searchText:$viewModel.searchText)
                
                // **List Negara dengan LazyVStack**
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.filteredCountries) { country in
                            
                            
                            Button(action: {
                                userDefaultsManager.setSelectedCountry(country)
                                isPresented.toggle()
                            }) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(country.name)
                                                .font(.headline)
                                                .foregroundColor(userDefaultsManager.selectedCountry?.name == country.name ? .blue : .primary)
                                            Text("Time: \(country.currentTime)")
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




//struct ProfileView: View {
//    @EnvironmentObject var navigationController: NavigationViewModel
//
//    var body: some View {
//        VStack {
//            Text("Profile Screen")
//                .font(.largeTitle)
//
//            Button("Edit Profile") {
//                navigationController.push(.editProfile)
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .navigationTitle("Profile")
//    }
//}


struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack {
            Text("Detail for \(product.name)")
                .font(.largeTitle)
        }
        .navigationTitle(product.name)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct CartView: View {
    var body: some View {
        VStack {
            Text("This is Cart View")
                .font(.largeTitle)
        }
        .navigationTitle("Cart")
        .toolbar(.hidden, for: .tabBar)
    }
}


struct DetelView: View {
    
    @EnvironmentObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            Text("This is Cart View")
                .font(.largeTitle)
            Button("Edit Profile") {
                viewModel.push(.curut)
            }
        }
        .navigationTitle("Cart")
        .toolbar(.hidden, for: .tabBar)
    }
}

struct CuruttView: View {
    var body: some View {
        VStack {
            Text("This is Cart View")
                .font(.largeTitle)
        }
        .navigationTitle("Cart")
        .toolbar(.hidden, for: .tabBar)
    }
}
