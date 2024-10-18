import SwiftUI

struct LocationDetailView: View {
    var location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Name and symbol
            HStack(alignment: .center) {
                Text(location.name)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure text is aligned to the left
                
                // Call the BathroomSymbolView component
                BathroomSymbolView(bathroomType: location.bathroomType)
                    .frame(alignment: .leading) // Align the symbol to the left
            }
            .padding(.bottom, 10)
            
            // Bathroom code (if it exists)
            if !location.bathroomCode.isEmpty {
                HStack(alignment: .center) {
                    Text("Bathroom Code:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    Text(location.bathroomCode)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue) // Distinct color for the code
                        .frame(maxWidth: .infinity, alignment: .leading) // Align code to the left
                }
            }
            
            // Description (if it exists)
            if !location.description.isEmpty {
                Text(location.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align description to the left
            }

            Spacer() // Ensure content stays at the top but allows the rest to fill the screen
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Ensure entire view is flush left
        .background(Color(.systemBackground)) // Adapt to dark and light mode
        .cornerRadius(20, corners: [.topLeft, .topRight]) // Rounded top corners
        .shadow(radius: 10)
        .edgesIgnoringSafeArea(.all) // Extend to screen edges
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
