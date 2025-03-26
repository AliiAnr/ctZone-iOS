import Foundation

class TimePickerViewModel: ObservableObject {
    @Published var selectedHour: Int
    @Published var selectedMinute: Int

    @Published var selectedDay: Int
    @Published var selectedMonth: Int
    @Published var selectedYear: Int

    @Published var destinationHour: Int
    @Published var destinationMinute: Int

    @Published var destinationDay: Int
    @Published var destinationMonth: Int
    @Published var destinationYear: Int

    @Published var isAM: Bool
    @Published var use24HourFormat: Bool = true

    // Variabel sementara sebelum menyimpan
    @Published var tempHour: Int
    @Published var tempMinute: Int
    @Published var tempIsAM: Bool
    @Published var tempDay: Int
    @Published var tempMonth: Int
    @Published var tempYear: Int

    let calendar = Calendar.current

    init() {
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)

        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let isAMValue = hour < 12
        let day = components.day ?? 1
        let month = components.month ?? 1
        let year = components.year ?? 2020

        // **Inisialisasi waktu awal untuk lokasi utama**
        selectedHour = hour
        selectedMinute = minute
        isAM = isAMValue
        selectedDay = day
        selectedMonth = month
        selectedYear = year

        // **Inisialisasi waktu awal untuk destinasi (default ke waktu saat ini)**
        destinationHour = hour
        destinationMinute = minute
        destinationDay = day
        destinationMonth = month
        destinationYear = year

        // **Inisialisasi variabel sementara**
        tempHour = hour
        tempMinute = minute
        tempIsAM = isAMValue
        tempDay = day
        tempMonth = month
        tempYear = year
        
//        print(formattedTime())
//        print(formattedDate())
//        
//        print(formattedDestinationDate())
//        print(formattedDestinationTime())
    }

    /// **Mengupdate waktu sesuai dengan lokasi yang dipilih**
    func updateTimeBasedOnLocation(_ location: Location) {
        guard let timeZone = location.timeZone else { return }

        let components = calendar.dateComponents(in: timeZone, from: Date())

        guard let hour = components.hour,
              let minute = components.minute,
              let day = components.day,
              let month = components.month,
              let year = components.year else { return }

        let isAMValue = hour < 12

        // **Mengupdate waktu terpilih**
        selectedHour = hour
        selectedMinute = minute
        isAM = isAMValue
        selectedDay = day
        selectedMonth = month
        selectedYear = year

        // **Mengupdate variabel sementara**
        tempHour = hour
        tempMinute = minute
        tempIsAM = isAMValue
        tempDay = day
        tempMonth = month
        tempYear = year
    }

    /// **Mengupdate waktu destinasi sesuai dengan lokasi yang dipilih**
    func getDestinationCountryTime(_ location: Location) {
        guard let timeZone = location.timeZone else { return }

        let components = calendar.dateComponents(in: timeZone, from: Date())

        guard let hour = components.hour,
              let minute = components.minute,
              let day = components.day,
              let month = components.month,
              let year = components.year else { return }

        destinationHour = hour
        destinationMinute = minute
        destinationDay = day
        destinationMonth = month
        destinationYear = year
    }
    
    func convertLocationTime(
            from sourceCity: Location,
            to destinationCity: Location,
            year: Int,
            month: Int,
            day: Int,
            hour: Int,
            minute: Int
        ) {
            guard let sourceTimeZone = sourceCity.timeZone,
                  let destinationTimeZone = destinationCity.timeZone else {
                return
            }

            var sourceCalendar = Calendar.current
            sourceCalendar.timeZone = sourceTimeZone

            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute

            guard let sourceDate = sourceCalendar.date(from: dateComponents) else {
                return
            }

            let sourceComponents = sourceCalendar.dateComponents(in: sourceTimeZone, from: sourceDate)

            var destinationCalendar = Calendar.current
            destinationCalendar.timeZone = destinationTimeZone

            if let destinationDate = destinationCalendar.date(from: sourceComponents) {
                let destinationComponents = destinationCalendar.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: destinationDate
                )

                guard let convertedYear = destinationComponents.year,
                      let convertedMonth = destinationComponents.month,
                      let convertedDay = destinationComponents.day,
                      let convertedHour = destinationComponents.hour,
                      let convertedMinute = destinationComponents.minute else {
                    return
                }

                // **Mengupdate variabel tujuan**
                destinationYear = convertedYear
                destinationMonth = convertedMonth
                destinationDay = convertedDay
                destinationHour = convertedHour
                destinationMinute = convertedMinute
            }
        }
    
    func daysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return 30
    }

    func validateDay() {
        let maxDays = daysInMonth(month: tempMonth, year: tempYear)
        if tempDay > maxDays {
            tempDay = maxDays
        }
    }
    
