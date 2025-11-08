//
//  RevealInFinderButton.swift
//  BoardApp
    

import SwiftUI

struct RevealInFinderButton: View {
    let path: String
    @State private var isHovered = false
    
    var body: some View {
        Button(action: revealInFinder) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.8),
                            Color.gray.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.white.opacity(isHovered ? 0.08 : 0.04))
                )
        }
        .buttonStyle(.plain)
        .help("Reveal in Finder")
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
    
    private func revealInFinder() {
        NSWorkspace.shared.selectFile(path, inFileViewerRootedAtPath: "")
    }
}
