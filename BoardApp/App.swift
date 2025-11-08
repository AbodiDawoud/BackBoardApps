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

#Preview {
    Circle()
        .fill(.quaternary)
        .overlay {
            Circle()
                .fill(Color.green.gradient)
                .padding(3)
        }
        .frame(width: 16)
        .padding(30)
}
