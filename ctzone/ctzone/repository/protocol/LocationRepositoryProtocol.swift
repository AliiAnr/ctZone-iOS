import Foundation

protocol LocationRepositoryProtocol {
    func fetchLocations() -> [LocationEntity]
    func addDummyLocationsIfNeeded()
    func fetchLocation(by id: UUID) -> LocationEntity?
    func updatePinStatus(for locationId: UUID, pinned: Bool)
    func deleteLocation(withId id: UUID)
}
