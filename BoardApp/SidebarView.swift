//
//  SidebarView.swift
//  BoardApp
    

import SwiftUI

struct SidebarView: View {
    @Environment(AppViewModel.self) var viewModel
    
    
    var body: some View {
        VStack(spacing: 0) {
            CustomTitleBar()
            
            // Apps List
            ScrollView {
                LazyVStack(spacing: 3) {
                    ForEach(viewModel.filteredApps) { app in
                        ApplicationRowView(
                            app: app,
                            isSelected: viewModel.selectedApp?.id == app.id
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                viewModel.selectedApp = app
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
        }
        .background(
            // Sidebar gradient background
            LinearGradient(
                colors: [
                    Color(nsColor: .black.withAlphaComponent(0.4)),
                    Color(nsColor: .black.withAlphaComponent(0.6))
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}



struct CustomTitleBar: View {
    @Environment(AppViewModel.self) var vm
    
    var searchTextBinding: Binding<String> {
        .init {
            return vm.searchQuery
        } set: {
            vm.searchQuery = $0
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("Font Board Apps")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                Spacer()
                

                HStack(spacing: 4) {
                    SourceTypeButton(systemName: "app.stack", isSelected: vm.sourceType == .all) {
                        vm.sourceType = .all
                    }
                    
                    SourceTypeButton(systemName: "apple.logo.pin.point.of.interest", isSelected: vm.sourceType == .system) {
                        vm.sourceType = .system
                    }
                    
                    SourceTypeButton(systemName: "appstore", isSelected: vm.sourceType == .user) {
                        vm.sourceType = .user
                    }
                }
            }
            
            // Search Bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                
                TextField("Search apps...", text: searchTextBinding)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
                
                
                if !vm.searchQuery.isEmpty {
                    Button {
                        withAnimation {
                            vm.searchQuery = ""
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(16)
    }
}



fileprivate struct SourceTypeButton: View {
    let systemName: String
    let isSelected: Bool
    @State private var isHovered = false
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Image(_internalSystemName: systemName)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(isSelected ? AnyShapeStyle(.background) : AnyShapeStyle(.primary))
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(
                            isSelected ?
                                Color.primary :
                                (isHovered ? Color.white.opacity(0.05) : Color.clear)
                        )
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}
