//
//  LocationViewModel.swift
//  ctzone
//
//  Created by Ali An Nuur on 23/03/25.
//

import SwiftUI
import Combine

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var reminders: [Reminder] = []
    @Published var searchProfileText: String = ""
    @Published var searchText: String = ""
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
        loadLocations()
        loadRemindersSortedByTimestamp()
    }
    
//    MARK: - Location Section
    
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
    
    var filteredProfileCountries: [Location] {
        let sortedCountries = locations.sorted { $0.name < $1.name }
        if searchProfileText.isEmpty {
            return sortedCountries
        } else {
            return sortedCountries.filter { $0.name.localizedCaseInsensitiveContains(searchProfileText) }
        }
    }
    
    func deleteLocation(_ location: Location) {
           repository.deleteLocation(withId: location.id)
           loadLocations()
       }
    
    
//    MARK: - REMINDER Section
    
    func loadReminders() {
            reminders = repository.fetchAllReminders()
        }
        
        func loadRemindersSortedByTimestamp() {
            reminders = repository.fetchRemindersSortedByTimestamp()
        }
        
        func addReminder(_ reminder: Reminder) {
            let success = repository.insertReminder(reminder)
            if success {
                loadRemindersSortedByTimestamp()
            }
        }
        
        func removeReminder(id: UUID) {
            let success = repository.deleteReminder(by: id)
            if success {
                loadRemindersSortedByTimestamp()
            }
        }
        
        func removeAllReminders() {
            let success = repository.deleteAllReminders()
            if success {
                loadRemindersSortedByTimestamp()
            }
        }
}
