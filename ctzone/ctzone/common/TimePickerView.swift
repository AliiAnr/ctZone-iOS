import SwiftUI

struct TimePickerView: View {
    @ObservedObject var timePickerViewModel : TimePickerViewModel
    @EnvironmentObject var userDefaultsManager : UserDefaultsManager
    @State private var isPickerPresented = false
    var location : Location
    
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        let formattedTime = timePickerViewModel.formattedTime()
        let formattedDestinationTime = timePickerViewModel.formattedDestinationTime()
        
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Button(action: {
                        timePickerViewModel.loadTempValues()
                        isPickerPresented.toggle()
                    }) {
                        VStack(alignment: .leading){
                            HStack(alignment: .bottom, spacing: 5) {
                                Text(formattedTime.hourMinute)
                                    .font(.system(size: 44, weight: .light))
                                    .dynamicTypeSize(.large ... .accessibility5)
                                    .foregroundColor(Color(UIColor.label))
                                
                        
                                if let amPm = formattedTime.amPm {
                                    Text(amPm)
                                        .font(.system(.title3, weight: .light))                             .foregroundColor(Color(UIColor.label))
                                        .baselineOffset(5)
                                }
                            }
                            Text("\(timePickerViewModel.formattedDate()), \(userDefaultsManager.selectedCountry?.utcInformation ?? "UTC+0")")
                                .font(.system(.subheadline, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(15)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                    
                }
                .frame(minWidth: 200)                
                Spacer()
                
                VStack(alignment: .trailing){

                    HStack(alignment: .bottom, spacing: 5) {

                        Text(formattedDestinationTime.hourMinute)
                            .font(.system(size: 44, weight: .light))
                            .dynamicTypeSize(.large ... .accessibility5)
                            .foregroundColor(Color(UIColor.label))
                        
                        if let amPm = formattedDestinationTime.amPm {
                            Text(amPm)
                                .font(.system(.title3, weight: .light))                                .foregroundColor(Color(UIColor.label))
                                .baselineOffset(5)
                        }
                    }
                        
                    Text("\(timePickerViewModel.formattedDestinationDate()), \(location.utcInformation ?? "UTC+0")")
                        .font(.system(.subheadline, weight: .semibold))
                            .foregroundColor(.gray)
                        
                }
                
            }
            
        }
        .onAppear {
            timePickerViewModel.updateTimeBasedOnLocation(userDefaultsManager.selectedCountry ?? Location(name: "Denpasar", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true))
            
            timePickerViewModel.getDestinationCountryTime(location)
            
            print(timePickerViewModel.formattedTime())
            print(timePickerViewModel.formattedDate())
            
            print(timePickerViewModel.formattedDestinationDate())
            print(timePickerViewModel.formattedDestinationTime())
        }
        .sheet(isPresented: $isPickerPresented) {
            VStack {
                Text("Select Date & Time")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Picker(selection: $timePickerViewModel.tempHour, label: Text("Hour")) {
                        ForEach(timePickerViewModel.use24HourFormat ? Array(0..<24) : Array(1...12), id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .frame(width: 80, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: timePickerViewModel.tempHour) { _, _ in
                        timePickerViewModel.validateDateTime()
                    }
                    
                    Text(":").font(.title)
                    
                    Picker(selection: $timePickerViewModel.tempMinute, label: Text("Minute")) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .frame(width: 80, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: timePickerViewModel.tempMinute) { _, _ in
                        timePickerViewModel.validateDateTime()
                    }
                    
                    if !timePickerViewModel.use24HourFormat {
                        Picker(selection: $timePickerViewModel.tempIsAM, label: Text("AM/PM")) {
                            Text("AM").tag(true)
                            Text("PM").tag(false)
                        }
                        .frame(width: 80, height: 150)
                        .clipped()
                        .pickerStyle(.wheel)
                        .onChange(of: timePickerViewModel.tempIsAM) { _, _ in
                            timePickerViewModel.validateDateTime()
                        }
                    }
                }
                .padding()
                
                Divider()
                
                HStack {
                    Picker(selection: $timePickerViewModel.tempDay, label: Text("Day")) {
                        ForEach(1...timePickerViewModel.daysInMonth(month: timePickerViewModel.tempMonth, year: timePickerViewModel.tempYear), id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .frame(width: 80, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: timePickerViewModel.tempDay) { _, _ in
                        timePickerViewModel.validateDateTime()
                    }
                    
                    Picker(selection: $timePickerViewModel.tempMonth, label: Text("Month")) {
                        ForEach(1...12, id: \.self) { month in
                            Text("\(month)").tag(month)
                        }
                    }
                    .frame(width: 100, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: timePickerViewModel.tempMonth) { _, _ in
                        timePickerViewModel.validateDay()
                        timePickerViewModel.validateDateTime()
                    }
                    
                    Picker(selection: $timePickerViewModel.tempYear, label: Text("Year")) {
                        ForEach(2020...2030, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .frame(width: 100, height: 150)
                    .clipped()
                    .pickerStyle(.wheel)
                    .onChange(of: timePickerViewModel.tempYear) { _, _ in
                        timePickerViewModel.validateDay()
                        timePickerViewModel.validateDateTime()
                    }
                }
                .padding()
                
                Button(action: {
                    timePickerViewModel.saveDestinationTime(userDefaultsManager.selectedCountry ?? Location(name: "Denpasar", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true), location)
                    isPickerPresented = false
                    
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
                .buttonStyle(.plain)
                
                Button("Batal") {
                    isPickerPresented = false
                }
                .foregroundColor(.red)
                .padding()
            }
            .presentationDetents([.height(600)])
        }
    }
}
