//
//  BaseEntity.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import Realm
import RealmSwift
import STXImageCache

typealias ClosureImageFinished = (UIImage?) -> ()
typealias ClosureIndexFinished = (Int) -> ()
typealias ClosureFinished = () -> ()


class BaseEntity: Object, Mappable {
    
    required init?(map: Map) {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    func mapping(map: Map) {
    }
    
    func convertDataToUIImage(_ data: Data?) -> UIImage? {
        guard let realImageData = data else {
            return nil
        }
        return UIImage(data: realImageData)
    }
    
    func getImage(url: String, forceRefresh: Bool = false, closureImageFinished: @escaping ClosureImageFinished) {
        guard let requestURL = URL(string: url) else {
            closureImageFinished(UIImage(named: "Missing"))
            return
        }
        
        STXCacheManager.shared.image(atURL: requestURL, forceRefresh: forceRefresh, progress: { (percentage) in
            
        }) { (imageData, error) in
            guard let image = self.convertDataToUIImage(imageData) else {
                return
            }
            DLog("fetch new or cached image: \(url)")
            closureImageFinished(image)
        }
        
    }
}
