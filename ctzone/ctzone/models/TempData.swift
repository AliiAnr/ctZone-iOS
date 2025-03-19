import Foundation
import SwiftUI

struct Product: Identifiable, Hashable {
    let id: Int
    let name: String
}

struct TempData {
    static let listProduct = [
        Product(id: 1, name: "iPhone 15"),
        Product(id: 2, name: "MacBook Pro M4"),
        Product(id: 3, name: "iPad Pro M4")
    ]
}
//import SwiftUI
//
//struct TimeConverterView: View {
//    @State private var convertedTime: String = ""
//
//    let jakarta = Countryy(name: "Jakarta", timeZoneIdentifier: "Asia/Jakarta")
//    let newYork = Countryy(name: "New York", timeZoneIdentifier: "America/New_York")
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Konversi Waktu dari Jakarta ke New York")
//                .font(.headline)
//                .multilineTextAlignment(.center)
//
//            Button("Konversi Waktu") {
//                if let result = CountryTimeConverter.convertSpecificTime(
//                    from: jakarta,
//                    to: newYork,
//                    year: 2025,
//                    month: 1,
//                    day: 22,
//                    hour: 22,
//                    minute: 0
//                ) {
//                    convertedTime = result
//                } else {
//                    convertedTime = "Konversi gagal"
//                }
//            }
//            .buttonStyle(.borderedProminent)
//
//            if !convertedTime.isEmpty {
//                Text("Waktu Terkonversi: \(convertedTime)")
//                    .font(.title2)
//                    .foregroundColor(.blue)
//            }
//        }
//        .padding()
//    }
//}

import SwiftUI

struct TimeConverterView: View {
    @StateObject private var viewModel = CityViewModel()
    
    @State private var selectedSourceCity: City?
    @State private var selectedDestinationCity: City?
    @State private var selectedDate = Date()
    @State private var convertedTime: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Konversi Waktu Antar Kota")
                    .font(.largeTitle)
                    .bold()

                // **Picker untuk Kota Sumber**
                VStack(alignment: .leading) {
                    Text("Pilih Kota Asal:")
                        .font(.headline)
                    Picker("Kota Asal", selection: $selectedSourceCity) {
                        ForEach(viewModel.filteredCities) { city in
                            Text("\(city.name), \(city.country)").tag(Optional(city))
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // **Picker untuk Kota Tujuan**
                VStack(alignment: .leading) {
                    Text("Pilih Kota Tujuan:")
                        .font(.headline)
                    Picker("Kota Tujuan", selection: $selectedDestinationCity) {
                        ForEach(viewModel.filteredCities) { city in
                            Text("\(city.name), \(city.country)").tag(Optional(city))
                        }
                    }
                    .pickerStyle(.menu)
                }

                // **Button untuk Konversi**
                Button("Konversi Waktu") {
                    if let source = selectedSourceCity, let destination = selectedDestinationCity {
                        convertedTime = CityTimeConverter.convertTime(
                            from: source, to: destination,
                            year: 2025, month: 3, day: 18, hour: 8, minute: 22
                        ) ?? "Konversi gagal"
                    }
                }
                .buttonStyle(.borderedProminent)

                // **Menampilkan Hasil Konversi**
                if !convertedTime.isEmpty {
                    Text("Waktu Terkonversi: \(convertedTime)")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}


#Preview {
    TimeConverterView()
}
