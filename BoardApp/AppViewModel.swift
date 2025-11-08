//
//  AppViewModel.swift
//  BoardApp
    

import Foundation
import Observation


@Observable
class AppViewModel {
    var installedApps: [InstalledApp] = []
    var filteredApps: [InstalledApp] {
        filterApps(searchText: searchQuery, source: sourceType)
    }
    var selectedApp: InstalledApp?
    var iInstalledAppsCount: Int { installedApps.count }
    
    var searchQuery: String = ""
    var sourceType: ApplicationSourceFilter = .all
    

    
    init() {
        DispatchQueue.global(qos: .background).async {
            self.loadInstalledApps()
        }
    }
    
    
    private func loadInstalledApps() {
        let FBSApplicationLibrary = NSClassFromString("FBSApplicationLibrary") as! NSObject.Type
        let library = FBSApplicationLibrary.init()
        let allInstalledApplications = library.value(forKey: "allInstalledApplications") as! Array<NSObject>
        
        
        allInstalledApplications.forEach {
            let displayName = $0.value(forKey: "displayName") as! String
            let bundleIdentifier = $0.value(forKey: "bundleIdentifier") as! String
            let bundleURL = $0.value(forKey: "bundleURL") as! URL
            let executableURL = $0.value(forKey: "executableURL") as! URL
            let entitlements = $0.value(forKey: "entitlements") as! NSDictionary
            let preferenceDomain = $0.value(forKey: "preferenceDomain") as! String
            
            let app = InstalledApp(
                displayName: displayName,
                bundleIdentifier: bundleIdentifier,
                bundlePath: bundleURL.path().removingPercentEncoding!,
                executableURL: executableURL,
                entitlements: entitlements,
                preferenceDomain: preferenceDomain
            )
            
            installedApps.append(app)
        }
    }

    
    private func filterApps(searchText: String, source: ApplicationSourceFilter) -> [InstalledApp] {
        var filtered: [InstalledApp] = []
        
        switch source {
        case .system:
            filtered = installedApps.filter { $0.bundleIdentifier.hasPrefix("com.apple.") }
        case .user:
            filtered = installedApps.filter { !$0.bundleIdentifier.hasPrefix("com.apple.") }
        case .all:
            filtered = installedApps
        }
        

        if searchText.isEmpty {
            return filtered
        }
        
        return filtered.filter { app in
            app.displayName.localizedCaseInsensitiveContains(searchText) ||
            app.bundleIdentifier.localizedCaseInsensitiveContains(searchText)
        }
    }
}
