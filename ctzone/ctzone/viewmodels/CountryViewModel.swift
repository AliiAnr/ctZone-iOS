import SwiftUI

class CountryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var locations: [Location] = [
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
    
    var filteredCountries: [Location] {
        let sortedCountries = locations.sorted { $0.name < $1.name }
        if searchText.isEmpty {
            return sortedCountries
        } else {
            return sortedCountries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
