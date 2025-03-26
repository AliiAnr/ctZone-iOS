import SwiftUI

struct SearchDetailView: View {
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @EnvironmentObject var controller : NavigationViewModel
    @StateObject private var timePickerViewModel = TimePickerViewModel()
    @State private var isPinned: Bool = false
    @FocusState var isFocused: Bool
    @State private var isSheetPresented = false
    @EnvironmentObject var locationViewModel: LocationViewModel
    //     let location: Location
    let locationId: UUID
    
    // Computed property untuk mendapatkan lokasi terbaru
    var location: Location? {
        locationViewModel.location(with: locationId)
    }
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        ScrollView{
            ZStack {
                // **Background utama yang memenuhi seluruh layar**
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack() {
                    // **Top Section**
                    TopSectionView(location: location ?? Location(name: "Argentina", country: "Argentina", image: "argentina_image", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: false))
                    
                    
                    // **Mid Section**
                    MidSectionView(timePickerViewModel: timePickerViewModel, location : location ?? Location(name: "Argentina", country: "Argentina", image: "argentina_image", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: false))
                    
                    Button(action: {
                        print("Save button tapped")
                        isSheetPresented.toggle()
                        //                        controller.push(.test)
                    }) {
                        Text("Add as Reminder")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("primeColor"))
                        .cornerRadius(10)                    }
                    .padding(.top, 50)
                    .buttonStyle(.plain)
                    
                    // **Bottom Section**
                    //                    BottomSectionView(isFocused: $isFocused)
                    
                    //                    Spacer() // **Mendorong VStack ke atas**
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            }
        }
        .onAppear{
            timePickerViewModel.use24HourFormat = userDefaultsManager.use24HourFormat
            
            //            print(viewModel.formattedTime())
            //            print(viewModel.formattedDate())
            //
            //            print(viewModel.formattedDestinationDate())
            //            print(viewModel.formattedDestinationTime())
        }
        .sheet(isPresented: $isSheetPresented) {
            DescriptionSheet(isPresented: $isSheetPresented, timePickerViewModel: timePickerViewModel, location: location ?? Location(name: "Argentina", country: "Argentina", image: "argentina_image", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: false))
                .presentationDetents([.medium])
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false // Menghapus fokus saat mengetuk di luar
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()  // Kembali ke tampilan sebelumnya
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("Search") // Ganti sesuai kebutuhan
                    }
                }
                .foregroundColor(Color("primeColor")) // Ubah warna teks & ikon di sini
            }
            
            ToolbarItem() {
                Button(action: {
                    timePickerViewModel.resetToCurrentTime(
                        currentTime: userDefaultsManager.selectedCountry ?? Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true),
                        destinationTime: location ?? Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true)
                    )
                }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let loc = location {
                        locationViewModel.updatePinStatus(location: loc, pinned: !loc.isPinned)
                    }
                }) {
                    Image(systemName: (location?.isPinned ?? false) ? "pin.fill" : "pin")
                        .foregroundColor((location?.isPinned ?? false) ? .yellow : .primary)
                }                }
        }
    }
}


struct Test : View {
    
    @EnvironmentObject var controller : NavigationViewModel
    
    var body: some View {
        Button("Push") {
            controller.popToRoot()
        }
        
    }
}


private struct TopSectionView: View {
    var location: Location
    
    var body: some View {
        VStack {
            // **Gambar dengan Aspect Ratio yang Dinamis**
            Image(location.image)
                .resizable()
                .scaledToFit()  // Menjaga gambar sesuai dengan ukuran
                .aspectRatio(contentMode: .fill)  // Menjaga proporsi gambar sesuai dengan frame
                .frame(maxWidth: 150, minHeight: 100)  // Menentukan batasan ukuran
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.2))
                        .blur(radius: 2)
                )
            
            Text(location.name)
                .font(.title)
                .fontDesign(.default)
                .foregroundColor(Color(UIColor.label))
                .padding(.top, 10)
        }
        .padding(.top, 20)
    }
}


