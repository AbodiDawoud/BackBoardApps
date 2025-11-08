//
//  AppListRow.swift
//  BoardApp
    

import SwiftUI

struct ApplicationRowView: View {
    let app: InstalledApp
    let isSelected: Bool
    
    
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
                .fill(isSelected ? .gray.opacity(0.1) : .white.opacity(0.0001))
        )
        .overlay(alignment: .leading) {
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.shadow(.drop(radius: 5)))
                    .frame(maxWidth: 3, maxHeight: 25)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .contextMenu {
            Button("Launch Application", action: app.launch)
            Button("Reveal in Finder") {
                NSWorkspace.shared.selectFile(app.bundlePath, inFileViewerRootedAtPath: "")
            }
            
            Divider()
            
            Button("Copy Bundle Identifier") { copy(app.bundleIdentifier) }
            Button("Copy Bundle Path") { copy(app.bundlePath) }
        }
        .onLongPressGesture(minimumDuration: 0.75, perform: app.launch)
    }
    
    func copy(_ item: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item, forType: .string)
    }
}
