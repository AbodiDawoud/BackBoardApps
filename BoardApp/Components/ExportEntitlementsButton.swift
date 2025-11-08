//
//  ExportEntitlementsButton.swift
//  BoardApp
    

import SwiftUI

struct ExportEntitlementsButton: View {
    let app: InstalledApp
    @State private var isHovered = false
    
    var body: some View {
        Button(action: exportEntitlements) {
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    
                Text("Export")
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(
                        Color.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
            .shadow(color: isHovered ? Color.blue.opacity(0.4) : .clear, radius: 8, y: 2)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            hovering ? NSCursor.pointingHand.push() : NSCursor.pop()
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
    
    private func exportEntitlements() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.propertyList, .xml, .json]
        panel.nameFieldStringValue = "\(app.displayName)-entitlements.plist"
        panel.canCreateDirectories = true
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    // Export as plist
                    let plistData = try PropertyListSerialization.data(
                        fromPropertyList: app.entitlements,
                        format: .xml,
                        options: 0
                    )
                    
                    try plistData.write(to: url)
                } catch {
                    print("Failed to export entitlements: \(error)")
                }
            }
        }
    }
}
