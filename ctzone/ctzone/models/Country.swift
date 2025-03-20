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
        
        Location(name: "Afghanistan", country: "Afghanistan", image: "afghanistan_image", timezoneIdentifier: "Asia/Kabul", utcInformation: "UTC+4:30", isCity: false),
        Location(name: "Albania", country: "Albania", image: "albania_image", timezoneIdentifier: "Europe/Tirane", utcInformation: "UTC+1", isCity: false),
        Location(name: "Algeria", country: "Algeria", image: "algeria_image", timezoneIdentifier: "Africa/Algiers", utcInformation: "UTC+1", isCity: false),
        Location(name: "Andorra", country: "Andorra", image: "andorra_image", timezoneIdentifier: "Europe/Andorra", utcInformation: "UTC+1", isCity: false),
        Location(name: "Angola", country: "Angola", image: "angola_image", timezoneIdentifier: "Africa/Luanda", utcInformation: "UTC+1", isCity: false),
        Location(name: "Antigua and Barbuda", country: "Antigua and Barbuda", image: "antigua_image", timezoneIdentifier: "America/Antigua", utcInformation: "UTC-4", isCity: false),
        Location(name: "Argentina", country: "Argentina", image: "argentina_image", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: false),
        Location(name: "Armenia", country: "Armenia", image: "armenia_image", timezoneIdentifier: "Asia/Yerevan", utcInformation: "UTC+4", isCity: false),
        Location(name: "Australia", country: "Australia", image: "australia_image", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: false),
        Location(name: "Austria", country: "Austria", image: "austria_image", timezoneIdentifier: "Europe/Vienna", utcInformation: "UTC+1", isCity: false),
        Location(name: "Azerbaijan", country: "Azerbaijan", image: "azerbaijan_image", timezoneIdentifier: "Asia/Baku", utcInformation: "UTC+4", isCity: false),
        Location(name: "Bahamas", country: "Bahamas", image: "bahamas_image", timezoneIdentifier: "America/Nassau", utcInformation: "UTC-5", isCity: false),
        Location(name: "Bahrain", country: "Bahrain", image: "bahrain_image", timezoneIdentifier: "Asia/Bahrain", utcInformation: "UTC+3", isCity: false),
        Location(name: "Bangladesh", country: "Bangladesh", image: "bangladesh_image", timezoneIdentifier: "Asia/Dhaka", utcInformation: "UTC+6", isCity: false),
        Location(name: "Barbados", country: "Barbados", image: "barbados_image", timezoneIdentifier: "America/Barbados", utcInformation: "UTC-4", isCity: false),
        Location(name: "Belarus", country: "Belarus", image: "belarus_image", timezoneIdentifier: "Europe/Minsk", utcInformation: "UTC+3", isCity: false),
        Location(name: "Belgium", country: "Belgium", image: "belgium_image", timezoneIdentifier: "Europe/Brussels", utcInformation: "UTC+1", isCity: false),
        Location(name: "Belize", country: "Belize", image: "belize_image", timezoneIdentifier: "America/Belize", utcInformation: "UTC-6", isCity: false),
        Location(name: "Benin", country: "Benin", image: "benin_image", timezoneIdentifier: "Africa/Porto-Novo", utcInformation: "UTC+1", isCity: false),
        Location(name: "Bhutan", country: "Bhutan", image: "bhutan_image", timezoneIdentifier: "Asia/Thimphu", utcInformation: "UTC+6", isCity: false),
        Location(name: "Bolivia", country: "Bolivia", image: "bolivia_image", timezoneIdentifier: "America/La_Paz", utcInformation: "UTC-4", isCity: false),
        Location(name: "Bosnia and Herzegovina", country: "Bosnia and Herzegovina", image: "bosnia_image", timezoneIdentifier: "Europe/Sarajevo", utcInformation: "UTC+1", isCity: false),
        Location(name: "Botswana", country: "Botswana", image: "botswana_image", timezoneIdentifier: "Africa/Gaborone", utcInformation: "UTC+2", isCity: false),
        Location(name: "Brazil", country: "Brazil", image: "brazil_image", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: false),
        Location(name: "Brunei", country: "Brunei", image: "brunei_image", timezoneIdentifier: "Asia/Brunei", utcInformation: "UTC+8", isCity: false),
        Location(name: "Bulgaria", country: "Bulgaria", image: "bulgaria_image", timezoneIdentifier: "Europe/Sofia", utcInformation: "UTC+2", isCity: false),
        Location(name: "Burkina Faso", country: "Burkina Faso", image: "burkina_faso_image", timezoneIdentifier: "Africa/Ouagadougou", utcInformation: "UTC+0", isCity: false),
        Location(name: "Burundi", country: "Burundi", image: "burundi_image", timezoneIdentifier: "Africa/Bujumbura", utcInformation: "UTC+2", isCity: false),
        Location(name: "Cabo Verde", country: "Cabo Verde", image: "cabo_verde_image", timezoneIdentifier: "Atlantic/Cape_Verde", utcInformation: "UTC-1", isCity: false),
        Location(name: "Cambodia", country: "Cambodia", image: "cambodia_image", timezoneIdentifier: "Asia/Phnom_Penh", utcInformation: "UTC+7", isCity: false),
        Location(name: "Cameroon", country: "Cameroon", image: "cameroon_image", timezoneIdentifier: "Africa/Douala", utcInformation: "UTC+1", isCity: false),
        Location(name: "Canada", country: "Canada", image: "canada_image", timezoneIdentifier: "America/Toronto", utcInformation: "UTC-5", isCity: false),
        Location(name: "Central African Republic", country: "Central African Republic", image: "car_image", timezoneIdentifier: "Africa/Bangui", utcInformation: "UTC+1", isCity: false),
        Location(name: "Chad", country: "Chad", image: "chad_image", timezoneIdentifier: "Africa/Ndjamena", utcInformation: "UTC+1", isCity: false),
        Location(name: "Chile", country: "Chile", image: "chile_image", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: false),
        Location(name: "China", country: "China", image: "china_image", timezoneIdentifier: "Asia/Shanghai", utcInformation: "UTC+8", isCity: false),
        Location(name: "Colombia", country: "Colombia", image: "colombia_image", timezoneIdentifier: "America/Bogota", utcInformation: "UTC-5", isCity: false),
        Location(name: "Comoros", country: "Comoros", image: "comoros_image", timezoneIdentifier: "Indian/Comoro", utcInformation: "UTC+3", isCity: false),
        Location(name: "Congo (Congo-Brazzaville)", country: "Congo", image: "congo_image", timezoneIdentifier: "Africa/Brazzaville", utcInformation: "UTC+1", isCity: false),
        Location(name: "Costa Rica", country: "Costa Rica", image: "costa_rica_image", timezoneIdentifier: "America/Costa_Rica", utcInformation: "UTC-6", isCity: false),
        Location(name: "Croatia", country: "Croatia", image: "croatia_image", timezoneIdentifier: "Europe/Zagreb", utcInformation: "UTC+1", isCity: false),
        Location(name: "Cuba", country: "Cuba", image: "cuba_image", timezoneIdentifier: "America/Havana", utcInformation: "UTC-5", isCity: false),
        Location(name: "Cyprus", country: "Cyprus", image: "cyprus_image", timezoneIdentifier: "Asia/Nicosia", utcInformation: "UTC+2", isCity: false),
        Location(name: "Czech Republic", country: "Czech Republic", image: "czech_republic_image", timezoneIdentifier: "Europe/Prague", utcInformation: "UTC+1", isCity: false),
        Location(name: "Denmark", country: "Denmark", image: "denmark_image", timezoneIdentifier: "Europe/Copenhagen", utcInformation: "UTC+1", isCity: false),
        Location(name: "Djibouti", country: "Djibouti", image: "djibouti_image", timezoneIdentifier: "Africa/Djibouti", utcInformation: "UTC+3", isCity: false),
        Location(name: "Dominica", country: "Dominica", image: "dominica_image", timezoneIdentifier: "America/Dominica", utcInformation: "UTC-4", isCity: false),
        Location(name: "Dominican Republic", country: "Dominican Republic", image: "dominican_republic_image", timezoneIdentifier: "America/Santo_Domingo", utcInformation: "UTC-4", isCity: false),
        Location(name: "East Timor", country: "East Timor", image: "east_timor_image", timezoneIdentifier: "Asia/Dili", utcInformation: "UTC+9", isCity: false),
        Location(name: "Ecuador", country: "Ecuador", image: "ecuador_image", timezoneIdentifier: "America/Guayaquil", utcInformation: "UTC-5", isCity: false),
        Location(name: "Egypt", country: "Egypt", image: "egypt_image", timezoneIdentifier: "Africa/Cairo", utcInformation: "UTC+2", isCity: false),
        Location(name: "El Salvador", country: "El Salvador", image: "el_salvador_image", timezoneIdentifier: "America/El_Salvador", utcInformation: "UTC-6", isCity: false),
        Location(name: "Equatorial Guinea", country: "Equatorial Guinea", image: "equatorial_guinea_image", timezoneIdentifier: "Africa/Malabo", utcInformation: "UTC+1", isCity: false),
        Location(name: "Eritrea", country: "Eritrea", image: "eritrea_image", timezoneIdentifier: "Africa/Asmara", utcInformation: "UTC+3", isCity: false),
        Location(name: "Estonia", country: "Estonia", image: "estonia_image", timezoneIdentifier: "Europe/Tallinn", utcInformation: "UTC+2", isCity: false),
        Location(name: "Eswatini", country: "Eswatini", image: "eswatini_image", timezoneIdentifier: "Africa/Mbabane", utcInformation: "UTC+2", isCity: false),
        Location(name: "Ethiopia", country: "Ethiopia", image: "ethiopia_image", timezoneIdentifier: "Africa/Addis_Ababa", utcInformation: "UTC+3", isCity: false),
        Location(name: "Fiji", country: "Fiji", image: "fiji_image", timezoneIdentifier: "Pacific/Fiji", utcInformation: "UTC+12", isCity: false),
        Location(name: "Finland", country: "Finland", image: "finland_image", timezoneIdentifier: "Europe/Helsinki", utcInformation: "UTC+2", isCity: false),
        Location(name: "France", country: "France", image: "france_image", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: false),
        Location(name: "Gabon", country: "Gabon", image: "gabon_image", timezoneIdentifier: "Africa/Libreville", utcInformation: "UTC+1", isCity: false),
        Location(name: "Gambia", country: "Gambia", image: "gambia_image", timezoneIdentifier: "Africa/Banjul", utcInformation: "UTC+0", isCity: false),
        Location(name: "Georgia", country: "Georgia", image: "georgia_image", timezoneIdentifier: "Asia/Tbilisi", utcInformation: "UTC+4", isCity: false),
        Location(name: "Germany", country: "Germany", image: "germany_image", timezoneIdentifier: "Europe/Berlin", utcInformation: "UTC+1", isCity: false),
        Location(name: "Ghana", country: "Ghana", image: "ghana_image", timezoneIdentifier: "Africa/Accra", utcInformation: "UTC+0", isCity: false),
        Location(name: "Greece", country: "Greece", image: "greece_image", timezoneIdentifier: "Europe/Athens", utcInformation: "UTC+2", isCity: false),
        Location(name: "Grenada", country: "Grenada", image: "grenada_image", timezoneIdentifier: "America/Grenada", utcInformation: "UTC-4", isCity: false),
        Location(name: "Guatemala", country: "Guatemala", image: "guatemala_image", timezoneIdentifier: "America/Guatemala", utcInformation: "UTC-6", isCity: false),
        Location(name: "Guinea", country: "Guinea", image: "guinea_image", timezoneIdentifier: "Africa/Conakry", utcInformation: "UTC+0", isCity: false),
        Location(name: "Guinea-Bissau", country: "Guinea-Bissau", image: "guinea_bissau_image", timezoneIdentifier: "Africa/Bissau", utcInformation: "UTC+0", isCity: false),
        Location(name: "Guyana", country: "Guyana", image: "guyana_image", timezoneIdentifier: "America/Guyana", utcInformation: "UTC-4", isCity: false),
        Location(name: "Haiti", country: "Haiti", image: "haiti_image", timezoneIdentifier: "America/Port-au-Prince", utcInformation: "UTC-5", isCity: false),
        Location(name: "Honduras", country: "Honduras", image: "honduras_image", timezoneIdentifier: "America/Tegucigalpa", utcInformation: "UTC-6", isCity: false),
        Location(name: "Hungary", country: "Hungary", image: "hungary_image", timezoneIdentifier: "Europe/Budapest", utcInformation: "UTC+1", isCity: false),
        Location(name: "Iceland", country: "Iceland", image: "iceland_image", timezoneIdentifier: "Atlantic/Reykjavik", utcInformation: "UTC+0", isCity: false),
        Location(name: "India", country: "India", image: "india_image", timezoneIdentifier: "Asia/Kolkata", utcInformation: "UTC+5:30", isCity: false),
        Location(name: "Indonesia", country: "Indonesia", image: "indonesia_image", timezoneIdentifier: "Asia/Jakarta", utcInformation: "UTC+7", isCity: false),
        Location(name: "Iran", country: "Iran", image: "iran_image", timezoneIdentifier: "Asia/Tehran", utcInformation: "UTC+3:30", isCity: false),
        Location(name: "Iraq", country: "Iraq", image: "iraq_image", timezoneIdentifier: "Asia/Baghdad", utcInformation: "UTC+3", isCity: false),
        Location(name: "Ireland", country: "Ireland", image: "ireland_image", timezoneIdentifier: "Europe/Dublin", utcInformation: "UTC+0", isCity: false),
        Location(name: "Israel", country: "Israel", image: "israel_image", timezoneIdentifier: "Asia/Jerusalem", utcInformation: "UTC+2", isCity: false),
        Location(name: "Italy", country: "Italy", image: "italy_image", timezoneIdentifier: "Europe/Rome", utcInformation: "UTC+1", isCity: false),
        Location(name: "Jamaica", country: "Jamaica", image: "jamaica_image", timezoneIdentifier: "America/Jamaica", utcInformation: "UTC-5", isCity: false),
        Location(name: "Japan", country: "Japan", image: "japan_image", timezoneIdentifier: "Asia/Tokyo", utcInformation: "UTC+9", isCity: false),
        Location(name: "Jordan", country: "Jordan", image: "jordan_image", timezoneIdentifier: "Asia/Amman", utcInformation: "UTC+2", isCity: false),
        Location(name: "Kazakhstan", country: "Kazakhstan", image: "kazakhstan_image", timezoneIdentifier: "Asia/Almaty", utcInformation: "UTC+6", isCity: false),
        Location(name: "Kenya", country: "Kenya", image: "kenya_image", timezoneIdentifier: "Africa/Nairobi", utcInformation: "UTC+3", isCity: false),
        Location(name: "Kiribati", country: "Kiribati", image: "kiribati_image", timezoneIdentifier: "Pacific/Tarawa", utcInformation: "UTC+12", isCity: false),
        Location(name: "Kuwait", country: "Kuwait", image: "kuwait_image", timezoneIdentifier: "Asia/Kuwait", utcInformation: "UTC+3", isCity: false),
        Location(name: "Kyrgyzstan", country: "Kyrgyzstan", image: "kyrgyzstan_image", timezoneIdentifier: "Asia/Bishkek", utcInformation: "UTC+6", isCity: false),
        Location(name: "Laos", country: "Laos", image: "laos_image", timezoneIdentifier: "Asia/Vientiane", utcInformation: "UTC+7", isCity: false),
        Location(name: "Latvia", country: "Latvia", image: "latvia_image", timezoneIdentifier: "Europe/Riga", utcInformation: "UTC+2", isCity: false),
        Location(name: "Lebanon", country: "Lebanon", image: "lebanon_image", timezoneIdentifier: "Asia/Beirut", utcInformation: "UTC+2", isCity: false),
        Location(name: "Lesotho", country: "Lesotho", image: "lesotho_image", timezoneIdentifier: "Africa/Maseru", utcInformation: "UTC+2", isCity: false),
        Location(name: "Liberia", country: "Liberia", image: "liberia_image", timezoneIdentifier: "Africa/Monrovia", utcInformation: "UTC+0", isCity: false),
        Location(name: "Libya", country: "Libya", image: "libya_image", timezoneIdentifier: "Africa/Tripoli", utcInformation: "UTC+2", isCity: false),
        Location(name: "Liechtenstein", country: "Liechtenstein", image: "liechtenstein_image", timezoneIdentifier: "Europe/Vaduz", utcInformation: "UTC+1", isCity: false),
        Location(name: "Lithuania", country: "Lithuania", image: "lithuania_image", timezoneIdentifier: "Europe/Vilnius", utcInformation: "UTC+2", isCity: false),
        Location(name: "Luxembourg", country: "Luxembourg", image: "luxembourg_image", timezoneIdentifier: "Europe/Luxembourg", utcInformation: "UTC+1", isCity: false),
        Location(name: "Madagascar", country: "Madagascar", image: "madagascar_image", timezoneIdentifier: "Indian/Antananarivo", utcInformation: "UTC+3", isCity: false),
        Location(name: "Malawi", country: "Malawi", image: "malawi_image", timezoneIdentifier: "Africa/Blantyre", utcInformation: "UTC+2", isCity: false),
        Location(name: "Malaysia", country: "Malaysia", image: "malaysia_image", timezoneIdentifier: "Asia/Kuala_Lumpur", utcInformation: "UTC+8", isCity: false),
        Location(name: "Maldives", country: "Maldives", image: "maldives_image", timezoneIdentifier: "Indian/Maldives", utcInformation: "UTC+5", isCity: false),
        Location(name: "Mali", country: "Mali", image: "mali_image", timezoneIdentifier: "Africa/Bamako", utcInformation: "UTC+0", isCity: false),
        Location(name: "Malta", country: "Malta", image: "malta_image", timezoneIdentifier: "Europe/Malta", utcInformation: "UTC+1", isCity: false),
        Location(name: "Marshall Islands", country: "Marshall Islands", image: "marshall_islands_image", timezoneIdentifier: "Pacific/Majuro", utcInformation: "UTC+12", isCity: false),
        Location(name: "Mauritania", country: "Mauritania", image: "mauritania_image", timezoneIdentifier: "Africa/Nouakchott", utcInformation: "UTC+0", isCity: false),
        Location(name: "Mauritius", country: "Mauritius", image: "mauritius_image", timezoneIdentifier: "Indian/Mauritius", utcInformation: "UTC+4", isCity: false),
        Location(name: "Mexico", country: "Mexico", image: "mexico_image", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: false),
        Location(name: "Micronesia", country: "Micronesia", image: "micronesia_image", timezoneIdentifier: "Pacific/Chuuk", utcInformation: "UTC+10", isCity: false),
        Location(name: "Moldova", country: "Moldova", image: "moldova_image", timezoneIdentifier: "Europe/Chisinau", utcInformation: "UTC+2", isCity: false),
        Location(name: "Monaco", country: "Monaco", image: "monaco_image", timezoneIdentifier: "Europe/Monaco", utcInformation: "UTC+1", isCity: false),
        Location(name: "Mongolia", country: "Mongolia", image: "mongolia_image", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation: "UTC+8", isCity: false),
        Location(name: "Montenegro", country: "Montenegro", image: "montenegro_image", timezoneIdentifier: "Europe/Podgorica", utcInformation: "UTC+1", isCity: false),
        Location(name: "Morocco", country: "Morocco", image: "morocco_image", timezoneIdentifier: "Africa/Casablanca", utcInformation: "UTC+1", isCity: false),
        Location(name: "Mozambique", country: "Mozambique", image: "mozambique_image", timezoneIdentifier: "Africa/Maputo", utcInformation: "UTC+2", isCity: false),
        Location(name: "Myanmar (Burma)", country: "Myanmar", image: "myanmar_image", timezoneIdentifier: "Asia/Yangon", utcInformation: "UTC+6:30", isCity: false),
        Location(name: "Namibia", country: "Namibia", image: "namibia_image", timezoneIdentifier: "Africa/Windhoek", utcInformation: "UTC+2", isCity: false),
        Location(name: "Nauru", country: "Nauru", image: "nauru_image", timezoneIdentifier: "Pacific/Nauru", utcInformation: "UTC+12", isCity: false),
        Location(name: "Nepal", country: "Nepal", image: "nepal_image", timezoneIdentifier: "Asia/Kathmandu", utcInformation: "UTC+5:45", isCity: false),
        Location(name: "Netherlands", country: "Netherlands", image: "netherlands_image", timezoneIdentifier: "Europe/Amsterdam", utcInformation: "UTC+1", isCity: false),
        Location(name: "New Zealand", country: "New Zealand", image: "new_zealand_image", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: false),
        Location(name: "Nicaragua", country: "Nicaragua", image: "nicaragua_image", timezoneIdentifier: "America/Managua", utcInformation: "UTC-6", isCity: false),
        Location(name: "Niger", country: "Niger", image: "niger_image", timezoneIdentifier: "Africa/Niamey", utcInformation: "UTC+1", isCity: false),
        Location(name: "Nigeria", country: "Nigeria", image: "nigeria_image", timezoneIdentifier: "Africa/Lagos", utcInformation: "UTC+1", isCity: false),
        Location(name: "North Korea", country: "North Korea", image: "north_korea_image", timezoneIdentifier: "Asia/Pyongyang", utcInformation: "UTC+9", isCity: false),
        Location(name: "North Macedonia", country: "North Macedonia", image: "north_macedonia_image", timezoneIdentifier: "Europe/Skopje", utcInformation: "UTC+1", isCity: false),
        Location(name: "Norway", country: "Norway", image: "norway_image", timezoneIdentifier: "Europe/Oslo", utcInformation: "UTC+1", isCity: false),
        Location(name: "Oman", country: "Oman", image: "oman_image", timezoneIdentifier: "Asia/Muscat", utcInformation: "UTC+4", isCity: false),
        Location(name: "Pakistan", country: "Pakistan", image: "pakistan_image", timezoneIdentifier: "Asia/Karachi", utcInformation: "UTC+5", isCity: false),
        Location(name: "Palau", country: "Palau", image: "palau_image", timezoneIdentifier: "Pacific/Palau", utcInformation: "UTC+9", isCity: false),
        Location(name: "Panama", country: "Panama", image: "panama_image", timezoneIdentifier: "America/Panama", utcInformation: "UTC-5", isCity: false),
        Location(name: "Papua New Guinea", country: "Papua New Guinea", image: "papua_new_guinea_image", timezoneIdentifier: "Pacific/Port_Moresby", utcInformation: "UTC+10", isCity: false),
        Location(name: "Paraguay", country: "Paraguay", image: "paraguay_image", timezoneIdentifier: "America/Asuncion", utcInformation: "UTC-4", isCity: false),
        Location(name: "Peru", country: "Peru", image: "peru_image", timezoneIdentifier: "America/Lima", utcInformation: "UTC-5", isCity: false),
        Location(name: "Philippines", country: "Philippines", image: "philippines_image", timezoneIdentifier: "Asia/Manila", utcInformation: "UTC+8", isCity: false),
        Location(name: "Poland", country: "Poland", image: "poland_image", timezoneIdentifier: "Europe/Warsaw", utcInformation: "UTC+1", isCity: false),
        Location(name: "Portugal", country: "Portugal", image: "portugal_image", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: false),
        Location(name: "Qatar", country: "Qatar", image: "qatar_image", timezoneIdentifier: "Asia/Qatar", utcInformation: "UTC+3", isCity: false),
        Location(name: "Romania", country: "Romania", image: "romania_image", timezoneIdentifier: "Europe/Bucharest", utcInformation: "UTC+2", isCity: false),
        Location(name: "Russia", country: "Russia", image: "russia_image", timezoneIdentifier: "Asia/Moscow", utcInformation: "UTC+3", isCity: false),
        Location(name: "Rwanda", country: "Rwanda", image: "rwanda_image", timezoneIdentifier: "Africa/Kigali", utcInformation: "UTC+2", isCity: false),
        Location(name: "Saint Kitts and Nevis", country: "Saint Kitts and Nevis", image: "saint_kitts_image", timezoneIdentifier: "America/St_Kitts", utcInformation: "UTC-4", isCity: false),
        Location(name: "Saint Lucia", country: "Saint Lucia", image: "saint_lucia_image", timezoneIdentifier: "America/St_Lucia", utcInformation: "UTC-4", isCity: false),
        Location(name: "Saint Vincent and the Grenadines", country: "Saint Vincent and the Grenadines", image: "saint_vincent_image", timezoneIdentifier: "America/St_Vincent", utcInformation: "UTC-4", isCity: false),
        Location(name: "Samoa", country: "Samoa", image: "samoa_image", timezoneIdentifier: "Pacific/Apia", utcInformation: "UTC+13", isCity: false),
        Location(name: "San Marino", country: "San Marino", image: "san_marino_image", timezoneIdentifier: "Europe/San_Marino", utcInformation: "UTC+1", isCity: false),
        Location(name: "Sao Tome and Principe", country: "Sao Tome and Principe", image: "sao_tome_image", timezoneIdentifier: "Africa/Sao_Tome", utcInformation: "UTC+0", isCity: false),
        Location(name: "Saudi Arabia", country: "Saudi Arabia", image: "saudi_arabia_image", timezoneIdentifier: "Asia/Riyadh", utcInformation: "UTC+3", isCity: false),
        Location(name: "Senegal", country: "Senegal", image: "senegal_image", timezoneIdentifier: "Africa/Dakar", utcInformation: "UTC+0", isCity: false),
        Location(name: "Serbia", country: "Serbia", image: "serbia_image", timezoneIdentifier: "Europe/Belgrade", utcInformation: "UTC+1", isCity: false),
        Location(name: "Seychelles", country: "Seychelles", image: "seychelles_image", timezoneIdentifier: "Indian/Mahe", utcInformation: "UTC+4", isCity: false),
        Location(name: "Sierra Leone", country: "Sierra Leone", image: "sierra_leone_image", timezoneIdentifier: "Africa/Freetown", utcInformation: "UTC+0", isCity: false),
        Location(name: "Singapore", country: "Singapore", image: "singapore_image", timezoneIdentifier: "Asia/Singapore", utcInformation: "UTC+8", isCity: false),
        Location(name: "Slovakia", country: "Slovakia", image: "slovakia_image", timezoneIdentifier: "Europe/Bratislava", utcInformation: "UTC+1", isCity: false),
        Location(name: "Slovenia", country: "Slovenia", image: "slovenia_image", timezoneIdentifier: "Europe/Ljubljana", utcInformation: "UTC+1", isCity: false),
        Location(name: "Solomon Islands", country: "Solomon Islands", image: "solomon_islands_image", timezoneIdentifier: "Pacific/Guadalcanal", utcInformation: "UTC+11", isCity: false),
        Location(name: "Somalia", country: "Somalia", image: "somalia_image", timezoneIdentifier: "Africa/Mogadishu", utcInformation: "UTC+3", isCity: false),
        Location(name: "South Africa", country: "South Africa", image: "south_africa_image", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: false),
        Location(name: "South Sudan", country: "South Sudan", image: "south_sudan_image", timezoneIdentifier: "Africa/Juba", utcInformation: "UTC+2", isCity: false),
        Location(name: "Spain", country: "Spain", image: "spain_image", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: false),
        Location(name: "Sri Lanka", country: "Sri Lanka", image: "sri_lanka_image", timezoneIdentifier: "Asia/Colombo", utcInformation: "UTC+5:30", isCity: false),
        Location(name: "Sudan", country: "Sudan", image: "sudan_image", timezoneIdentifier: "Africa/Khartoum", utcInformation: "UTC+2", isCity: false),
        Location(name: "Suriname", country: "Suriname", image: "suriname_image", timezoneIdentifier: "America/Paramaribo", utcInformation: "UTC-3", isCity: false),
        Location(name: "Sweden", country: "Sweden", image: "sweden_image", timezoneIdentifier: "Europe/Stockholm", utcInformation: "UTC+1", isCity: false),
        Location(name: "Switzerland", country: "Switzerland", image: "switzerland_image", timezoneIdentifier: "Europe/Zurich", utcInformation: "UTC+1", isCity: false),
        Location(name: "Syria", country: "Syria", image: "syria_image", timezoneIdentifier: "Asia/Damascus", utcInformation: "UTC+2", isCity: false),
    Location(name: "Taiwan", country: "Taiwan", image: "taiwan_image", timezoneIdentifier: "Asia/Taipei", utcInformation: "UTC+8", isCity: false),
    Location(name: "Tajikistan", country: "Tajikistan", image: "tajikistan_image", timezoneIdentifier: "Asia/Dushanbe", utcInformation: "UTC+5", isCity: false),
    Location(name: "Tanzania", country: "Tanzania", image: "tanzania_image", timezoneIdentifier: "Africa/Dar_es_Salaam", utcInformation: "UTC+3", isCity: false),
    Location(name: "Thailand", country: "Thailand", image: "thailand_image", timezoneIdentifier: "Asia/Bangkok", utcInformation: "UTC+7", isCity: false),
    Location(name: "Togo", country: "Togo", image: "togo_image", timezoneIdentifier: "Africa/Lome", utcInformation: "UTC+0", isCity: false),
    Location(name: "Tonga", country: "Tonga", image: "tonga_image", timezoneIdentifier: "Pacific/Tongatapu", utcInformation: "UTC+13", isCity: false),
    Location(name: "Trinidad and Tobago", country: "Trinidad and Tobago", image: "trinidad_tobago_image", timezoneIdentifier: "America/Port_of_Spain", utcInformation: "UTC-4", isCity: false),
    Location(name: "Tunisia", country: "Tunisia", image: "tunisia_image", timezoneIdentifier: "Africa/Tunis", utcInformation: "UTC+1", isCity: false),
    Location(name: "Turkey", country: "Turkey", image: "turkey_image", timezoneIdentifier: "Europe/Istanbul", utcInformation: "UTC+3", isCity: false),
    Location(name: "Turkmenistan", country: "Turkmenistan", image: "turkmenistan_image", timezoneIdentifier: "Asia/Ashgabat", utcInformation: "UTC+5", isCity: false),
    Location(name: "Tuvalu", country: "Tuvalu", image: "tuvalu_image", timezoneIdentifier: "Pacific/Funafuti", utcInformation: "UTC+12", isCity: false),
    Location(name: "Uganda", country: "Uganda", image: "uganda_image", timezoneIdentifier: "Africa/Kampala", utcInformation: "UTC+3", isCity: false),
    Location(name: "Ukraine", country: "Ukraine", image: "ukraine_image", timezoneIdentifier: "Europe/Kiev", utcInformation: "UTC+2", isCity: false),
    Location(name: "United Arab Emirates", country: "United Arab Emirates", image: "uae_image", timezoneIdentifier: "Asia/Dubai", utcInformation: "UTC+4", isCity: false),
    Location(name: "United Kingdom", country: "United Kingdom", image: "uk_image", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: false),
    Location(name: "United States", country: "USA", image: "usa_image", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: false),
    Location(name: "Uruguay", country: "Uruguay", image: "uruguay_image", timezoneIdentifier: "America/Montevideo", utcInformation: "UTC-3", isCity: false),
    Location(name: "Uzbekistan", country: "Uzbekistan", image: "uzbekistan_image", timezoneIdentifier: "Asia/Tashkent", utcInformation: "UTC+5", isCity: false),
    Location(name: "Vanuatu", country: "Vanuatu", image: "vanuatu_image", timezoneIdentifier: "Pacific/Efate", utcInformation: "UTC+11", isCity: false),
    Location(name: "Vatican City", country: "Vatican City", image: "vatican_city_image", timezoneIdentifier: "Europe/Vatican", utcInformation: "UTC+1", isCity: false),
    Location(name: "Venezuela", country: "Venezuela", image: "venezuela_image", timezoneIdentifier: "America/Caracas", utcInformation: "UTC-4", isCity: false),
    Location(name: "Vietnam", country: "Vietnam", image: "vietnam_image", timezoneIdentifier: "Asia/Ho_Chi_Minh", utcInformation: "UTC+7", isCity: false),
    Location(name: "Yemen", country: "Yemen", image: "yemen_image", timezoneIdentifier: "Asia/Aden", utcInformation: "UTC+3", isCity: false),
    Location(name: "Zambia", country: "Zambia", image: "zambia_image", timezoneIdentifier: "Africa/Lusaka", utcInformation: "UTC+2", isCity: false),
    Location(name: "Zimbabwe", country: "Zimbabwe", image: "zimbabwe_image", timezoneIdentifier: "Africa/Harare", utcInformation: "UTC+2", isCity: false),




    Location(name: "Kazan", country: "Russia", image: "", timezoneIdentifier: "Europe/Moscow", utcInformation: "UTC+3", isCity: true),
    Location(name: "Nizhny Novgorod", country: "Russia", image: "", timezoneIdentifier: "Europe/Moscow", utcInformation: "UTC+3", isCity: true),
    Location(name: "Tyumen", country: "Russia", image: "", timezoneIdentifier: "Asia/Yekaterinburg", utcInformation: "UTC+5", isCity: true),
    Location(name: "Khabarovsk", country: "Russia", image: "", timezoneIdentifier: "Asia/Vladivostok", utcInformation: "UTC+10", isCity: true),
    Location(name: "Seattle", country: "USA", image: "", timezoneIdentifier: "America/Los_Angeles", utcInformation: "UTC-8", isCity: true),
    Location(name: "San Diego", country: "USA", image: "", timezoneIdentifier: "America/Los_Angeles", utcInformation: "UTC-8", isCity: true),
    Location(name: "Salt Lake City", country: "USA", image: "", timezoneIdentifier: "America/Denver", utcInformation: "UTC-7", isCity: true),
    Location(name: "Austin", country: "USA", image: "", timezoneIdentifier: "America/Chicago", utcInformation: "UTC-6", isCity: true),
    Location(name: "Nashville", country: "USA", image: "", timezoneIdentifier: "America/Chicago", utcInformation: "UTC-6", isCity: true),
    Location(name: "Miami", country: "USA", image: "", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: true),
    Location(name: "Boston", country: "USA", image: "", timezoneIdentifier: "America/New_York", utcInformation: "UTC-5", isCity: true),
    Location(name: "Victoria", country: "Canada", image: "", timezoneIdentifier: "America/Vancouver", utcInformation: "UTC-8", isCity: true),
    Location(name: "Calgary", country: "Canada", image: "", timezoneIdentifier: "America/Edmonton", utcInformation: "UTC-7", isCity: true),
    Location(name: "Charlottetown", country: "Canada", image: "", timezoneIdentifier: "America/Halifax", utcInformation: "UTC-4", isCity: true),
    Location(name: "Rio de Janeiro", country: "Brazil", image: "", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: true),
    Location(name: "Curitiba", country: "Brazil", image: "", timezoneIdentifier: "America/Sao_Paulo", utcInformation: "UTC-3", isCity: true),
    Location(name: "Yogyakarta", country: "Indonesia", image: "", timezoneIdentifier: "Asia/Jakarta", utcInformation: "UTC+7", isCity: true),
    Location(name: "Manado", country: "Indonesia", image: "", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
    Location(name: "Sorong", country: "Indonesia", image: "", timezoneIdentifier: "Asia/Jayapura", utcInformation: "UTC+9", isCity: true),
    Location(name: "Ensenada", country: "Mexico", image: "", timezoneIdentifier: "America/Tijuana", utcInformation: "UTC-8", isCity: true),
    Location(name: "Oaxaca City", country: "Mexico", image: "", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: true),
    Location(name: "Mérida", country: "Mexico", image: "", timezoneIdentifier: "America/Mexico_City", utcInformation: "UTC-6", isCity: true),
    Location(name: "Karagandy", country: "Kazakhstan", image: "", timezoneIdentifier: "Asia/Almaty", utcInformation: "UTC+6", isCity: true),
    Location(name: "Erdenet", country: "Mongolia", image: "", timezoneIdentifier: "Asia/Ulaanbaatar", utcInformation: "UTC+8", isCity: true),
    Location(name: "Faro", country: "Portugal", image: "", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
    Location(name: "Coimbra", country: "Portugal", image: "", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
    Location(name: "Seville", country: "Spain", image: "", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: true),
    Location(name: "Bilbao", country: "Spain", image: "", timezoneIdentifier: "Europe/Madrid", utcInformation: "UTC+1", isCity: true),
    Location(name: "Valdivia", country: "Chile", image: "", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: true),
    Location(name: "La Serena", country: "Chile", image: "", timezoneIdentifier: "America/Santiago", utcInformation: "UTC-4", isCity: true),
    Location(name: "Ilulissat", country: "Greenland", image: "", timezoneIdentifier: "America/Godthab", utcInformation: "UTC-3", isCity: true),
    Location(name: "Kisangani", country: "DRC", image: "", timezoneIdentifier: "Africa/Kinshasa", utcInformation: "UTC+1", isCity: true),
    Location(name: "Gold Coast", country: "Australia", image: "", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: true),
    Location(name: "Canberra", country: "Australia", image: "", timezoneIdentifier: "Australia/Sydney", utcInformation: "UTC+10", isCity: true),
    Location(name: "Lyon", country: "France", image: "", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: true),
    Location(name: "Nice", country: "France", image: "", timezoneIdentifier: "Europe/Paris", utcInformation: "UTC+1", isCity: true),
    Location(name: "Edinburgh", country: "United Kingdom", image: "", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: true),
    Location(name: "Manchester", country: "United Kingdom", image: "", timezoneIdentifier: "Europe/London", utcInformation: "UTC+0", isCity: true),
    Location(name: "Queenstown", country: "New Zealand", image: "", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: true),
    Location(name: "Christchurch", country: "New Zealand", image: "", timezoneIdentifier: "Pacific/Auckland", utcInformation: "UTC+12", isCity: true),
    Location(name: "Durban", country: "South Africa", image: "", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
    Location(name: "Stellenbosch", country: "South Africa", image: "", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
    Location(name: "Maafushi", country: "Maldives", image: "", timezoneIdentifier: "Indian/Maldives", utcInformation: "UTC+5", isCity: true),
    Location(name: "Tarawa", country: "Kiribati", image: "", timezoneIdentifier: "Pacific/Tarawa", utcInformation: "UTC+12", isCity: true),
    Location(name: "Weno", country: "Micronesia", image: "", timezoneIdentifier: "Pacific/Chuuk", utcInformation: "UTC+10", isCity: true),
    Location(name: "Lae", country: "Papua New Guinea", image: "", timezoneIdentifier: "Pacific/Port_Moresby", utcInformation: "UTC+10", isCity: true),
    Location(name: "Pokhara", country: "Nepal", image: "", timezoneIdentifier: "Asia/Kathmandu", utcInformation: "UTC+5:45", isCity: true),
    Location(name: "Herat", country: "Afghanistan", image: "", timezoneIdentifier: "Asia/Kabul", utcInformation: "UTC+4:30", isCity: true),
    Location(name: "Isfahan", country: "Iran", image: "", timezoneIdentifier: "Asia/Tehran", utcInformation: "UTC+3:30", isCity: true),
    Location(name: "Ubud", country: "Indonesia", image: "", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
    Location(name: "Canggu", country: "Indonesia", image: "", timezoneIdentifier: "Asia/Makassar", utcInformation: "UTC+8", isCity: true),
    Location(name: "Chiang Mai", country: "Thailand", image: "", timezoneIdentifier: "Asia/Bangkok", utcInformation: "UTC+7", isCity: true),
    Location(name: "Medellín", country: "Colombia", image: "", timezoneIdentifier: "America/Bogota", utcInformation: "UTC-5", isCity: true),
    Location(name: "Lisbon", country: "Portugal", image: "", timezoneIdentifier: "Europe/Lisbon", utcInformation: "UTC+0", isCity: true),
    Location(name: "Tbilisi", country: "Georgia", image: "", timezoneIdentifier: "Asia/Tbilisi", utcInformation: "UTC+4", isCity: true),
    Location(name: "Budapest", country: "Hungary", image: "", timezoneIdentifier: "Europe/Budapest", utcInformation: "UTC+1", isCity: true),
    Location(name: "Ho Chi Minh City", country: "Vietnam", image: "", timezoneIdentifier: "Asia/Ho_Chi_Minh", utcInformation: "UTC+7", isCity: true),
    Location(name: "Buenos Aires", country: "Argentina", image: "", timezoneIdentifier: "America/Argentina/Buenos_Aires", utcInformation: "UTC-3", isCity: true),
    Location(name: "Cape Town", country: "South Africa", image: "", timezoneIdentifier: "Africa/Johannesburg", utcInformation: "UTC+2", isCity: true),
    Location(name: "Reykjavik", country: "Iceland", image: "", timezoneIdentifier: "Atlantic/Reykjavik", utcInformation: "UTC+0", isCity: true),
    ]
}



