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

class CityViewModel: ObservableObject {
    @Published var searchText: String = ""
    let cities: [City] = [
        City(name: "Kaliningrad", country: "Russia", timezoneIdentifier: "Europe/Kaliningrad"),
        City(name: "Moscow", country: "Russia", timezoneIdentifier: "Europe/Moscow"),
        City(name: "Saint Petersburg", country: "Russia", timezoneIdentifier: "Europe/Moscow"),
        City(name: "Samara", country: "Russia", timezoneIdentifier: "Europe/Samara"),
        City(name: "Udmurtia", country: "Russia", timezoneIdentifier: "Europe/Samara"),
        City(name: "Yekaterinburg", country: "Russia", timezoneIdentifier: "Asia/Yekaterinburg"),
        City(name: "Chelyabinsk", country: "Russia", timezoneIdentifier: "Asia/Yekaterinburg"),
        City(name: "Omsk", country: "Russia", timezoneIdentifier: "Asia/Omsk"),
        City(name: "Novosibirsk", country: "Russia", timezoneIdentifier: "Asia/Novosibirsk"),
        City(name: "Krasnoyarsk", country: "Russia", timezoneIdentifier: "Asia/Krasnoyarsk"),
        City(name: "Irkutsk", country: "Russia", timezoneIdentifier: "Asia/Irkutsk"),
        City(name: "Ulan-Ude", country: "Russia", timezoneIdentifier: "Asia/Irkutsk"),
        City(name: "Yakutsk", country: "Russia", timezoneIdentifier: "Asia/Yakutsk"),
        City(name: "Vladivostok", country: "Russia", timezoneIdentifier: "Asia/Vladivostok"),
        City(name: "Magadan", country: "Russia", timezoneIdentifier: "Asia/Magadan"),
        City(name: "Kamchatka", country: "Russia", timezoneIdentifier: "Asia/Kamchatka"),
        City(name: "Anadyr", country: "Russia", timezoneIdentifier: "Asia/Anadyr"),
        City(name: "Baker Island", country: "USA", timezoneIdentifier: "Pacific/Kiritimati"),
        City(name: "Howland Island", country: "USA", timezoneIdentifier: "Pacific/Kiritimati"),
        City(name: "American Samoa", country: "USA", timezoneIdentifier: "Pacific/Pago_Pago"),
        City(name: "Midway Atoll", country: "USA", timezoneIdentifier: "Pacific/Midway"),
        City(name: "Hawaii", country: "USA", timezoneIdentifier: "Pacific/Honolulu"),
        City(name: "Anchorage", country: "USA", timezoneIdentifier: "America/Anchorage"),
        City(name: "Los Angeles", country: "USA", timezoneIdentifier: "America/Los_Angeles"),
        City(name: "San Francisco", country: "USA", timezoneIdentifier: "America/Los_Angeles"),
        City(name: "Denver", country: "USA", timezoneIdentifier: "America/Denver"),
        City(name: "Phoenix", country: "USA", timezoneIdentifier: "America/Phoenix"),
        City(name: "Chicago", country: "USA", timezoneIdentifier: "America/Chicago"),
        City(name: "New York", country: "USA", timezoneIdentifier: "America/New_York"),
        City(name: "Guam", country: "USA", timezoneIdentifier: "Pacific/Guam"),
        City(name: "Wake Island", country: "USA", timezoneIdentifier: "Pacific/Wake"),
        City(name: "Polinesia Prancis", country: "France", timezoneIdentifier: "Pacific/Tahiti"),
        City(name: "Kepulauan Marquesas", country: "France", timezoneIdentifier: "Pacific/Marquesas"),
        City(name: "Kepulauan Gambier", country: "France", timezoneIdentifier: "Pacific/Gambier"),
        City(name: "Pulau Clipperton", country: "France", timezoneIdentifier: "Pacific/Tahiti"),
        City(name: "Guadeloupe", country: "France", timezoneIdentifier: "America/Guadeloupe"),
        City(name: "Martinique", country: "France", timezoneIdentifier: "America/Martinique"),
        City(name: "Guyana Prancis", country: "France", timezoneIdentifier: "America/Cayenne"),
        City(name: "Saint Pierre dan Miquelon", country: "France", timezoneIdentifier: "America/Miquelon"),
        City(name: "Paris", country: "France", timezoneIdentifier: "Europe/Paris"),
        City(name: "Mayotte", country: "France", timezoneIdentifier: "Indian/Mayotte"),
        City(name: "Réunion", country: "France", timezoneIdentifier: "Indian/Reunion"),
        City(name: "Kepulauan Kerguelen", country: "France", timezoneIdentifier: "Indian/Kerguelen"),
        City(name: "Kaledonia Baru", country: "France", timezoneIdentifier: "Pacific/Noumea"),
        City(name: "Wallis dan Futuna", country: "France", timezoneIdentifier: "Pacific/Wallis"),
        City(name: "Kepulauan Heard dan McDonald", country: "Australia", timezoneIdentifier: "Indian/Mauritius"),
        City(name: "Kepulauan Cocos (Keeling)", country: "Australia", timezoneIdentifier: "Indian/Cocos"),
        City(name: "Pulau Christmas", country: "Australia", timezoneIdentifier: "Indian/Christmas"),
        City(name: "Perth", country: "Australia", timezoneIdentifier: "Australia/Perth"),
        City(name: "Adelaide", country: "Australia", timezoneIdentifier: "Australia/Adelaide"),
        City(name: "Darwin", country: "Australia", timezoneIdentifier: "Australia/Darwin"),
        City(name: "Sydney", country: "Australia", timezoneIdentifier: "Australia/Sydney"),
        City(name: "Melbourne", country: "Australia", timezoneIdentifier: "Australia/Melbourne"),
        City(name: "Brisbane", country: "Australia", timezoneIdentifier: "Australia/Brisbane"),
        City(name: "Pulau Lord Howe", country: "Australia", timezoneIdentifier: "Australia/Lord_Howe"),
        City(name: "Pulau Norfolk", country: "Australia", timezoneIdentifier: "Pacific/Norfolk"),
        City(name: "Vancouver", country: "Canada", timezoneIdentifier: "America/Vancouver"),
        City(name: "Edmonton", country: "Canada", timezoneIdentifier: "America/Edmonton"),
        City(name: "Winnipeg", country: "Canada", timezoneIdentifier: "America/Winnipeg"),
        City(name: "Toronto", country: "Canada", timezoneIdentifier: "America/Toronto"),
        City(name: "Halifax", country: "Canada", timezoneIdentifier: "America/Halifax"),
        City(name: "St. John's", country: "Canada", timezoneIdentifier: "America/St_Johns"),
        City(name: "Rio Branco", country: "Brazil", timezoneIdentifier: "America/Rio_Branco"),
        City(name: "Manaus", country: "Brazil", timezoneIdentifier: "America/Manaus"),
        City(name: "Brasilia", country: "Brazil", timezoneIdentifier: "America/Sao_Paulo"),
        City(name: "Fernando de Noronha", country: "Brazil", timezoneIdentifier: "America/Noronha"),
        City(name: "Jakarta", country: "Indonesia", timezoneIdentifier: "Asia/Jakarta"),
        City(name: "Bandung", country: "Indonesia", timezoneIdentifier: "Asia/Jakarta"),
        City(name: "Medan", country: "Indonesia", timezoneIdentifier: "Asia/Jakarta"),
        City(name: "Denpasar", country: "Indonesia", timezoneIdentifier: "Asia/Makassar"),
        City(name: "Makassar", country: "Indonesia", timezoneIdentifier: "Asia/Makassar"),
        City(name: "Mataram", country: "Indonesia", timezoneIdentifier: "Asia/Makassar"),
        City(name: "Jayapura", country: "Indonesia", timezoneIdentifier: "Asia/Jayapura"),
        City(name: "Ambon", country: "Indonesia", timezoneIdentifier: "Asia/Jayapura"),
        City(name: "Tijuana", country: "Mexico", timezoneIdentifier: "America/Tijuana"),
        City(name: "Chihuahua", country: "Mexico", timezoneIdentifier: "America/Chihuahua"),
        City(name: "Tijuana", country: "Mexico", timezoneIdentifier: "America/Tijuana"),
        City(name: "Hermosillo", country: "Mexico", timezoneIdentifier: "America/Hermosillo"),
        City(name: "Mexico City", country: "Mexico", timezoneIdentifier: "America/Mexico_City"),
        City(name: "Cancún", country: "Mexico", timezoneIdentifier: "America/Cancun"),
        City(name: "Aktobe", country: "Kazakhstan", timezoneIdentifier: "Asia/Aqtobe"),
        City(name: "Atyrau", country: "Kazakhstan", timezoneIdentifier: "Asia/Atyrau"),
        City(name: "Uralsk", country: "Kazakhstan", timezoneIdentifier: "Asia/Oral"),
        City(name: "Nur-Sultan (Astana)", country: "Kazakhstan", timezoneIdentifier: "Asia/Almaty"),
        City(name: "Almaty", country: "Kazakhstan", timezoneIdentifier: "Asia/Almaty"),
        City(name: "Shymkent", country: "Kazakhstan", timezoneIdentifier: "Asia/Almaty"),
        City(name: "Khovd", country: "Mongolia", timezoneIdentifier: "Asia/Hovd"),
        City(name: "Uvs", country: "Mongolia", timezoneIdentifier: "Asia/Hovd"),
        City(name: "Bayan-Ölgii", country: "Mongolia", timezoneIdentifier: "Asia/Hovd"),
        City(name: "Ulaanbaatar", country: "Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar"),
        City(name: "Darkhan", country: "Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar"),
        City(name: "Erdenet", country: "Mongolia", timezoneIdentifier: "Asia/Ulaanbaatar"),
        City(name: "Lisbon", country: "Portugal", timezoneIdentifier: "Europe/Lisbon"),
        City(name: "Porto", country: "Portugal", timezoneIdentifier: "Europe/Lisbon"),
        City(name: "Braga", country: "Portugal", timezoneIdentifier: "Europe/Lisbon"),
        City(name: "Ponta Delgada", country: "Portugal", timezoneIdentifier: "Atlantic/Azores"),
        City(name: "Angra do Heroísmo", country: "Portugal", timezoneIdentifier: "Atlantic/Azores"),
        City(name: "Madrid", country: "Spain", timezoneIdentifier: "Europe/Madrid"),
        City(name: "Barcelona", country: "Spain", timezoneIdentifier: "Europe/Madrid"),
        City(name: "Valencia", country: "Spain", timezoneIdentifier: "Europe/Madrid"),
        City(name: "Las Palmas", country: "Spain", timezoneIdentifier: "Atlantic/Canary"),
        City(name: "Santa Cruz de Tenerife", country: "Spain", timezoneIdentifier: "Atlantic/Canary"),
        City(name: "Johannesburg", country: "South Africa", timezoneIdentifier: "Africa/Johannesburg"),
        City(name: "Cape Town", country: "South Africa", timezoneIdentifier: "Africa/Johannesburg"),
        City(name: "Pretoria", country: "South Africa", timezoneIdentifier: "Africa/Johannesburg"),
        City(name: "Marion Island", country: "South Africa", timezoneIdentifier: "Indian/Marion"),
        City(name: "Prince Edward Islands", country: "South Africa", timezoneIdentifier: "Indian/Marion"),
        City(name: "Santiago", country: "Chile", timezoneIdentifier: "America/Santiago"),
        City(name: "Easter Island", country: "Chile", timezoneIdentifier: "Pacific/Easter"),
        City(name: "Valparaíso", country: "Chile", timezoneIdentifier: "America/Santiago"),
        City(name: "Concepción", country: "Chile", timezoneIdentifier: "America/Santiago"),
        City(name: "Magallanes", country: "Chile", timezoneIdentifier: "America/Punta_Arenas"),
        City(name: "Kinshasa", country: "DRC", timezoneIdentifier: "Africa/Kinshasa"),
        City(name: "Lubumbashi", country: "DRC", timezoneIdentifier: "Africa/Lubumbashi"),
        City(name: "Nuuk", country: "Greenland", timezoneIdentifier: "America/Godthab"),
        City(name: "Danmarkshavn", country: "Greenland", timezoneIdentifier: "America/Danmarkshavn"),
        City(name: "Pituffik", country: "Greenland", timezoneIdentifier: "America/Thule"),
        City(name: "Malé", country: "Maldives", timezoneIdentifier: "Indian/Maldives"),
        City(name: "Resorts & Atolls", country: "Maldives", timezoneIdentifier: "Indian/Maldives")
    ]
    
