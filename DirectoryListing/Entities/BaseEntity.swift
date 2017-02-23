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
import AlamofireImage
import Realm
import RealmSwift

typealias ClosureImageFinished = (UIImage?) -> ()
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

    func getImage(url: String, closureImageFinished: @escaping ClosureImageFinished) {
        let imageCache = AppManager.shared().imageCache
        let cachedImage = imageCache.image(withIdentifier: url)
        
        if (cachedImage != nil) {
            closureImageFinished(cachedImage!)
            return
        }
        
        Alamofire.request(url).responseImage { response in
            let tempImage = response.result.value
            if tempImage != nil {
                DLog("image downloaded: \(url)")
                imageCache.add(tempImage!, withIdentifier: url)
                closureImageFinished(tempImage!)
                return
            }
            DLog("image failed to downloaded: \(url)")
            closureImageFinished(nil)
        };
    }
}
