import Foundation

struct Location: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let country: String?
    let image: String
    let timezoneIdentifier: String
    let utcInformation: String?
    let isCity: Bool
    var isPinned: Bool = false

    var timeZone: TimeZone? {
        return TimeZone(identifier: timezoneIdentifier)
    }
    
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    func currentTimeFormat(is24HourFormat: Bool) -> (hourMinute: String, amPm: String?) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
            
            if is24HourFormat {
                formatter.dateFormat = "HH:mm"
            } else {
                formatter.dateFormat = "hh:mm a"
            }
            
            let formattedTime = formatter.string(from: Date())
            
            if is24HourFormat {
                return (formattedTime, nil)
            } else {
                let components = formattedTime.split(separator: " ")
                return (String(components[0]), String(components[1]))
            }
        }
    
    func currentTimeFormat(is24HourFormat: Bool, date: Date) -> (hourMinute: String, amPm: String?) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        if is24HourFormat {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "hh:mm a"
        }
        let formattedTime = formatter.string(from: date)
        if is24HourFormat {
            return (formattedTime, nil)
        } else {
            let components = formattedTime.split(separator: " ")
            guard components.count >= 2 else { return (formattedTime, nil) }
            return (String(components[0]), String(components[1]))
        }
    }

    func getCurrentTime() -> (hour: Int, minute: Int)? {
        guard let timeZone = self.timeZone else { return nil }
        
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents(in: timeZone, from: date)

        guard let hour = components.hour, let minute = components.minute else { return nil }
        return (hour, minute)
    }

    func getCurrentDate() -> (day: Int, month: Int, year: Int)? {
        guard let timeZone = self.timeZone else { return nil }
        
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents(in: timeZone, from: date)

        guard let day = components.day, let month = components.month, let year = components.year else { return nil }
        return (day, month, year)
    }
    
    func capitalizedName() -> String {
        return name.capitalized
    }
}


