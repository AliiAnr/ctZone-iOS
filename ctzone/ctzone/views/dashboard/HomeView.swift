import SwiftUI

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var navigationController: NavigationViewModel
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    // Misalnya, pinnedLocations diambil dari LocationViewModel
    var pinnedLocations: [Location] {
        locationViewModel.locations.filter { $0.isPinned }
    }
    
    // Jika nanti ada ReminderViewModel, ganti dengan data aslinya.
    // Untuk sementara, saya asumsikan ReminderSection masih menggunakan data dummy,
    // sehingga saya tetapkan reminderCount = 0 untuk menandakan tidak ada data.
    var reminderCount: Int {
        // Ubah sesuai implementasi ReminderSection / ReminderViewModel
        return 0
    }
    
    // Computed property untuk menentukan apakah harus menampilkan EmptyValue
    var shouldShowEmptyState: Bool {
        pinnedLocations.isEmpty && reminderCount == 0
    }
    
    var body: some View {
        VStack {
            Text("KOAWKOWAOW")
                .padding(.vertical)
            
            TopSectione(
                location: userDefaultsManager.selectedCountry ?? Location(name: "Jakarta", country: "Indonesia", image: "", timezoneIdentifier: "Asia/Jakarta", utcInformation: "Dummy", isCity: true, isPinned: false),
                date: userDefaultsManager.selectedDate,
                isPinned: $userDefaultsManager.use24HourFormat
            )
            .id("top")
            .padding(.horizontal)
            
            devedere()

            
            Spacer()
            
            if shouldShowEmptyState {
//                 Tampilkan empty state di tengah layar
                EmptyValue()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                Text("Empty State")
                
                
            } else {
                ScrollView {
                    ZStack {
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea()
                        
                        VStack {
                            PinnedSection(is24HourFormat: $userDefaultsManager.use24HourFormat)
//                            ReminderSection()
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
            }
            
            Spacer()
        }
    }
}


struct EmptyValue : View {
    var body : some View {
        VStack{
            Image(systemName: "clock")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("emptyColor"))
                .opacity(0.5)
                .frame(width: 170, height: 170)
            Text("Go pin a location and they will show up here")
                .font(.system(size: 20, weight: .light))
                .opacity(0.5)
                .padding(.top, 10)
                .foregroundColor(Color("text/body"))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
    }
}

struct devedere: View {
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 2)
            .padding(.horizontal)
            .overlay(
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(height: 1)
                    .padding(.top, 9)
                    .padding(.horizontal),
                alignment: .top
            )
    }
}

private struct TopSectione: View {
    @Environment(\.colorScheme) var colorScheme
    let location: Location
    let date: String
    @Binding var isPinned: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(location.name), \(location.utcInformation ?? "UTC+0")")
                    .font(.headline)
                //.foregroundStyle(Color("test"))
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                isPinned.toggle()
            }) {
                Image(systemName: isPinned ? "24.circle.fill" : "24.circle")
                    .foregroundColor(isPinned ? Color(.blue): .blue)
                //.foregroundColor(colorScheme == .dark ? Color.yellow : Color.blue)
                    .font(.system(size: 28))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        
    }
}

private struct PinnedSection: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
//    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @Binding var is24HourFormat: Bool
    
    // Definisikan nilai dasar dan padding
    let baseRowHeight: CGFloat = 60
    let verticalPadding: CGFloat = 10 // 5 atas + 5 bawah
    
    
    var pinnedLocations: [Location] {
        locationViewModel.locations.filter { $0.isPinned }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Pinned")
                .font(.system(size: 24))
                .bold()
                .padding(.vertical)
            
            List {
                ForEach(pinnedLocations, id: \.id) { location in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            
                            // Misalnya menampilkan UTC atau informasi lain jika ada
                            Text(location.utcInformation ?? "No UTC")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        let timeInfo = location.currentTimeFormat(is24HourFormat: is24HourFormat)
                        // Menampilkan currentTime yang didefinisikan di struct Location
                        
                        HStack (spacing: 2) {
                            Text(timeInfo.hourMinute)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let amPm = timeInfo.amPm {
                                Text("\(amPm)")
                                    .font(.system(size: 12, weight: .light))  // Styling untuk AM/PM
                                    .foregroundColor(.blue)  // Warna AM/PM
                            }

                        }
                        
                    }
                    .frame(minHeight: baseRowHeight)
                    .padding(.vertical, verticalPadding / 2)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .swipeActions {
                        Button(role: .destructive) {
                            // Panggil fungsi updatePinStatus pada ViewModel untuk unpin
                            locationViewModel.updatePinStatus(location: location, pinned: false)
                        } label: {
                            Label("Unpin", systemImage: "pin.slash")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            // Perhitungan tinggi: jumlah item * (baseRowHeight + verticalPadding)
            .frame(height: CGFloat(pinnedLocations.count) * (baseRowHeight + verticalPadding))
            .scrollDisabled(true)
        }
    }
}




private struct ReminderSection: View {
    @State var reminderTime = ["15:00","13:12"]
    var body: some View {
        HStack{
            Text("Reminder").font(.system(size: 24)).bold()
            Spacer()
        }.frame(maxWidth: .infinity)
        
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(reminderTime, id: \.self){ item in
                VStack {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(item)
                                .font(.largeTitle)
                            Text("Jakarta")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("UTC+3")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(item)
                                .font(.largeTitle)
                            Text("Argentina")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("UTC+3")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                    }.padding(.top, 10)
                        .padding(.horizontal, 16)
                    
                    
                    Divider().padding(.horizontal, 16)
                    
                    HStack{
                        //Image(systemName: "note.text")
                        Text("Pergi ke pasar Argentina").foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "trash").foregroundColor(.red)
                    }.padding(.horizontal, 16)
                        .padding(.bottom, 10)
                    
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
        }
    }
}

private struct pinnedList: View {
    
    let location: String
    let utcInformation: String
    let time: String
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(location)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("UTC+3")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("15:00")
                .font(.system(size: 44, weight: .light))
        }
        
    }
    
}


