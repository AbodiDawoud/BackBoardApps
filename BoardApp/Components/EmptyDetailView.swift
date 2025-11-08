//
//  EmptyDetailView.swift
//  BoardApp
    

import SwiftUI


struct EmptyDetailView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "shield.lefthalf.filled")
                .font(.system(size: 44, weight: .light))
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
                Text("No App Selected")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Select an app from the sidebar to view its entitlements")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
