//
//  AppListRow.swift
//  BoardApp
    

import SwiftUI

struct ApplicationRowView: View {
    let app: InstalledApp
    let isSelected: Bool
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 11) {
            Image(nsImage: app.bundleIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
            
            // App Info
            VStack(alignment: .leading, spacing: 2) {
                Text(app.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(app.bundleIdentifier)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    isSelected ?
                        Color.gray.opacity(0.1) :
                        (isHovered ? Color.gray.opacity(0.06) : Color.clear)
                )
        )
        .overlay(alignment: .leading) {
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.shadow(.drop(radius: 5)))
                    .frame(maxWidth: 3, maxHeight: 25)
            }
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering && !isSelected
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .contextMenu {
            Button("Open Application") {
                NSWorkspace.shared.openApplication(
                    at: URL(fileURLWithPath: app.bundlePath),
                    configuration: .init()
                )
            }
            Button("Reveal in Finder") {
                NSWorkspace.shared.selectFile(app.bundlePath, inFileViewerRootedAtPath: "")
            }
            
            Divider()
            
            Button("Copy Bundle Identifier") { copy(app.bundleIdentifier) }
            Button("Copy Bundle Path") { copy(app.bundlePath) }
        }
    }
    
    func copy(_ item: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item, forType: .string)
    }
}
