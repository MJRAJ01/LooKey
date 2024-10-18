import SwiftUI
import MapKit

// Delegate class to handle MKLocalSearchCompleter results
class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var onResultsUpdate: ([MKLocalSearchCompletion]) -> Void
    
    init(onResultsUpdate: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.onResultsUpdate = onResultsUpdate
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onResultsUpdate(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer failed with error: \(error.localizedDescription)")
    }
}
import SwiftUI
import MapKit

struct AddLocationView: View {
    @State private var address: String = ""
    @State private var bathroomCode: String = ""
    @State private var description: String = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var selectedSearchResult: MKLocalSearchCompletion? = nil
    @State private var currentRegion: MKCoordinateRegion
    @State private var selectedBathroomType: BathroomType = .freePublic // Default bathroom type

    @Binding var locations: [Location]
    @Environment(\.presentationMode) var presentationMode
    var onAddLocationSuccess: () -> Void // Closure to notify success

    private let searchCompleter = MKLocalSearchCompleter()
    @State private var completerDelegate: SearchCompleterDelegate?

    init(locations: Binding<[Location]>, currentRegion: MKCoordinateRegion, onAddLocationSuccess: @escaping () -> Void) {
        self._locations = locations
        self._currentRegion = State(initialValue: currentRegion)
        self.onAddLocationSuccess = onAddLocationSuccess
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Address search input
                    Section(header: Text("Location Details")) {
                        TextField("Start typing an address or location", text: $address, onEditingChanged: { isEditing in
                            if !address.isEmpty {
                                searchCompleter.queryFragment = address
                            }
                        })
                        
                        // Show search results
                        if !searchResults.isEmpty {
                            List(searchResults, id: \.self) { result in
                                Button(action: {
                                    address = result.title + ", " + result.subtitle
                                    selectedSearchResult = result
                                    searchResults.removeAll()
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(result.title)
                                        Text(result.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Icon-based bathroom type picker
                    Section(header: Text("Select Bathroom Type")) {
                        HStack(spacing: 30) {
                            BathroomTypeButton(type: .freePublic, selectedType: $selectedBathroomType)
                            BathroomTypeButton(type: .verifiedCode, selectedType: $selectedBathroomType)
                            BathroomTypeButton(type: .rotatingCodeOrPurchaseRequired, selectedType: $selectedBathroomType)
                        }
                    }
                    
                    // Show code input if necessary
                    if selectedBathroomType == .verifiedCode || selectedBathroomType == .rotatingCodeOrPurchaseRequired {
                        TextField("Bathroom Code", text: $bathroomCode)
                            .keyboardType(.numberPad)
                    }

                    // Optional description
                    TextField("Description", text: $description)

                    // Add Location button
                    Button(action: addLocation) {
                        Text("Add Location")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical)
                }
                .navigationTitle("Add New Location")
            }
        }
        .onAppear {
            completerDelegate = SearchCompleterDelegate { completions in
                searchResults = completions
            }
            searchCompleter.delegate = completerDelegate
            searchCompleter.resultTypes = [.pointOfInterest, .address]
            searchCompleter.region = currentRegion
        }
    }

    func addLocation() {
        guard let selectedSearchResult = selectedSearchResult else {
            print("No search result selected")
            return
        }

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = selectedSearchResult.title
        searchRequest.region = currentRegion

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, let mapItem = response.mapItems.first else {
                print("Error finding location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let coordinate = mapItem.placemark.coordinate
            let businessIdentifier = mapItem.name ?? address

            let newLocation = Location(
                name: businessIdentifier,
                businessIdentifier: "\(businessIdentifier), \(selectedSearchResult.subtitle)",
                coordinate: coordinate,
                bathroomCode: selectedBathroomType == .freePublic ? "" : bathroomCode,
                description: description,
                bathroomType: selectedBathroomType
            )

            locations.append(newLocation)

            // Trigger success closure to notify parent view
            onAddLocationSuccess()
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Dismiss the Add Location screen
            presentationMode.wrappedValue.dismiss()
        }
    }
}





struct BathroomTypeButton: View {
    var type: BathroomType
    @Binding var selectedType: BathroomType
    
    var body: some View {
        Button(action: {
            selectedType = type
        }) {
            VStack {
                BathroomSymbolView(bathroomType: type)
                    .font(.largeTitle)
                    .foregroundColor(selectedType == type ? .blue : .gray)
                Text(type.displayName)
                    .font(.caption)
                    .foregroundColor(selectedType == type ? .blue : .gray)
            }
            .padding()
            .background(selectedType == type ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle()) // Fixes selection issue
    }
}

extension BathroomType {
    var displayName: String {
        switch self {
        case .freePublic: return "Public"
        case .verifiedCode: return "Verified"
        case .rotatingCodeOrPurchaseRequired: return "Rotating"
        default: return "Unknown"
        }
    }
}
