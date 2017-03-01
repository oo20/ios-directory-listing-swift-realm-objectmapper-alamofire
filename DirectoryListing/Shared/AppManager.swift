//
//  AppManager.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class AppManager: NSObject {
    static private var appManager: AppManager? = nil

    static public let baseURL = AppManager.decodeURL("YUhSMGNITTZMeTlsWkdkbExteGtjMk5rYmk1dmNtY3ZiVzlpYVd4bEwybHVkR1Z5ZG1sbGR5OD0=")
    
    public var webService: WebService
    public var imageCache = AutoPurgingImageCache()

    
    override init() {
        self.webService = WebService()
    }
    
    static func shared() -> AppManager {
        if (AppManager.appManager == nil) {
            AppManager.appManager = AppManager()
            AppManager.appManager?.clearRealmIfNeeded()
        }
        
        return AppManager.appManager!
    }
    
    static func decodeURL(_ text: String) -> String {
        guard let decodedURL = text.base64Decoded() else {
            return ""
        }
        
        guard let url = decodedURL.base64Decoded() else {
            return ""
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
    
    
    func clearRealmIfNeeded() {
        if (getAppVersion() != getLastAppVersion()) {
            
            guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else {
                return
            }
            
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
        
        setLastAppVersion()
    }
}
