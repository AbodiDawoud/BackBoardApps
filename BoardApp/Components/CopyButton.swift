//
//  CopyButton.swift
//  BoardApp
    

import SwiftUI

struct CopyButton: View {
    let text: String
    let value: String
    
    @State private var showCopied = false
    
    var body: some View {
        Button(action: copyToClipboard) {
            Image(systemName: showCopied ? "checkmark" : "capsule.on.capsule")
                .font(.system(size: 12))
                .foregroundColor(showCopied ? .green : .secondary)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .pointingHandOnHover()
        .help("Copy to clipboard")
    }
    
    private func copyToClipboard() {
        if showCopied { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString("\(text) = \(value)", forType: .string)
        
        withAnimation {
            showCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopied = false
            }
        }
    }
}
