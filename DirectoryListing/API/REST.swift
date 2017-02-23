//
//  REST.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift

typealias ClosureIndividuals = (List<Individual>) -> ()

class REST: NSObject {
    
    func getObject<T:BaseEntity>(url: String, closureObject:@escaping (T?) -> ()) where T:BaseEntity{
        DLog("Get Object URL: \(url)")

        let urlObject : URL = URL(string: url)!
                
        Alamofire.request(urlObject).responseObject { (response: DataResponse<T>) in
            
            let object: T? = response.result.value
            
            guard (object != nil) else {
                closureObject(nil)
                return
            }
            
            closureObject(object)
            
        }
    }
}