    var filteredCities: [City] {
            let sortedCities = cities.sorted { $0.name < $1.name }
            if searchText.isEmpty {
                return sortedCities
            } else {
                return sortedCities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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

    var timeZone: TimeZone? {
        return TimeZone(identifier: timezoneIdentifier)
    }
    
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
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


class LocationTimeConverter {
    
    static func convertLocationTime(
        from sourceCity: Location,
        to destinationCity: Location,
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
    
    static let cities: [Location] = [
        Location(name: "Kaliningrad", country: "Russia", image:"", timezoneIdentifier: "Europe/Kaliningrad", utcInformation:"", isCity: true),
        Location(name: "Moscow", country: "Russia", image:"", timezoneIdentifier: "Europe/Moscow", utcInformation:"", isCity: true),
        Location(name: "Saint Petersburg", country: "Russia", image:"", timezoneIdentifier: "Europe/Moscow", utcInformation:"", isCity: true),
        Location(name: "Samara", country: "Russia", image:"", timezoneIdentifier: "Europe/Samara", utcInformation:"", isCity: true),
        Location(name: "Udmurtia", country: "Russia", image:"", timezoneIdentifier: "Europe/Samara", utcInformation:"", isCity: true),
        Location(name: "Yekaterinburg", country: "Russia", image:"", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation:"", isCity: true),
        Location(name: "Chelyabinsk", country: "Russia", image:"", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation:"", isCity: true),
        Location(name: "Omsk", country: "Russia", image:"", timezoneIdentifier: "Asia/Omsk", utcInformation:"", isCity: true),
        Location(name: "Novosibirsk", country: "Russia", image:"", timezoneIdentifier: "Asia/Novosibirsk", utcInformation:"", isCity: true),
        Location(name: "Krasnoyarsk", country: "Russia", image:"", timezoneIdentifier: "Asia/Krasnoyarsk", utcInformation:"", isCity: true),
        Location(name: "Irkutsk", country: "Russia", image:"", timezoneIdentifier: "Asia/Irkutsk", utcInformation:"", isCity: true),
        Location(name: "Ulan-Ude", country: "Russia", image:"", timezoneIdentifier: "Asia/Irkutsk", utcInformation:"", isCity: true),
        Location(name: "Yakutsk", country: "Russia", image:"", timezoneIdentifier: "Asia/Yakutsk", utcInformation:"", isCity: true),
        Location(name: "Vladivostok", country: "Russia", image:"", timezoneIdentifier: "Asia/Vladivostok", utcInformation:"", isCity: true),
        Location(name: "Magadan", country: "Russia", image:"", timezoneIdentifier: "Asia/Magadan", utcInformation:"", isCity: true),
        Location(name: "Kamchatka", country: "Russia", image:"", timezoneIdentifier: "Asia/Kamchatka", utcInformation:"", isCity: true),
        Location(name: "Anadyr", country: "Russia", image:"", timezoneIdentifier: "Asia/Anadyr", utcInformation:"", isCity: true),
        Location(name: "Baker Island", country: "USA", image:"", timezoneIdentifier: "Pacific/Kiritimati", utcInformation:"", isCity: true),
        Location(name: "Howland Island", country: "USA", image:"", timezoneIdentifier: "Pacific/Kiritimati", utcInformation:"", isCity: true),
        Location(name: "American Samoa", country: "USA", image:"", timezoneIdentifier: "Pacific/Pago_Pago", utcInformation:"", isCity: true),
        Location(name: "Midway Atoll", country: "USA", image:"", timezoneIdentifier: "Pacific/Midway", utcInformation:"", isCity: true),
        Location(name: "Hawaii", country: "USA", image:"", timezoneIdentifier: "Pacific/Honolulu", utcInformation:"", isCity: true),
        Location(name: "Anchorage", country: "USA", image:"", timezoneIdentifier: "America/Anchorage", utcInformation:"", isCity: true),
        Location(name: "Los Angeles", country: "USA", image:"", timezoneIdentifier: "America/Los_Angeles", utcInformation:"", isCity: true),
        Location(name: "San Francisco", country: "USA", image:"", timezoneIdentifier: "America/Los_Angeles", utcInformation:"", isCity: true),
        Location(name: "Denver", country: "USA", image:"", timezoneIdentifier: "America/Denver", utcInformation:"", isCity: true),
        Location(name: "Phoenix", country: "USA", image:"", timezoneIdentifier: "America/Phoenix", utcInformation:"", isCity: true),
        Location(name: "Chicago", country: "USA", image:"", timezoneIdentifier: "America/Chicago", utcInformation:"", isCity: true),
        Location(name: "New York", country: "USA", image:"", timezoneIdentifier: "America/New_York", utcInformation:"", isCity: true),
        Location(name: "Guam", country: "USA", image:"", timezoneIdentifier: "Pacific/Guam", utcInformation:"", isCity: true),
        Location(name: "Wake Island", country: "USA", image:"", timezoneIdentifier: "Pacific/Wake", utcInformation:"", isCity: true),
        Location(name: "Polinesia Prancis", country: "France", image:"", timezoneIdentifier: "Pacific/Tahiti", utcInformation:"", isCity: true),
        Location(name: "Kepulauan Marquesas", country: "France", image:"", timezoneIdentifier: "Pacific/Marquesas", utcInformation:"", isCity: true),
        Location(name: "Kepulauan Gambier", country: "France", image:"", timezoneIdentifier: "Pacific/Gambier", utcInformation:"", isCity: true),
        Location(name: "Pulau Clipperton", country: "France", image:"", timezoneIdentifier: "Pacific/Tahiti", utcInformation:"", isCity: true),
        Location(name: "Guadeloupe", country: "France", image:"", timezoneIdentifier: "America/Guadeloupe", utcInformation:"", isCity: true),
        Location(name: "Martinique", country: "France", image:"", timezoneIdentifier: "America/Martinique", utcInformation:"", isCity: true),
        Location(name: "Guyana Prancis", country: "France", image:"", timezoneIdentifier: "America/Cayenne", utcInformation:"", isCity: true),
        Location(name: "Saint Pierre dan Miquelon", country: "France", image:"", timezoneIdentifier: "America/Miquelon", utcInformation:"", isCity: true),
        Location(name: "Paris", country: "France", image:"", timezoneIdentifier: "Europe/Paris", utcInformation:"", isCity: true),
        Location(name: "Mayotte", country: "France", image:"", timezoneIdentifier: "Indian/Mayotte", utcInformation:"", isCity: true),
        Location(name: "Réunion", country: "France", image:"", timezoneIdentifier: "Indian/Reunion", utcInformation:"", isCity: true),
        Location(name: "Kepulauan Kerguelen", country: "France", image:"", timezoneIdentifier: "Indian/Kerguelen", utcInformation:"", isCity: true),
        Location(name: "Kaledonia Baru", country: "France", image:"", timezoneIdentifier: "Pacific/Noumea", utcInformation:"", isCity: true),
        Location(name: "Wallis dan Futuna", country: "France", image:"", timezoneIdentifier: "Pacific/Wallis", utcInformation:"", isCity: true),
        Location(name: "Kepulauan Heard dan McDonald", country: "Australia", image:"", timezoneIdentifier: "Indian/Mauritius", utcInformation:"", isCity: true),
        Location(name: "Kepulauan Cocos (Keeling)", country: "Australia", image:"", timezoneIdentifier: "Indian/Cocos", utcInformation:"", isCity: true),
        Location(name: "Pulau Christmas", country: "Australia", image:"", timezoneIdentifier: "Indian/Christmas", utcInformation:"", isCity: true),
        Location(name: "Perth", country: "Australia", image:"", timezoneIdentifier: "Australia/Perth", utcInformation:"", isCity: true),
        Location(name: "Adelaide", country: "Australia", image:"", timezoneIdentifier: "Australia/Adelaide", utcInformation:"", isCity: true),
        Location(name: "Darwin", country: "Australia", image:"", timezoneIdentifier: "Australia/Darwin", utcInformation:"", isCity: true),
        Location(name: "Sydney", country: "Australia", image:"", timezoneIdentifier: "Australia/Sydney", utcInformation:"", isCity: true),
        Location(name: "Melbourne", country: "Australia", image:"", timezoneIdentifier: "Australia/Melbourne", utcInformation:"", isCity: true),
        Location(name: "Brisbane", country: "Australia", image:"", timezoneIdentifier: "Australia/Brisbane", utcInformation:"", isCity: true),
        Location(name: "Pulau Lord Howe", country: "Australia", image:"", timezoneIdentifier: "Australia/Lord_Howe", utcInformation:"", isCity: true),
        Location(name: "Pulau Norfolk", country: "Australia", image:"", timezoneIdentifier: "Pacific/Norfolk", utcInformation:"", isCity: true),
        Location(name: "Vancouver", country: "Canada", image:"", timezoneIdentifier: "America/Vancouver", utcInformation:"", isCity: true),
        Location(name: "Edmonton", country: "Canada", image:"", timezoneIdentifier: "America/Edmonton", utcInformation:"", isCity: true),
        Location(name: "Winnipeg", country: "Canada", image:"", timezoneIdentifier: "America/Winnipeg", utcInformation:"", isCity: true),
        Location(name: "Toronto", country: "Canada", image:"", timezoneIdentifier: "America/Toronto", utcInformation:"", isCity: true),
        Location(name: "Halifax", country: "Canada", image:"", timezoneIdentifier: "America/Halifax", utcInformation:"", isCity: true),
        Location(name: "St. John's", country: "Canada", image:"", timezoneIdentifier: "America/St_Johns", utcInformation:"", isCity: true),
        Location(name: "Rio Branco", country: "Brazil", image:"", timezoneIdentifier: "America/Rio_Branco", utcInformation:"", isCity: true),
        Location(name: "Manaus", country: "Brazil", image:"", timezoneIdentifier: "America/Manaus", utcInformation:"", isCity: true),
        Location(name: "Brasilia", country: "Brazil", image:"", timezoneIdentifier: "America/Sao_Paulo", utcInformation:"", isCity: true),
        Location(name: "Fernando de Noronha", country: "Brazil", image:"", timezoneIdentifier: "America/Noronha", utcInformation:"", isCity: true),
        Location(name: "Jakarta", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true),
        Location(name: "Bandung", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true),
        Location(name: "Medan", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jakarta", utcInformation:"", isCity: true),
        Location(name: "Denpasar", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true),
        Location(name: "Makassar", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true),
        Location(name: "Mataram", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Makassar", utcInformation:"", isCity: true),
        Location(name: "Jayapura", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jayapura", utcInformation:"", isCity: true),
        Location(name: "Ambon", country: "Indonesia", image:"", timezoneIdentifier: "Asia/Jayapura", utcInformation:"", isCity: true),
        Location(name: "Tijuana", country: "Mexico", image:"", timezoneIdentifier: "America/Tijuana", utcInformation:"", isCity: true),
        Location(name: "Chihuahua", country: "Mexico", image:"", timezoneIdentifier: "America/Chihuahua", utcInformation:"", isCity: true),
        Location(name: "Tijuana", country: "Mexico", image:"", timezoneIdentifier: "America/Tijuana", utcInformation:"", isCity: true),
        Location(name: "Hermosillo", country: "Mexico", image:"", timezoneIdentifier: "America/Hermosillo", utcInformation:"", isCity: true),
        Location(name: "Mexico City", country: "Mexico", image:"", timezoneIdentifier: "America/Mexico_City", utcInformation:"", isCity: true),
        Location(name: "Cancún", country: "Mexico", image:"", timezoneIdentifier: "America/Cancun", utcInformation:"", isCity: true),
        Location(name: "Aktobe", country: "Kazakhstan", image:"", timezoneIdentifier: "Asia/Aqtobe", utcInformation:"", isCity: true),
        Location(name: "Atyrau", country: "Kazakhstan", image:"", timezoneIdentifier: "Asia/Atyrau", utcInformation:"", isCity: true),
        Location(name: "Uralsk", country: "Kazakhstan", image:"", timezoneIdentifier: "Asia/Oral", utcInformation:"", isCity: true),
        Location(name: "Nur-Sultan (Astana)", country: "Kazakhstan", image:"", timezoneIdentifier: "Asia/Almaty", utcInformation:"", isCity: true),
        Location(name: "Almaty", country: "Kazakhstan", image:"", timezoneIdentifier: "Asia/Almaty", utcInformation:"", isCity: true),
        Location(name: "Shymkent", country: "Kazakhstan", image:"", timezoneIdentifier: "Asia/Almaty", utcInformation:"", isCity: true),
        Location(name: "Khovd", country: "Mongolia", image:"", timezoneIdentifier: "Asia/Hovd", utcInformation:"", isCity: true),
        Location(name: "Uvs", country: "Mongolia", image:"", timezoneIdentifier: "Asia/Hovd", utcInformation:"", isCity: true),
        Location(name: "Bayan-Ölgii", country: "Mongolia", image:"", timezoneIdentifier: "Asia/Hovd", utcInformation:"", isCity: true),
        Location(name: "Ulaanbaatar", country: "Mongolia", image:"", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"", isCity: true),
        Location(name: "Darkhan", country: "Mongolia", image:"", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"", isCity: true),
        Location(name: "Erdenet", country: "Mongolia", image:"", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation:"", isCity: true),
        Location(name: "Lisbon", country: "Portugal", image:"", timezoneIdentifier: "Europe/Lisbon", utcInformation:"", isCity: true),
        Location(name: "Porto", country: "Portugal", image:"", timezoneIdentifier: "Europe/Lisbon", utcInformation:"", isCity: true),
        Location(name: "Braga", country: "Portugal", image:"", timezoneIdentifier: "Europe/Lisbon", utcInformation:"", isCity: true),
        Location(name: "Ponta Delgada", country: "Portugal", image:"", timezoneIdentifier: "Atlantic/Azores", utcInformation:"", isCity: true),
        Location(name: "Angra do Heroísmo", country: "Portugal", image:"", timezoneIdentifier: "Atlantic/Azores", utcInformation:"", isCity: true),
        Location(name: "Madrid", country: "Spain", image:"", timezoneIdentifier: "Europe/Madrid", utcInformation:"", isCity: true),
        Location(name: "Barcelona", country: "Spain", image:"", timezoneIdentifier: "Europe/Madrid", utcInformation:"", isCity: true),
        Location(name: "Valencia", country: "Spain", image:"", timezoneIdentifier: "Europe/Madrid", utcInformation:"", isCity: true),
        Location(name: "Las Palmas", country: "Spain", image:"", timezoneIdentifier: "Atlantic/Canary", utcInformation:"", isCity: true),
        Location(name: "Santa Cruz de Tenerife", country: "Spain", image:"", timezoneIdentifier: "Atlantic/Canary", utcInformation:"", isCity: true),
        Location(name: "Johannesburg", country: "South Africa", image:"", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"", isCity: true),
        Location(name: "Cape Town", country: "South Africa", image:"", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"", isCity: true),
        Location(name: "Pretoria", country: "South Africa", image:"", timezoneIdentifier: "Africa/Johannesburg", utcInformation:"", isCity: true),
        Location(name: "Marion Island", country: "South Africa", image:"", timezoneIdentifier: "Indian/Marion", utcInformation:"", isCity: true),
        Location(name: "Prince Edward Islands", country: "South Africa", image:"", timezoneIdentifier: "Indian/Marion", utcInformation:"", isCity: true),
        Location(name: "Santiago", country: "Chile", image:"", timezoneIdentifier: "America/Santiago", utcInformation:"", isCity: true),
        Location(name: "Easter Island", country: "Chile", image:"", timezoneIdentifier: "Pacific/Easter", utcInformation:"", isCity: true),
        Location(name: "Valparaíso", country: "Chile", image:"", timezoneIdentifier: "America/Santiago", utcInformation:"", isCity: true),
        Location(name: "Concepción", country: "Chile", image:"", timezoneIdentifier: "America/Santiago", utcInformation:"", isCity: true),
        Location(name: "Magallanes", country: "Chile", image:"", timezoneIdentifier: "America/Punta_Arenas", utcInformation:"", isCity: true),
        Location(name: "Kinshasa", country: "DRC", image:"", timezoneIdentifier: "Africa/Kinshasa", utcInformation:"", isCity: true),
        Location(name: "Lubumbashi", country: "DRC", image:"", timezoneIdentifier: "Africa/Lubumbashi", utcInformation:"", isCity: true),
        Location(name: "Nuuk", country: "Greenland", image:"", timezoneIdentifier: "America/Godthab", utcInformation:"", isCity: true),
        Location(name: "Danmarkshavn", country: "Greenland", image:"", timezoneIdentifier: "America/Danmarkshavn", utcInformation:"", isCity: true),
        Location(name: "Pituffik", country: "Greenland", image:"", timezoneIdentifier: "America/Thule", utcInformation:"", isCity: true),
        Location(name: "Malé", country: "Maldives", image:"", timezoneIdentifier: "Indian/Maldives", utcInformation:"", isCity: true),
        Location(name: "Resorts & Atolls", country: "Maldives", image:"", timezoneIdentifier: "Indian/Maldives", utcInformation:"", isCity: true)
    ]
}



