//
//  BoardApp.swift
//  BoardApp
    

import SwiftUI


@main
struct BoardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}

extension View {
    func pointingHandOnHover() -> some View {
        self.onHover {
            $0 ? NSCursor.pointingHand.push() : NSCursor.pop()
        }
    }
}
