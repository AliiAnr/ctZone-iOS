//
//  LocationViewModel.swift
//  ctzone
//
//  Created by Ali An Nuur on 23/03/25.
//

// LAST NIGHT PINNED MAU NAMBAH TAPI MAGER, DAN DI ACADEMY SAJA

import SwiftUI
import Combine

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var searchText: String = ""
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
        loadLocations()
    }
    
    func location(with id: UUID) -> Location? {
        return locations.first { $0.id == id }
    }
    
    func loadLocations() {
        let entities = repository.fetchLocations()
        
        let newLocations = entities.map { entity in
            Location(
                id: entity.id ?? UUID(),
                name: entity.name ?? "",
                country: entity.country,
                image: entity.image ?? "",
                timezoneIdentifier: entity.timezoneIdentifier ?? "",
                utcInformation: entity.utcInformation,
                isCity: entity.isCity,
                isPinned: entity.isPinned
            )
        }
        
        self.locations = newLocations
    }
    
    func updatePinStatus(location: Location, pinned: Bool) {
            repository.updatePinStatus(for: location.id, pinned: pinned)
            loadLocations()
        }
    
    var filteredCountries: [Location] {
        let sortedCountries = locations.sorted { $0.name < $1.name }
        if searchText.isEmpty {
            return sortedCountries
        } else {
            return sortedCountries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func deleteLocation(_ location: Location) {
           // Repository melakukan penghapusan berdasarkan ID
           repository.deleteLocation(withId: location.id)
           // Refresh data setelah penghapusan
           loadLocations()
       }
}
