//
//  BathroomSymbolView.swift
//  LooKey
//
//  Created by Mark Raj on 10/9/24.
//


import SwiftUI

// New component to handle bathroom type symbols
struct BathroomSymbolView: View {
    var bathroomType: BathroomType

    var body: some View {
        getSymbolForType(bathroomType)
            .font(.title) // You can adjust the font size or styling here
    }

    // Function to return the symbol based on bathroom type
    @ViewBuilder
    private func getSymbolForType(_ type: BathroomType) -> some View {
        switch type {
        case .freePublic:
            Image(systemName: "toilet.fill")
                .foregroundColor(.green)
        case .verifiedCode:
            ZStack {
                Image(systemName: "key.fill")
                    .foregroundColor(.yellow)
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .offset(x: 8, y: -8)
                    .font(.system(size: 16)) // Adjust size and positioning of the checkmark
            }
        case .unverifiedCode:
            ZStack {
                Image(systemName: "key.fill")
                    .foregroundColor(.yellow)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .offset(x: 8, y: -8)
                    .font(.system(size: 16)) // Adjust size and positioning of the exclamation mark
            }
        case .rotatingCodeOrPurchaseRequired:
            Image(systemName: "lock.fill")
                .foregroundColor(.red)
        }
    }
}
