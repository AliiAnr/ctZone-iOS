import SwiftUI

class CountryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var countries: [Country] = [
        Country(name: "Argentina", timezone: "America/Argentina/Buenos_Aires"),
        Country(name: "Brazil", timezone: "America/Sao_Paulo"),
        Country(name: "Canada", timezone: "America/Toronto"),
        Country(name: "Denmark", timezone: "Europe/Copenhagen"),
        Country(name: "Egypt", timezone: "Africa/Cairo"),
        Country(name: "France", timezone: "Europe/Paris"),
        Country(name: "Germany", timezone: "Europe/Berlin"),
        Country(name: "India", timezone: "Asia/Kolkata"),
        Country(name: "Indonesia", timezone: "Asia/Jakarta"),
        Country(name: "Japan", timezone: "Asia/Tokyo"),
        Country(name: "United Kingdom", timezone: "Europe/London"),
        Country(name: "United States", timezone: "America/New_York")
    ]
    
    // **Filtered List of Countries (Ascending Order)**
    var filteredCountries: [Country] {
        let sortedCountries = countries.sorted { $0.name < $1.name }
        if searchText.isEmpty {
            return sortedCountries
        } else {
            return sortedCountries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
