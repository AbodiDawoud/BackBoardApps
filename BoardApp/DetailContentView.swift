//
//  DetailContentView.swift
//  BoardApp
    

import SwiftUI


struct DetailContentView: View {
    let app: InstalledApp
    @State private var searchText: String = ""

    var filteredEntitlements: [String: Any] {
        let dict = app.entitlements as? [String: Any] ?? [:]
        
        if searchText.isEmpty { return dict }
        
        let filtered = dict.filter {
            $0.key.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered
    }

    var body: some View {
        VStack(spacing: 0) {
            DetailHeaderView(app: app, searchText: $searchText)
            
            Divider().background(Color.white.opacity(0.1))

            if filteredEntitlements.isEmpty {
                NoEntitlementsView(hasSearchText: !searchText.isEmpty)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(filteredEntitlements.keys.sorted(), id: \.self) {
                            EntitlementNodeView(key: $0, value: filteredEntitlements[$0])
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.visible)
            }
        }
    }
}



struct EntitlementNodeView: View {
    let key: String
    let value: Any

    var body: some View {
        Group {
            if let dict = value as? NSDictionary {
                let dictSwift = dict as? [String: Any] ?? [:]
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(dictSwift.keys.sorted(), id: \.self) { subKey in
                            if let subValue = dictSwift[subKey] {
                                EntitlementNodeView(key: subKey, value: subValue)
                                    .padding(.leading, 16)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.accentColor)
                        
                        Text("\(key) (\(dict.count) items)")
                    }
                }
            } else if let array = value as? [Any] {
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(array.enumerated()), id: \.offset) { index, item in
                            EntitlementNodeView(key: "[\(index)]", value: item)
                                .padding(.leading, 16)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "list.bullet.rectangle")
                            .foregroundColor(.accentColor)
                        
                        Text("\(key) (\(array.count))")
                    }
                }
            } else {
                HStack {
                    iconForValue(value)
                        .foregroundColor(.accentColor)
                    Text(key)
                    Spacer()
                    Text(stringValue(of: value))
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 2)
            }
        }
        .font(.system(size: 13, weight: .medium, design: .monospaced))
    }

    @ViewBuilder
    private func iconForValue(_ value: Any) -> some View {
        switch value {
        case let bool as Bool:
            boolenView(bool)
        case let num as NSNumber:
            if CFGetTypeID(num as CFTypeRef) == CFBooleanGetTypeID() {
                boolenView(num.boolValue)
            } else {
                Image(systemName: "number")
            }
        default: EmptyView()
        }
    }

    func boolenView(_ bool: Bool) -> some View {
        Circle()
            .fill(.tertiary)
            .overlay {
                Circle()
                    .fill(bool ? Color.green : Color.pink)
                    .padding(3)
            }
            .frame(width: 16)
    }
    
    private func stringValue(of value: Any) -> String {
        switch value {
        case let bool as Bool: return bool ? "true" : "false"
        case let num as NSNumber: return num.boolValue ? "true" : "false"
        default: return "\(value)"
        }
    }
}




struct DetailHeaderView: View {
    let app: InstalledApp
    @Binding var searchText: String

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Image(nsImage: app.bundleIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(app.displayName)
                        .font(.system(size: 18, weight: .semibold))

                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(app.bundleIdentifier, forType: .string)
                    } label: {
                        Text(app.bundleIdentifier)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 12) {
                        Label("\(app.entitlements.count)", systemImage: "key.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.blue)

                        Button {
                            NSWorkspace.shared.selectFile(app.bundlePath, inFileViewerRootedAtPath: "")
                        } label: {
                            Text(app.bundlePath)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary.opacity(0.8))
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                        .pointingHandOnHover()
                        .buttonStyle(.plain)
                    }
                }

                Spacer()
                EntitlementExportButton(app: app)
            }

            // Search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                TextField("Search entitlements...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
        .padding()
        .background(.ultraThinMaterial.opacity(0.3))
    }
}
