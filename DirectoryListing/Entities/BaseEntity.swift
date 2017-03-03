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

    func getImage(url: String, closureImageFinished: @escaping ClosureImageFinished) {
        let imageCache = AppManager.shared().imageCache

        guard let cachedImage = imageCache.image(withIdentifier: url) else {
            
            Alamofire.request(url).responseImage { response in
                guard let tempImage = response.result.value else {
                    DLog("image failed to downloaded: \(url)")
                    closureImageFinished(nil)
                    return
                }

                DLog("image downloaded: \(url)")
                imageCache.add(tempImage, withIdentifier: url)
                closureImageFinished(tempImage)
            };
            
            return
        }

        closureImageFinished(cachedImage)
    }
}
