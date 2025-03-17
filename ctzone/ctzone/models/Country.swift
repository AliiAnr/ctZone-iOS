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
