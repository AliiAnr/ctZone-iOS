import SwiftUI

struct TimePickerView: View {
    @ObservedObject var viewModel : TimePickerViewModel
    @EnvironmentObject var userDefaultsManager : UserDefaultsManager
    @State private var isPickerPresented = false
    var location : Location
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        let formattedTime = viewModel.formattedTime()
        let formattedDestinationTime = viewModel.formattedDestinationTime()
        
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Button(action: {
                        viewModel.loadTempValues()
                        isPickerPresented.toggle()
                    }) {
                        VStack(alignment: .leading){
                            HStack(alignment: .bottom, spacing: 5) {
                                Text(formattedTime.hourMinute)
                                    .font(.system(size: 44, weight: .light))
                                    .foregroundColor(Color(UIColor.label))
                                
                        
                                if let amPm = formattedTime.amPm {
                                    Text(amPm)
                                        .font(.system(size: 20, weight: .light))                             .foregroundColor(.blue)
                                        .baselineOffset(5)
                                }
                            }
                            Text("\(viewModel.formattedDate()), +1HR")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                    
//                    Button(action: {
//                        viewModel.loadTempValues()
//                        isPickerPresented.toggle()
//                    }) {
//                        Text("\(viewModel.formattedDate()), +1HR")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(.gray)
//                    }
                }
                
                Spacer()
                Button(action: {
                    viewModel.resetToCurrentTime(currentTime: userDefaultsManager.selectedCountry ?? Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true), destinationTime: location)
                }) {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                VStack(alignment: .trailing){
//                    Button(action: {
//                        viewModel.loadTempValues()
//                        isPickerPresented.toggle()
//                    }) {
                    HStack(alignment: .bottom, spacing: 5) {
                        // **Teks Waktu Utama (Jam & Menit)**
                        Text(formattedDestinationTime.hourMinute)
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(Color(UIColor.label))
                        
                        // **Teks AM/PM Jika Menggunakan Format 12 Jam**
                        if let amPm = formattedDestinationTime.amPm {
                            Text(amPm)
                                .font(.system(size: 20, weight: .light))                                .foregroundColor(.blue)
                                .baselineOffset(5)
                        }
                    }
                        
//                    }
                    
                    
                    // **Teks tanggal yang bisa diklik**
//                    Button(action: {
//                        viewModel.loadTempValues()
//                        isPickerPresented.toggle()
//                    }) {
                    Text("\(viewModel.formattedDestinationDate()), +1HR")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        
//                    }
                }
                
            }
            
            // **Toggle untuk mengubah format 12/24 jam**
//            Toggle("Gunakan Format 24 Jam", isOn: $viewModel.use24HourFormat)
            
        }
        .onAppear {
            viewModel.updateTimeBasedOnLocation(userDefaultsManager.selectedCountry ?? Location(name: "Denpasar", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true))
            
            viewModel.getDestinationCountryTime(location)
        }
        .sheet(isPresented: $isPickerPresented) {
            VStack {
                Text("Pilih Waktu & Tanggal")
                    .font(.headline)
                    .padding()
                
                // **Time Picker**
                HStack {
                    Picker(selection: $viewModel.tempHour, label: Text("Hour")) {
                        ForEach(viewModel.use24HourFormat ? Array(0..<24) : Array(1...12), id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .frame(width: 80, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: viewModel.tempHour) { _, _ in
                        viewModel.validateDateTime()
                    }
                    
                    Text(":").font(.title)
                    
                    Picker(selection: $viewModel.tempMinute, label: Text("Minute")) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .frame(width: 80, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: viewModel.tempMinute) { _, _ in
                        viewModel.validateDateTime()
                    }
                    
                    if !viewModel.use24HourFormat {
                        Picker(selection: $viewModel.tempIsAM, label: Text("AM/PM")) {
                            Text("AM").tag(true)
                            Text("PM").tag(false)
                        }
                        .frame(width: 80, height: 150)
                        .clipped()
                        .pickerStyle(.wheel)
                        .onChange(of: viewModel.tempIsAM) { _, _ in
                            viewModel.validateDateTime()
                        }
                    }
                }
                .padding()
                
                Divider()
                
                // **Date Picker**
                HStack {
                    Picker(selection: $viewModel.tempDay, label: Text("Day")) {
                        ForEach(1...viewModel.daysInMonth(month: viewModel.tempMonth, year: viewModel.tempYear), id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .frame(width: 80, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: viewModel.tempDay) { _, _ in
                        viewModel.validateDateTime()
                    }
                    
                    Picker(selection: $viewModel.tempMonth, label: Text("Month")) {
                        ForEach(1...12, id: \.self) { month in
                            Text("\(month)").tag(month)
                        }
                    }
                    .frame(width: 100, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: viewModel.tempMonth) { _, _ in
                        viewModel.validateDay()
                        viewModel.validateDateTime()
                    }
                    
                    Picker(selection: $viewModel.tempYear, label: Text("Year")) {
                        ForEach(2020...2030, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .frame(width: 100, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: viewModel.tempYear) { _, _ in
                        viewModel.validateDay()
                        viewModel.validateDateTime()
                    }
                }
                .padding()
                
                Button(action: {
//                    viewModel.saveTime()
                    viewModel.saveDestinationTime(userDefaultsManager.selectedCountry ?? Location(name: "Denpasar", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true), location)
                    isPickerPresented = false
                    
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                
                // **Tombol Batal**
                Button("Batal") {
                    isPickerPresented = false
                }
                .foregroundColor(.red)
                .padding()
            }
            .presentationDetents([.height(600)]) // Ukuran modal tetap nyaman dilihat
        }
    }
}
