//
//  Models.swift
//  BoardApp
    

import AppKit

struct InstalledApp: Identifiable, Hashable {
    let id = UUID()
    let displayName: String
    let bundleIdentifier: String
    let bundlePath: String
    let executableURL: URL
    let entitlements: NSDictionary
    let preferenceDomain: String
    
    var bundleIcon: NSImage {
        NSWorkspace.shared.icon(forFile: bundlePath)
    }
}

enum ApplicationSourceFilter: CaseIterable {
    case system
    case user
    case all
    
    var localizedDescription: String {
        switch self {
        case .system:
            return "Apple Made Apps"
        case .user:
            return "User Installed Apps"
        case .all:
            return "All"
        }
    }
}

struct EntitlementItem: Identifiable {
    let key: String
    let value: Any
    let depth: Int
    
    var id: String { key }
    
    var displayValue: String {
        if value is NSNull { return "null" }
        if value is NSString { return "\"\(value)\"" }
        
        switch value {
        case let dict as NSDictionary:
            return "Dictionary (\(dict.count) items)"
            
        case let array as NSArray:
            return "Array (\(array.count) items)"
            
        case let bool as Bool:
            return bool ? "true" : "false"
            
        case let number as NSNumber:
            if CFGetTypeID(number as CFTypeRef) == CFBooleanGetTypeID() {
                return number.boolValue ? "true" : "false"
            }
            return "\(number)"
            
        default: return "\(value)"
        }
    }
    
    var hasChildren: Bool {
        switch value {
        case let dict as NSDictionary where dict.count > 0: return true
        case let array as NSArray where array.count > 0: return true
        default: return false
        }
    }
    
    var childrenCount: Int {
        switch value {
        case let dict as NSDictionary: return dict.count
        case let array as NSArray: return array.count
        default: return 0
        }
    }
}

//CFBundleGetPackageInfoInDirectory
