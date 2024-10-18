import SwiftUI
import MapKit
import ConfettiSwiftUI

struct ContentView: View {
    @StateObject private var locationStore = LocationStore()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Default zoom level
    )
    
    @State private var selectedLocation: Location? = nil
    @State private var showingDetailView = false
    @State private var showingAddLocationView = false
    @State private var confettiCounter = 0 // Confetti trigger for home screen

    // Zoom threshold for showing the labels
    let zoomThreshold: Double = 0.02 // Adjust this value for desired zoom level

    var body: some View {
        ZStack {
            // Main Content (Map, Add Location Button, and Navigation Title)
            NavigationView {
                ZStack {
                    // Map
                    Map(coordinateRegion: $region, annotationItems: locationStore.locations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                                // Custom pin for bathroom type
                                BathroomSymbolView(bathroomType: location.bathroomType)
                                
                                // Only show the business name if zoomed in beyond the threshold
                                if region.span.latitudeDelta < zoomThreshold {
                                    Text(location.name)
                                        .font(.caption)
                                        .padding(5)
                                        .background(
                                            Color(.systemBackground).opacity(0.8) // Adaptive bubble color
                                        )
                                        .foregroundColor(Color.primary) // Adaptive text color
                                        .cornerRadius(5)
                                }
                            }
                            .onTapGesture {
                                selectedLocation = location
                                showingDetailView = true
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .sheet(isPresented: $showingDetailView) {
                        if let selectedLocation = selectedLocation {
                            LocationDetailView(location: selectedLocation)
                        }
                    }

                    // Add Location Button
                    VStack {
                        Spacer()
                        Button(action: {
                            showingAddLocationView = true
                        }) {
                            Text("Add Location")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 30)
                        .sheet(isPresented: $showingAddLocationView) {
                            AddLocationView(locations: $locationStore.locations, currentRegion: region, onAddLocationSuccess: {
                                // Trigger confetti when the location is successfully added
                                confettiCounter += 1
                            })
                        }
                    }
                }
                .navigationTitle("LooKey")
            }

            // Confetti view to trigger celebrations
            if confettiCounter > -1 {
                ConfettiCannon(counter: $confettiCounter, num: 100, confettiSize: 10.0, rainHeight: 800, openingAngle: Angle.degrees(0), closingAngle: Angle.degrees(180), radius: 400)
                    .zIndex(1)
            }
        }
        .zIndex(0) // Main ZStack content at base layer
    }
}

// Preview for SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
