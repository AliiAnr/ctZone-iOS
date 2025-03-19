import Foundation
import Combine

final class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    // Enum untuk key-string agar lebih terstruktur
    private enum Keys {
        static let use24HourFormat = "use24HourFormat"
        static let selectedCountry = "selectedCountry"
        static let selectedDate = "selectedDate"
    }
    
    @Published var use24HourFormat: Bool {
        didSet {
            defaults.set(use24HourFormat, forKey: Keys.use24HourFormat)
        }
    }
    
    @Published var selectedCountry: Location? {
        didSet {
            saveSelectedCountry()
            // Update tanggal berdasarkan lokasi yang dipilih setiap kali ada perubahan
            updateDateBasedOnSelectedLocation()
        }
    }
    
    @Published var selectedDate: String {
        didSet {
            defaults.set(selectedDate, forKey: Keys.selectedDate)
        }
    }
    
    private init() {
        self.use24HourFormat = defaults.bool(forKey: Keys.use24HourFormat)
        self.selectedCountry = Self.loadSelectedCountry(from: defaults)
        self.selectedDate = defaults.string(forKey: Keys.selectedDate) ?? Self.getCurrentDate()
    }
    
    private func saveSelectedCountry() {
        guard let country = selectedCountry else {
            defaults.removeObject(forKey: Keys.selectedCountry)
            print("Lokasi dihapus dari UserDefaults")
            return
        }
        
        do {
            let encoded = try JSONEncoder().encode(country)
            defaults.set(encoded, forKey: Keys.selectedCountry)
            print("✅ Berhasil menyimpan lokasi: \(country)")
        } catch {
            print("❌ Gagal encoding lokasi: \(error)")
        }
    }
    
    private static func loadSelectedCountry(from defaults: UserDefaults) -> Location? {
        guard let data = defaults.data(forKey: Keys.selectedCountry) else {
            print("Tidak ada data lokasi tersimpan")
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(Location.self, from: data)
            print("Berhasil memuat lokasi dari UserDefaults: \(decoded)")
            return decoded
        } catch {
            print("Gagal decoding lokasi: \(error)")
            return nil
        }
    }
    
    /// **Mengatur lokasi yang dipilih user**
    func setSelectedCountry(_ country: Location) {
        print("🟡 Mengubah selectedCountry menjadi \(country)")
        selectedCountry = country
    }
    
    /// **Menghapus lokasi yang dipilih user**
    func clearSelectedCountry() {
        selectedCountry = nil
    }
    
    /// **Fungsi untuk mendapatkan tanggal saat ini dalam format dd-MM-yyyy dengan timezone default**
    private static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: Date())
    }
    
    /// **Mengupdate tanggal ke tanggal saat ini dengan timezone default**
    func updateCurrentDate() {
        selectedDate = Self.getCurrentDate()
    }
    
    /// **Mengupdate tanggal berdasarkan lokasi yang dipilih user**
    func updateDateBasedOnSelectedLocation() {
        guard let location = selectedCountry, let timeZone = location.timeZone else {
            print("Lokasi tidak tersedia atau timezone tidak valid, gunakan tanggal default")
            updateCurrentDate()
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = timeZone
        selectedDate = formatter.string(from: Date())
        print("✅ Tanggal diperbarui sesuai lokasi \(location.name): \(selectedDate)")
    }
    
    /// **Mereset seluruh data di UserDefaults**
    func resetUserDefaults() {
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
    }
}
