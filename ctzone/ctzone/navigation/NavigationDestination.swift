import SwiftUI

protocol NavigationDestinationProtocol: Hashable {
    
    associatedtype DestinationView: View
    
    var title: String { get }
    
    @ViewBuilder
    var destinationView: DestinationView { get }
}

enum Destination: NavigationDestinationProtocol {
    case product(Product)
    case cart
    case profile
    case curut
    case searchDetail
    case search
    
    var title: String {
        switch self {
        case .product(let product):
            return product.name
        case .cart:
            return "Cart"
        case .profile:
            return "Profile"
        case .curut:
            return "Curut"
        case .searchDetail:
            return "Detel"
        case .search:
            return "Search"
        }
        
        
    }
    
    var destinationView: some View {
        switch self {
        case .product(let product):
            ProductDetailView(product: product)
        case .cart:
            CartView()
        case .profile:
            ProfileView()
        case .curut:
            CuruttView()
        case .searchDetail:
            SearchDetailView()
                .environmentObject(UserDefaultsManager.shared)
        case .search:
            SearchView()
        }
    }
}