private struct MidSectionView: View {
    @ObservedObject var timePickerViewModel: TimePickerViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    let location: Location
    
    var body: some View {
        VStack {
            HStack {
                TimePickerView(timePickerViewModel: timePickerViewModel, location: location)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
    }
}

// **Bottom Section**
private struct BottomSectionView: View {
    var isFocused: FocusState<Bool>.Binding
    var body: some View {
        VStack {
            DescriptionInputView(isFocused: isFocused)
            Button(action: {
                print("Save button tapped")
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("primeColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 30)
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct DescriptionInputView: View {
    @State private var description: String = "" // Tidak perlu default placeholder
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description (optional)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
            
            ZStack(alignment: .topLeading) {
                // **Placeholder (Hanya muncul saat teks kosong)**
                
                TextEditor(text: $description)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .focused(isFocused)
                
                if description.isEmpty {
                    Text("Type Here...")
                        .foregroundColor(Color.primary.opacity(0.25))
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 0, trailing: 0))
                        .padding(5)
                }
                
            }
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                UITextView.appearance().tintColor = UIColor.black
            }
            .onDisappear {
                UITextView.appearance().backgroundColor = nil
            }
        }
    }
}

struct DescriptionSheet: View {
    @Binding var isPresented: Bool
    @FocusState var isFocused: Bool
    @ObservedObject var timePickerViewModel: TimePickerViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var description: String = ""
    var location : Location
    //    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Description (optional)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                    .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    // 1) Background & Border
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.separator), lineWidth: 1)
                        )
                    
                    // 2) TextEditor di atas background
                    TextEditor(text: $description)
                        .padding(8)                  // pastikan padding di sini
                        .focused($isFocused)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .accentColor(Color("primeColor"))
                        .foregroundColor(Color(UIColor.label))      // ganti warna teks
                    
                    // 3) Placeholder
                    if description.isEmpty {
                        Text("Type Here...")
                            .foregroundColor(.primary.opacity(0.25))
                            .padding(.leading, 13)
                            .padding(.top, 16)// samakan padding dengan TextEditor
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: 120)
                .padding(.horizontal)
                Spacer()
                
                Button(action: {
                    print("Save button tapped")
                    locationViewModel.addReminder(
                        Reminder (
                            id : UUID(),
                            
                            currentHour: timePickerViewModel.selectedHour,
                            currentMinute: timePickerViewModel.selectedMinute,
                            currentDay: timePickerViewModel.selectedDay,
                            currentMonth: timePickerViewModel.selectedMonth,
                            currentYear: timePickerViewModel.selectedYear,
                            
                            destinationHour: timePickerViewModel.destinationHour,
                            destinationMinute: timePickerViewModel.destinationMinute,
                            destinationDay: timePickerViewModel.destinationDay,
                            destinationMonth: timePickerViewModel.destinationMonth,
                            destinationYear: timePickerViewModel.destinationYear,
                            
                            timestamp: Date(),
                            
                            desc: description,
                            
                            currentName: userDefaultsManager.selectedCountry?.name,
                            currentImage: userDefaultsManager.selectedCountry?.image,
                            currentCountry: userDefaultsManager.selectedCountry?.country,
                            currentTimezone: userDefaultsManager.selectedCountry?.timezoneIdentifier,
                            currentUtc: userDefaultsManager.selectedCountry?.utcInformation,
                            
                            destinationName: location.name,
                            destinationImage: location.image,
                            destinationCountry: location.country,
                            destinationTimezone: location.timezoneIdentifier,
                            destinationUtc: location.utcInformation
                        )
                        
                        
                        
                    )
                    isPresented.toggle()
                    
                }) {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("primeColor"))
                        .cornerRadius(10)
                    .padding(.horizontal)                }
                .buttonStyle(.plain)
                
                Button("Cancel") {
                    isPresented.toggle()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.red)
                .padding(.horizontal)
                .padding(.top, 30)
                
                Spacer()
                
            }
        }
    }
}


//#Preview {
//    SearchDetailView()
//}
