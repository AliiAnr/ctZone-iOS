import SwiftUI
import CoreData

final class Injection {
    static let shared = Injection()
    
    let locationViewModel: LocationViewModel
    
    private init() {
        let context = PersistenceController.shared.container.viewContext
        let repository = LocationRepository(context: context)
        repository.addDummyLocationsIfNeeded()
        locationViewModel = LocationViewModel(repository: repository)
    }
}
