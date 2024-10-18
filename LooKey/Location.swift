import Foundation
import MapKit

enum BathroomType {
    case freePublic
    case verifiedCode
    case unverifiedCode
    case rotatingCodeOrPurchaseRequired
}

// Updated Location model
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let businessIdentifier: String
    let coordinate: CLLocationCoordinate2D
    let bathroomCode: String
    let description: String
    let bathroomType: BathroomType // New field for bathroom type
}
