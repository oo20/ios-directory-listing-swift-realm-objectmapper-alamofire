//
//  AppManager.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import AlamofireImage

class AppManager: NSObject {
    static private var appManager: AppManager? = nil
    static public let baseURL = "YUhSMGNITTZMeTlsWkdkbExteGtjMk5rYmk1dmNtY3ZiVzlpYVd4bEwybHVkR1Z5ZG1sbGR5OD0=".base64Decoded().base64Decoded()
    
    public var webService: WebService
    public var imageCache = AutoPurgingImageCache()

    override init() {
        self.webService = WebService()
    }
    
    static func shared() -> AppManager {
        if (AppManager.appManager == nil) {
            AppManager.appManager = AppManager()
        }
        return AppManager.appManager!
    }
}
