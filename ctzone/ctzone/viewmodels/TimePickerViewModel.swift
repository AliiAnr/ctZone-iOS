import Foundation

class TimePickerViewModel: ObservableObject {
    @Published var selectedHour: Int
    @Published var selectedMinute: Int
    @Published var isAM: Bool
    @Published var use24HourFormat: Bool = true

    @Published var selectedDay: Int
    @Published var selectedMonth: Int
    @Published var selectedYear: Int

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

        selectedHour = hour
        selectedMinute = minute
        isAM = isAMValue
        selectedDay = day
        selectedMonth = month
        selectedYear = year

        tempHour = hour
        tempMinute = minute
        tempIsAM = isAMValue
        tempDay = day
        tempMonth = month
        tempYear = year
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
    
    func resetToCurrentTime() {
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)

        // **Set semua nilai kembali ke waktu saat ini**
        selectedYear = components.year ?? tempYear
        selectedMonth = components.month ?? tempMonth
        selectedDay = components.day ?? tempDay
        selectedHour = components.hour ?? tempHour
        selectedMinute = components.minute ?? tempMinute
        isAM = tempHour < 12
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

        // **Cek apakah AM dipilih saat waktu sebenarnya sudah PM**
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

    func saveTime() {
        selectedHour = tempHour
        selectedMinute = tempMinute
        isAM = tempIsAM
        selectedDay = tempDay
        selectedMonth = tempMonth
        selectedYear = tempYear
    }

    func formattedTime() -> String {
        let hour = use24HourFormat ? selectedHour : (selectedHour % 12 == 0 ? 12 : selectedHour % 12)
        let minute = String(format: "%02d", selectedMinute)
        let amPm = isAM ? "AM" : "PM"

        return use24HourFormat ? "\(hour):\(minute)" : "\(hour):\(minute) \(amPm)"
    }

    func formattedDate() -> String {
        return "\(selectedDay)-\(selectedMonth)-\(selectedYear)"
    }
}
