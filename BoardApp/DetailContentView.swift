//
//  DetailContentView.swift
//  BoardApp
    

import SwiftUI


struct DetailContentView: View {
    let app: InstalledApp
    
    @Environment(AppViewModel.self) var viewModel
    @State private var expandedKeys = Set<String>()
    
    private var flattenedEntitlements: [EntitlementItem] {
        flattenDictionary(app.entitlements, prefix: "", depth: 0)
    }
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with App Info and Actions
            DetailHeaderView(app: app, searchText: $searchText)
            
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            
            // Entitlements List
            if flattenedEntitlements.isEmpty {
                NoEntitlementsView(hasSearchText: !searchText.isEmpty)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(flattenedEntitlements) { item in
                            EntitlementRowView(
                                item: item,
                                isExpanded: expandedKeys.contains(item.key),
                                onToggleExpand: { toggleExpandedKey(for: item.key) }
                            )
                        }
                    }
                    .padding(16)
                }
                .scrollIndicators(.visible)
            }
        }
    }
    
    func toggleExpandedKey(for key: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if expandedKeys.contains(key) {
                expandedKeys.remove(key)
                return
            }
            
            expandedKeys.insert(key)
        }
    }
    
    
    // Recursively flatten NSDictionary into a list of EntitlementItems
    private func flattenDictionary(_ dict: NSDictionary, prefix: String, depth: Int) -> [EntitlementItem] {
        var items: [EntitlementItem] = []
        
        let sortedKeys = (dict.allKeys as? [String])?.sorted() ?? []
        
        for key in sortedKeys {
            let fullKey = prefix.isEmpty ? key : "\(prefix).\(key)"
            let value = dict[key] ?? NSNull()
            
            items.append(EntitlementItem(key: fullKey, value: value, depth: depth))
            
            // If expanded, add children
            if expandedKeys.contains(fullKey) {
                if let childDict = value as? NSDictionary {
                    items.append(contentsOf: flattenDictionary(childDict, prefix: fullKey, depth: depth + 1))
                } else if let childArray = value as? NSArray {
                    for (index, arrayValue) in childArray.enumerated() {
                        let arrayKey = "\(fullKey)[\(index)]"
                        items.append(EntitlementItem(key: arrayKey, value: arrayValue, depth: depth + 1))
                        
                        // Recursively expand array items if they're dictionaries
                        if expandedKeys.contains(arrayKey), let arrayDict = arrayValue as? NSDictionary {
                            items.append(contentsOf: flattenDictionary(arrayDict, prefix: arrayKey, depth: depth + 2))
                        }
                    }
                }
            }
        }
        
        return items
    }
}



struct DetailHeaderView: View {
    let app: InstalledApp
    @Binding var searchText: String
    
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Image(nsImage: app.bundleIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(app.displayName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Button {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(app.bundleIdentifier, forType: .string)
                    } label: {
                        Text(app.bundleIdentifier)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        Label("\(app.entitlements.allKeys.count)", systemImage: "key.fill")
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
                    }
                }
                
                Spacer()
                
                
                ExportEntitlementsButton(app: app)
            }
            
            // Search Bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                TextField("Search entitlements...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
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
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(16)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.15))
                .background(.ultraThinMaterial.opacity(0.3))
        )
    }
}



