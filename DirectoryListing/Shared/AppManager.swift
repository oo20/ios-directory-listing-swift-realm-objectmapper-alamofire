//
//  AppManager.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import RealmSwift
import STXImageCache

class AppManager: NSObject {
    static private var appManager: AppManager? = nil

    static public let baseURL = "http://localhost:8080/api/"
    
    static public let imageCompression : CGFloat = 95
    
    public var webService: WebService
    
    override init() {
        self.webService = WebService()
    }
    
    static func shared() -> AppManager {
        if (AppManager.appManager == nil) {
            AppManager.appManager = AppManager()
            AppManager.appManager?.clearDataIfNeeded()
            
            AppManager.appManager?.initImageCache()
        }
        
        return AppManager.appManager!
    }
    
    func initImageCache() {
        var diskConfig = STXDiskCacheConfig()
        diskConfig.enabled = true
        diskConfig.cacheExpirationTime = 7 // in days, 0 = never (dependent on iOS)
        STXCacheManager.shared.diskCacheConfig = diskConfig
        
        var memoryConfig = STXMemoryCacheConfig()
        
        memoryConfig.enabled = true
        memoryConfig.maximumMemoryCacheSize = 0 // in megabytes, 0 = unlimited
        STXCacheManager.shared.memoryCacheConfig = memoryConfig
    }
    
    static func decodeURL(_ text: String) -> String {
        guard let decodedURL = text.base64Decoded() else {
            return baseURL
        }
        
        guard let url = decodedURL.base64Decoded() else {
            return decodedURL
        }
        
        return url
    }
    
    func setLastAppVersion() {
        let defaults = UserDefaults.standard
        defaults.set(getAppVersion(), forKey: "AppVersion")
    }
    
    func getLastAppVersion() -> String? {
        let defaults = UserDefaults.standard
        
        guard let version = defaults.string(forKey: "AppVersion") else {
            return nil
        }
        
        return version
    }
    
    
    func getAppVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        
        return "\(version) build \(build)"
    }
    
    func clearData() {
        do {
            let realm = try Realm()
            
            realm.beginWrite()
            
            realm.deleteAll()
            
            try realm.commitWrite()
            
        } catch let error {
            DLog("Realm clear data error \(error)")
        }
    }
    
    func clearDataIfNeeded() {
        if (getAppVersion() != getLastAppVersion()) {
            clearDataFiles()
        }
        
        setLastAppVersion()
    }
    
    func clearImageCache() {
        STXCacheManager.shared.clearCache()
    }
    
    func clearDataFiles() {
        guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else {
            return
        }
        
        STXCacheManager.shared.clearCache()
        
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        
        for url in realmURLs {
            
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                DLog("Attempting to delete database at: \(url.absoluteString)")
            }
        }
    }
    
    func authenticated() -> Bool {
        return true // TODO: For future auth
    }
}
