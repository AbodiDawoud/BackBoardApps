//
//  NoEntitlementsView.swift
//  BoardApp
    

import SwiftUI

struct NoEntitlementsView: View {
    let hasSearchText: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: hasSearchText ? "magnifyingglass" : "exclamationmark.shield")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(nsColor: .labelColor),
                            Color(nsColor: .tertiaryLabelColor)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 6) {
                Text(hasSearchText ? "No Results" : "No Entitlements")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(hasSearchText ? "Try a different search term" : "This app has no entitlements")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
