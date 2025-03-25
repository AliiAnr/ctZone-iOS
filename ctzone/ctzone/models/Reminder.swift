import Foundation

struct Reminder: Identifiable, Equatable {
    let id: UUID
    
    let currentHour: Int
    let currentMinute: Int
    let currentDay: Int
    let currentMonth: Int
    let currentYear: Int
    
    let destinationHour: Int
    let destinationMinute: Int
    let destinationDay: Int
    let destinationMonth: Int
    let destinationYear: Int
    
    let timestamp: Date
    
    let desc: String?
    
    let currentName: String?
    let currentImage: String?
    let currentCountry: String?
    let currentTimezone: String?
    let currentUtc: String?
    
    let destinationName: String?
    let destinationImage: String?
    let destinationCountry: String?
    let destinationTimezone: String?
    let destinationUtc: String?
    
    func currentFormattedTime(is24HourFormat: Bool) -> (hourMinute: String, amPm: String?) {
        formattedTime(is24HourFormat: is24HourFormat,
                      selectedHour: currentHour,
                      selectedMinute: currentMinute)
    }
    
    func currentFormattedDate() -> String {
        formattedDate(selectedDay: currentDay, selectedMonth: currentMonth, selectedYear: currentYear)
    }
    
    func destinationFormattedTime(is24HourFormat: Bool) -> (hourMinute: String, amPm: String?) {
        formattedTime(is24HourFormat: is24HourFormat,
                      selectedHour: destinationHour,
                      selectedMinute: destinationMinute)
    }
    
    func destinationFormattedDate() -> String {
        formattedDate(selectedDay: destinationDay, selectedMonth: destinationMonth, selectedYear: destinationYear)
    }
}