//struct EntitlementRow: View {
//    let item: EntitlementItem
//    let isExpanded: Bool
//    let onToggleExpand: () -> Void
//    @State private var isHovered = false
//    
//    var body: some View {
//        HStack(spacing: 8) {
//            // Indentation
//            if item.depth > 0 {
//                Spacer()
//                    .frame(width: CGFloat(item.depth * 20))
//            }
//            
//            // Expand/Collapse Icon (if has children)
//            if item.hasChildren {
//                Button(action: onToggleExpand) {
//                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
//                        .font(.system(size: 10, weight: .semibold))
//                        .foregroundColor(.secondary)
//                        .frame(width: 16)
//                        .contentTransition(.symbolEffect(.replace))
//                }
//                .buttonStyle(.plain)
//            } else {
//                Spacer()
//                    .frame(width: 16)
//            }
//            
//            // Entitlement Icon
//            Image(systemName: getIconForKey(item.key, value: item.value))
//                .font(.system(size: 13))
//                .foregroundStyle(getColorForValue(item.value))
//                .frame(width: 20)
//            
//            // Key-Value
//            VStack(alignment: .leading, spacing: 2) {
//                Text(item.key)
//                    .font(.system(size: 12, weight: .medium))
//                    .foregroundColor(.primary)
//                
//                if !item.hasChildren || isExpanded {
//                    Text(item.displayValue)
//                        .font(.system(size: 11, weight: .regular))
//                        .foregroundColor(.secondary)
//                        .lineLimit(1)
//                } else {
//                    Text("\(item.childrenCount) items")
//                        .font(.system(size: 11, weight: .regular))
//                        .foregroundColor(.blue.opacity(0.8))
//                }
//            }
//            
//            
//            Spacer()
//            
//            
//            CopyButton(text: item.key, value: item.displayValue)
//                .opacity(isHovered ? 1 : 0)
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .onHover { hovering in
//            withAnimation(.easeInOut(duration: 0.15)) {
//                isHovered = hovering
//            }
//        }
//    }
//    
//    private func getIconForKey(_ key: String, value: Any) -> String {
//        let lowercaseKey = key.lowercased()
//        
//        // Check value type first
//        if value is Bool || (value as? NSNumber)?.objCType.pointee == 99 { // 'c' is boolean
//            return "circle.fill"
//        }
//        
//        // Check key patterns
//        if lowercaseKey.contains("sandbox") { return "app.dashed" }
//        if lowercaseKey.contains("network") { return "network" }
//        if lowercaseKey.contains("files") || lowercaseKey.contains("download") { return "folder.fill" }
//        if lowercaseKey.contains("security") { return "lock.shield.fill" }
//        
//        if lowercaseKey.contains("camera") { return "camera.fill" }
//        if lowercaseKey.contains("microphone") { return "mic.fill" }
//        if lowercaseKey.contains("contacts") { return "person.crop.circle.fill" }
//        if lowercaseKey.contains("calendar") { return "calendar" }
//        if lowercaseKey.contains("photos") { return "photo.fill" }
//        if lowercaseKey.contains("location") { return "location.fill" }
//        
//        if value is NSDictionary { return "list.bullet.rectangle" }
//        if value is NSArray { return "list.bullet" }
//        
//        return "key.fill"
//    }
//    
//    private func getColorForValue(_ value: Any) -> Color {
//        if let bool = value as? Bool {
//            return bool ? .green : .red
//        } else if let number = value as? NSNumber {
//            if CFGetTypeID(number as CFTypeRef) == CFBooleanGetTypeID() {
//                return number.boolValue ? .green : .red
//            }
//        }
//        return .blue
//    }
//}



struct EntitlementRowView: View {
    let item: EntitlementItem
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    @State private var isHovered = false
    
    // Determine if this item is an array element (key contains [index])
    private var isArrayElement: Bool {
        item.key.contains("[") && item.key.contains("]")
    }
    
    // Extract just the array index or value identifier
    private var displayKey: String {
        if isArrayElement {
            // Extract content after the last bracket
            if let lastBracket = item.key.lastIndex(of: "["),
               let closeBracket = item.key.lastIndex(of: "]") {
                let startIndex = item.key.index(after: lastBracket)
                return String(item.key[startIndex..<closeBracket])
            }
        }
        
        // For regular keys, show only the last component
        return item.key
    }
    
    var body: some View {
        if isArrayElement {
            // Array element - simplified display
            arrayElementView
        } else {
            // Regular entitlement
            regularEntitlementView
        }
    }
    
    // MARK: - Array Element View (Simplified)
    private var arrayElementView: some View {
        HStack(spacing: 8) {
            // Indentation
            if item.depth > 0 {
                Spacer()
                    .frame(width: CGFloat(item.depth * 20))
            }
            
            // Array index bullet
            Text("[\(displayKey)]")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(.secondary.opacity(0.7))
                .frame(width: 40, alignment: .trailing)
            
            // Value only (no icon)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.displayValue)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Copy Button
            CopyButton(text: item.displayValue, value: item.displayValue)
                .opacity(isHovered ? 1 : 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isHovered ? Color.white.opacity(0.02) : Color.clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
    
    // MARK: - Regular Entitlement View
    private var regularEntitlementView: some View {
        HStack(spacing: 8) {
            // Indentation
            if item.depth > 0 {
                Spacer()
                    .frame(width: CGFloat(item.depth * 20))
            }
            
            // Expand/Collapse Icon (if has children)
            if item.hasChildren {
                Button(action: onToggleExpand) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 16)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
            } else {
                Spacer()
                    .frame(width: 16)
            }
            
            // Icon (only for important/root level entitlements)
            if shouldShowIcon {
                Image(systemName: getIconForKey(item.key, value: item.value))
                    .font(.system(size: 13))
                    .foregroundStyle(getColorForValue(item.value))
                    .frame(width: 20)
            } else {
                // Simple dot indicator for boolean values
                if item.value is Bool || isBooleanNumber(item.value) {
                    Circle()
                        .fill(getColorForValue(item.value))
                        .frame(width: 6, height: 6)
                        .frame(width: 20)
                } else {
                    Spacer()
                        .frame(width: 20)
                }
            }
            
            // Key-Value
            VStack(alignment: .leading, spacing: 2) {
                Text(displayKey)
                    .font(.system(size: 12, weight: item.depth == 0 ? .medium : .regular))
                    .foregroundColor(.primary)
                
                if !item.hasChildren || isExpanded {
                    Text(item.displayValue)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else {
                    Text("\(item.childrenCount) items")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.blue.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Copy Button
            CopyButton(text: item.key, value: item.displayValue)
                .opacity(isHovered ? 1 : 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
    

    private var shouldShowIcon: Bool {
        // Only show icons for root level or important security-related keys
        // Always show for dictionaries and arrays
        // Show for root level items (depth 0)
        return item.hasChildren || item.depth == 0
    }
    
    private func isBooleanNumber(_ value: Any) -> Bool {
        if let number = value as? NSNumber {
            return CFGetTypeID(number as CFTypeRef) == CFBooleanGetTypeID()
        }
        return false
    }
    
    // MARK: - Icon & Color Helpers
    
    private func getIconForKey(_ key: String, value: Any) -> String {
        let lowercaseKey = key.lowercased()
        
        // Type-based icons
        if value is NSDictionary { return "folder.fill" }
        if value is NSArray { return "list.bullet" }
        if value is Bool || isBooleanNumber(value) { return "circle.fill" }
        
        // Security patterns
        if lowercaseKey.contains("sandbox") { return "app.dashed" }
        if lowercaseKey.contains("network") { return "network" }
        if lowercaseKey.contains("files") || lowercaseKey.contains("download") { return "folder.fill" }
        if lowercaseKey.contains("security") { return "lock.shield.fill" }
        
        // Privacy patterns
        if lowercaseKey.contains("camera") { return "camera.fill" }
        if lowercaseKey.contains("microphone") { return "mic.fill" }
        if lowercaseKey.contains("contacts") { return "person.crop.circle.fill" }
        if lowercaseKey.contains("calendar") { return "calendar" }
        if lowercaseKey.contains("photos") { return "photo.fill" }
        if lowercaseKey.contains("location") { return "location.fill" }
        
        return "key.fill"
    }
    
    private func getColorForValue(_ value: Any) -> Color {
        if let bool = value as? Bool {
            return bool ? .green : .red
        } else if let number = value as? NSNumber {
            if CFGetTypeID(number as CFTypeRef) == CFBooleanGetTypeID() {
                return number.boolValue ? .green : .red
            }
        }
        return .blue
    }
}
