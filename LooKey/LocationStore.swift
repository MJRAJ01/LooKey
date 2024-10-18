//
//  to.swift
//  LooKey
//
//  Created by Mark Raj on 10/15/24.
//


import Foundation
import MapKit

// Define a class to manage locations
class LocationStore: ObservableObject {
    @Published var locations: [Location] = [
        Location(
            name: "Public Library",
            businessIdentifier: "Public Library, Boston, MA",
            coordinate: CLLocationCoordinate2D(latitude: 42.3499, longitude: -71.0781),
            bathroomCode: "",
            description: "Free public bathroom in the library.",
            bathroomType: .freePublic
        ),
        Location(
            name: "Starbucks",
            businessIdentifier: "Starbucks, 1400 Massachusetts Ave, Cambridge, MA",
            coordinate: CLLocationCoordinate2D(latitude: 42.3736, longitude: -71.1189),
            bathroomCode: "5678",
            description: "Verified bathroom code.",
            bathroomType: .verifiedCode
        ),
        Location(
            name: "Panera Bread",
            businessIdentifier: "Panera Bread, Boston, MA",
            coordinate: CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589),
            bathroomCode: "1234",
            description: "Unverified bathroom code.",
            bathroomType: .unverifiedCode
        ),
        Location(
            name: "McDonald's",
            businessIdentifier: "McDonald's, Boston, MA",
            coordinate: CLLocationCoordinate2D(latitude: 42.3487, longitude: -71.0823),
            bathroomCode: "",
            description: "Bathroom code rotates and requires a purchase.",
            bathroomType: .rotatingCodeOrPurchaseRequired
        )
    ]
}
