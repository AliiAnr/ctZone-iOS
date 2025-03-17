import Foundation

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