//    func resetToCurrentTime() {
//        let currentDate = Date()
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
//
//        // **Set semua nilai kembali ke waktu saat ini**
//        selectedYear = components.year ?? tempYear
//        selectedMonth = components.month ?? tempMonth
//        selectedDay = components.day ?? tempDay
//        selectedHour = components.hour ?? tempHour
//        selectedMinute = components.minute ?? tempMinute
//        isAM = tempHour < 12
//    }
    
    func resetToCurrentTime(currentTime: Location, destinationTime: Location) {
        updateTimeBasedOnLocation(currentTime)
        getDestinationCountryTime(destinationTime)
    }

    /// **Validasi Tanggal & Waktu Tidak Boleh di Masa Lalu**
    func validateDateTime() {
        let now = Date()
        let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)

        var selectedComponents = DateComponents()
        selectedComponents.year = tempYear
        selectedComponents.month = tempMonth
        selectedComponents.day = tempDay
        selectedComponents.hour = tempHour
        selectedComponents.minute = tempMinute

        if let selectedDate = calendar.date(from: selectedComponents), selectedDate < now {
            tempYear = nowComponents.year ?? tempYear
            tempMonth = nowComponents.month ?? tempMonth
            tempDay = nowComponents.day ?? tempDay
            tempHour = nowComponents.hour ?? tempHour
            tempMinute = nowComponents.minute ?? tempMinute
            tempIsAM = tempHour < 12
        }

        if tempYear == nowComponents.year, tempMonth == nowComponents.month, tempDay == nowComponents.day {
            if tempHour < nowComponents.hour ?? 0 {
                tempHour = nowComponents.hour ?? tempHour
                tempMinute = nowComponents.minute ?? tempMinute
                tempIsAM = tempHour < 12
            }
            
            if !use24HourFormat {
                let currentIsAM = (nowComponents.hour ?? 0) < 12
                if tempIsAM && !currentIsAM {
                    tempIsAM = false
                }
            }
        }
    }

    func loadTempValues() {
        tempHour = selectedHour
        tempMinute = selectedMinute
        tempIsAM = isAM
        tempDay = selectedDay
        tempMonth = selectedMonth
        tempYear = selectedYear
    }

//    func saveTime() {
//        selectedHour = tempHour
//        selectedMinute = tempMinute
//        isAM = tempIsAM
//        selectedDay = tempDay
//        selectedMonth = tempMonth
//        selectedYear = tempYear
//    }
    
    func saveDestinationTime(_ currentLocation : Location, _ destinationLocation : Location) {
                selectedHour = tempHour
                selectedMinute = tempMinute
                isAM = tempIsAM
                selectedDay = tempDay
                selectedMonth = tempMonth
                selectedYear = tempYear
        
        convertLocationTime(from: currentLocation, to: destinationLocation, year: selectedYear, month: selectedMonth, day: selectedDay, hour: selectedHour, minute: selectedMinute)
    }
    
//    func formattedTime() -> (hourMinute: String, amPm: String?) {
//        // Memastikan hasil ternary selalu berupa String
//        let hour = use24HourFormat ? String(format: "%02d", selectedHour) : String(format: "%02d", (selectedHour % 12 == 0 ? 12 : selectedHour % 12))
//        let minute = String(format: "%02d", selectedMinute)  // Memastikan menit selalu dua digit
//        let amPm = isAM ? "AM" : "PM"
//
//        return use24HourFormat ? ("\(hour):\(minute)", nil) : ("\(hour):\(minute)", amPm)
//    }
    
    func formattedTime() -> (hourMinute: String, amPm: String?) {
        // Misalkan selectedHour adalah jam dalam format 24 jam (contoh: 22 untuk 10 malam)
        let hour24 = selectedHour
        // Konversi ke format 12 jam
        let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
        // Pastikan menit selalu dua digit
        let minute = String(format: "%02d", selectedMinute)
        
        // Hitung period berdasarkan selectedHour, bukan variabel isAM yang statis
        let period = hour24 < 12 ? "AM" : "PM"
        
        if use24HourFormat {
            return ("\(String(format: "%02d", hour24)):\(minute)", nil)
        } else {
            return ("\(String(format: "%02d", hour12)):\(minute)", period)
        }
    }

//
//    func formattedDestinationTime() -> (hourMinute: String, amPm: String?) {
//        // Memastikan hasil ternary selalu berupa String
//        let hour = use24HourFormat ? String(format: "%02d", destinationHour) : String(format: "%02d" , (destinationHour % 12 == 0 ? 12 : destinationHour % 12))
//        let minute = String(format: "%02d", destinationMinute)  // Memastikan menit selalu dua digit
//        let amPm = isAM ? "AM" : "PM"
//
//        return use24HourFormat ? ("\(hour):\(minute)", nil) : ("\(hour):\(minute)", amPm)
//    }
    
    func formattedDestinationTime() -> (hourMinute: String, amPm: String?) {
        // Misalkan selectedHour adalah jam dalam format 24 jam (contoh: 22 untuk 10 malam)
        let hour24 = destinationHour
        // Konversi ke format 12 jam
        let hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12
        // Pastikan menit selalu dua digit
        let minute = String(format: "%02d", destinationMinute)
        
        // Hitung period berdasarkan selectedHour, bukan variabel isAM yang statis
        let period = hour24 < 12 ? "AM" : "PM"
        
        if use24HourFormat {
            return ("\(String(format: "%02d", hour24)):\(minute)", nil)
        } else {
            return ("\(String(format: "%02d", hour12)):\(minute)", period)
        }
    }




    

    func formattedDate() -> String {
        return "\(selectedDay)-\(selectedMonth)-\(selectedYear)"
    }
    
    func formattedDestinationDate() -> String {
        return "\(destinationDay)-\(destinationMonth)-\(destinationYear)"
    }
}


// how you describe when developing the app
