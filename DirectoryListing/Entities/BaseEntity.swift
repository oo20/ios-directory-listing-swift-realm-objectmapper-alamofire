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
import AlamofireImage
import Cache
import CryptoSwift

typealias ClosureImageFinished = (UIImage?) -> ()
typealias ClosureIndexFinished = (Int) -> ()
typealias ClosureFinished = () -> ()

extension ImageDownloader {
    func downloadImage(_ urlRequest: URLRequestConvertible, completion: CompletionHandler?) {
        self.download(urlRequest, completion: completion)
    }
}

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
                
        let url : String = requestURL.absoluteString as String
        
        if let loadImage = (try? AppManager.shared().imageCache?.object(ofType: ImageWrapper.self, forKey: url.sha256()).image) {
            
            DLog("Fetched cached image: \(url)")
            closureImageFinished(loadImage)
        }
        
        AppManager.shared().webService.manager.request(requestURL, method: .get).responseImage { response in
            guard let image = response.result.value else {
                DLog("Failed to download image: \(url)")
                
                return
            }
            
            try? AppManager.shared().imageCache?.setObject(ImageWrapper(image: image), forKey: url.sha256())
            
            DLog("Downloaded new image and cached: \(url)")
            closureImageFinished(image)
        }
        
    }
}
