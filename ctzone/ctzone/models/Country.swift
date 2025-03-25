import Foundation

struct Country: Identifiable, Encodable, Decodable {
    var id = UUID()
    let name: String
    let timezone: String

    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezone)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    func capitalizedName() -> String {
        return name.capitalized
    }
}

import Foundation

struct Countryy {
    let name: String
    let timeZoneIdentifier: String

    var timeZone: TimeZone? {
        return TimeZone(identifier: timeZoneIdentifier)
    }
}

class CountryTimeConverter {
    static func convertTime(from sourceCountry: Countryy, to destinationCountry: Countryy, date: Date) -> String? {
        guard let sourceTimeZone = sourceCountry.timeZone,
              let destinationTimeZone = destinationCountry.timeZone else {
            return nil
        }

        // Buat kalender dengan zona waktu sumber
        var sourceCalendar = Calendar.current
        sourceCalendar.timeZone = sourceTimeZone

        // Ekstrak komponen tanggal dan waktu dari tanggal sumber
        let components = sourceCalendar.dateComponents(in: sourceTimeZone, from: date)

        // Buat kalender dengan zona waktu tujuan
        var destinationCalendar = Calendar.current
        destinationCalendar.timeZone = destinationTimeZone

        // Konversi komponen ke tanggal di zona waktu tujuan
        if let destinationDate = destinationCalendar.date(from: components) {
            let formatter = DateFormatter()
            formatter.timeZone = destinationTimeZone
            formatter.dateFormat = "yyyy-MM-dd HH:mm"

            return formatter.string(from: destinationDate)
        } else {
            return nil
        }
    }
    
    static func convertSpecificTime(
            from sourceCountry: Countryy,
            to destinationCountry: Countryy,
            year: Int,
            month: Int,
            day: Int,
            hour: Int,
            minute: Int
        ) -> String? {
            guard let sourceTimeZone = sourceCountry.timeZone,
                  let destinationTimeZone = destinationCountry.timeZone else {
                return nil
            }

            // **Buat kalender dengan zona waktu sumber**
            var sourceCalendar = Calendar.current
            sourceCalendar.timeZone = sourceTimeZone

            // **Membuat DateComponents dari input angka**
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute

            // **Membentuk Date dari komponen di zona waktu sumber**
            guard let sourceDate = sourceCalendar.date(from: dateComponents) else {
                return nil
            }

            // **Ekstrak komponen tanggal & waktu dari zona waktu sumber**
            let sourceComponents = sourceCalendar.dateComponents(in: sourceTimeZone, from: sourceDate)

            // **Buat kalender dengan zona waktu tujuan**
            var destinationCalendar = Calendar.current
            destinationCalendar.timeZone = destinationTimeZone

            // **Konversi ke zona waktu tujuan menggunakan komponen yang sama**
            if let destinationDate = destinationCalendar.date(from: sourceComponents) {
                let formatter = DateFormatter()
                formatter.timeZone = destinationTimeZone
                formatter.dateFormat = "yyyy-MM-dd HH:mm"

                return formatter.string(from: destinationDate)
            } else {
                return nil
            }
        }
}

struct City: Identifiable,  Hashable {
    let id = UUID()
    let name: String
    let country: String
    let timezoneIdentifier: String

    var timeZone: TimeZone? {
        return TimeZone(identifier: timezoneIdentifier)
    }
}

class CityTimeConverter {
    static func convertTime(
        from sourceCity: City,
        to destinationCity: City,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int
    ) -> String? {
        guard let sourceTimeZone = sourceCity.timeZone,
              let destinationTimeZone = destinationCity.timeZone else {
            return nil
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
            return nil
        }

        let sourceComponents = sourceCalendar.dateComponents(in: sourceTimeZone, from: sourceDate)

        var destinationCalendar = Calendar.current
        destinationCalendar.timeZone = destinationTimeZone

        if let destinationDate = destinationCalendar.date(from: sourceComponents) {
            let formatter = DateFormatter()
            formatter.timeZone = destinationTimeZone
            formatter.dateFormat = "yyyy-MM-dd HH:mm"

            return formatter.string(from: destinationDate)
        } else {
            return nil
        }
    }
}

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
            
            // Tentukan format berdasarkan is24HourFormat
            if is24HourFormat {
                formatter.dateFormat = "HH:mm"  // Format 24 jam
            } else {
                formatter.dateFormat = "hh:mm a"  // Format 12 jam dengan AM/PM
            }
            
            let formattedTime = formatter.string(from: Date())
            
            if is24HourFormat {
                return (formattedTime, nil)  // Tidak ada AM/PM untuk format 24 jam
            } else {
                let components = formattedTime.split(separator: " ")
                return (String(components[0]), String(components[1]))  // Pisahkan waktu dan AM/PM
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


    /// **Mengembalikan waktu saat ini dalam bentuk (jam, menit)**
    func getCurrentTime() -> (hour: Int, minute: Int)? {
        guard let timeZone = self.timeZone else { return nil }
        
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents(in: timeZone, from: date)

        guard let hour = components.hour, let minute = components.minute else { return nil }
        return (hour, minute)
    }

    /// **Mengembalikan tanggal saat ini dalam bentuk (tanggal, bulan, tahun)**
    func getCurrentDate() -> (day: Int, month: Int, year: Int)? {
        guard let timeZone = self.timeZone else { return nil }
        
        let calendar = Calendar.current
        let date = Date()
        let components = calendar.dateComponents(in: timeZone, from: date)

        guard let day = components.day, let month = components.month, let year = components.year else { return nil }
        return (day, month, year)
    }
    
    /// **Mengembalikan nama yang dikapitalisasi**
    func capitalizedName() -> String {
        return name.capitalized
    }
}


