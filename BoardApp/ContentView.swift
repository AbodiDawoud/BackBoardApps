//
//  ContentView.swift
//  BoardApp
    

import SwiftUI

struct ContentView: View {
    private var viewModel = AppViewModel()
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                SidebarView()
                    .frame(minWidth: 275)
                    .environment(viewModel)
            },
            detail: {
                if let app = viewModel.selectedApp {
                    DetailContentView(app: app)
                        .environment(viewModel)
                } else {
                    EmptyDetailView()
                }
            }
        )
        .background(windowBackgroundView)
        .navigationSplitViewStyle(.balanced)
        .preferredColorScheme(.dark)
        .onAppear {
            let window = NSApplication.shared.windows.first!
            window.standardWindowButton(.zoomButton)?.isEnabled = false
            window.standardWindowButton(.zoomButton)?.isHidden = true
        }
    }
    
    var windowBackgroundView: some View {
        ZStack {
            // Base dark background
            Color(nsColor: .black.withAlphaComponent(0.9))
            
            // Subtle gradient overlay
            LinearGradient(
                colors: [
                    Color(nsColor: .systemPurple.withAlphaComponent(0.03)),
                    Color(nsColor: .systemBlue.withAlphaComponent(0.02)),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Material blur effect
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
                .opacity(0.6)
        }
        .ignoresSafeArea()
    }
}
