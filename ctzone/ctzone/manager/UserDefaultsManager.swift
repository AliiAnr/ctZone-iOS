import SwiftUI

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()

    private let defaults = UserDefaults.standard
    private let use24HourKey = "use24HourFormat"
    private let selectedCountryKey = "selectedCountry"
    private let selectedDateKey = "selectedDate"

    @Published var use24HourFormat: Bool {
        didSet {
            defaults.set(use24HourFormat, forKey: use24HourKey)
        }
    }

    @Published var selectedCountry: Country? {
        didSet {
            saveSelectedCountry()
        }
    }

    @Published var selectedDate: String {
        didSet {
            defaults.set(selectedDate, forKey: selectedDateKey)
        }
    }

    private init() {
        self.use24HourFormat = defaults.bool(forKey: use24HourKey)
        self.selectedCountry = Self.loadSelectedCountry()
        self.selectedDate = defaults.string(forKey: selectedDateKey) ?? Self.getCurrentDate()
    }

    // **Menyimpan negara yang dipilih user ke UserDefaults**
    private func saveSelectedCountry() {
        if let country = selectedCountry {
            if let encoded = try? JSONEncoder().encode(country) {
                defaults.set(encoded, forKey: selectedCountryKey)
            }
        } else {
            defaults.removeObject(forKey: selectedCountryKey) // Hapus jika nil
        }
    }

    // **Memuat negara yang dipilih dari UserDefaults**
    private static func loadSelectedCountry() -> Country? {
        guard let data = UserDefaults.standard.data(forKey: "selectedCountry"),
              let decoded = try? JSONDecoder().decode(Country.self, from: data) else {
            return nil
        }
        return decoded
    }

    // **Mengatur negara yang dipilih user**
    func setSelectedCountry(_ country: Country) {
        selectedCountry = country
    }

    // **Menghapus negara yang dipilih user**
    func clearSelectedCountry() {
        selectedCountry = nil
    }

    // **Fungsi untuk mendapatkan tanggal saat ini dalam format dd-MM-yyyy**
    private static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: Date())
    }

    // **Mengupdate tanggal ke tanggal saat ini**
    func updateCurrentDate() {
        selectedDate = Self.getCurrentDate()
    }
}
