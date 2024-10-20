import SwiftUI
import MapKit
import ConfettiSwiftUI
import Combine

struct ContentView: View {
    @StateObject private var locationStore = LocationStore()
    @StateObject private var locationService = DeviceLocationService.shared
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var selectedLocation: Location? = nil
    @State private var showingDetailView = false
    @State private var showingAddLocationView = false
    @State private var confettiCounter = 0
    @State private var cancellable: AnyCancellable?

    let zoomThreshold: Double = 0.02

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locationStore.locations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                                BathroomSymbolView(bathroomType: location.bathroomType)
                                
                                if region.span.latitudeDelta < zoomThreshold {
                                    Text(location.name)
                                        .font(.caption)
                                        .padding(5)
                                        .background(
                                            Color(.systemBackground).opacity(0.8)
                                        )
                                        .foregroundColor(Color.primary)
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
                    .onAppear {
                        locationService.requestLocationUpdates()
                        cancellable = locationService.coordinatesPublisher
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { _ in }) { coordinate in
                                region.center = coordinate
                            }
                    }
                    .onDisappear {
                        cancellable?.cancel()
                    }

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
                            AddLocationView(locations: $locationStore.locations, currentRegion: region) {
                                confettiCounter += 1
                            }
                        }
                    }
                }
                .navigationTitle("LooKey")
            }

            if confettiCounter > -1 {
                ConfettiCannon(counter: $confettiCounter, num: 100, confettiSize: 10.0, rainHeight: 800, openingAngle: .degrees(0), closingAngle: .degrees(180), radius: 400)
                    .zIndex(1)
            }
        }
        .zIndex(0)
    }
}

// Preview for SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
