import Foundation

protocol LocationRepositoryProtocol {
    func fetchLocations() -> [LocationEntity]
    func addDummyLocationsIfNeeded()
    func fetchLocation(by id: UUID) -> LocationEntity?
    func updatePinStatus(for locationId: UUID, pinned: Bool)
    func deleteLocation(withId id: UUID)
    
    func insertReminder(_ reminder: Reminder) -> Bool
    func fetchAllReminders() -> [Reminder]
    func deleteReminder(by id: UUID) -> Bool
    func deleteAllReminders() -> Bool
    func fetchRemindersSortedByTimestamp() -> [Reminder]
    func fetchReminder(by id: UUID) -> Reminder?
}
