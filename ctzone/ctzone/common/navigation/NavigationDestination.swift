import SwiftUI

protocol NavigationDestinationProtocol: Hashable {
    associatedtype DestinationView: View
    var title: String { get }
    
    @ViewBuilder
    var destinationView: DestinationView { get }
}

enum Destination: NavigationDestinationProtocol {
    case profile
    case searchDetail(UUID)
    case search
    case test
    
    var title: String {
        switch self {
        case .profile:
            return "Profile"
        case .searchDetail(_):
            return "Search Detail"
        case .search:
            return "Search"
            
        case .test:
            return "Test"
        }
    }
    
    var destinationView: some View {
        switch self {
        case .profile:
            ProfileView()
        case .searchDetail(let locationId):
            SearchDetailView(locationId: locationId)
                .environmentObject(Injection.shared.locationViewModel)
                .environmentObject(UserDefaultsManager.shared)
        case .search:
            SearchView()
            
        case .test:
            Test()
        }
    }
}
