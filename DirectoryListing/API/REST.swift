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

class REST: NSObject {
    
    var user = AppManager.user
    var password = AppManager.password
    
    public var manager: Alamofire.SessionManager = Alamofire.SessionManager()
    
    override init() {
        super.init()
        
        manager = AppManager.allowInvalidCert == true ? SessionManagerBuilder.sessionManagerAllowInvalidCerts() : SessionManagerBuilder.sessionManagerAllowOnlyValidCerts()
    }
    
    private func requestObject<T:BaseEntity>(url: String, method: HTTPMethod, parameters: Parameters? = nil, closureObject:@escaping (T?) -> ()) where T:BaseEntity{
        
        let urlObject : URL = URL(string: url)!
        
        let encoding : ParameterEncoding = JSONEncoding.default
        
        manager.request(urlObject, method: method, parameters: parameters, encoding: encoding)
            .authenticate(user: user, password: password)
            .responseObject { (response: DataResponse<T>) in
            
            guard let object: T = response.result.value else {
                closureObject(nil)
                return
            }
            
            closureObject(object)
        }
    }
    
    func getObject<T:BaseEntity>(url: String, closureObject:@escaping (T?) -> ()) where T:BaseEntity{
        DLog("Get Object URL: \(url)")
                
        self.requestObject(url: url, method: .get, closureObject: closureObject)
    }
    
    func postObject<T:BaseEntity>(url: String, dataObject: BaseEntity, closureObject:@escaping (T?) -> ()) where T:BaseEntity{
        DLog("Post Object URL: \(url)")
        
        let parameters : Parameters = dataObject.toJSON()
        
        self.requestObject(url: url, method: .post, parameters: parameters,  closureObject: closureObject)
    }
    
    func putObject<T:BaseEntity>(url: String, dataObject: BaseEntity, closureObject:@escaping (T?) -> ()) where T:BaseEntity{
        DLog("Put Object URL: \(url)")
        
        let parameters : Parameters = dataObject.toJSON()
        
        self.requestObject(url: url, method: .put, parameters: parameters, closureObject: closureObject)
    }
    
    func deleteObject<T:BaseEntity>(url: String, closureObject:@escaping (T?) -> ()) where T:BaseEntity{
        DLog("Delete Object URL: \(url)")
        
        self.requestObject(url: url, method: .delete, closureObject: closureObject)
    }
    
    func convertResultsToList<T:Mappable>(_ results: Results<T>) -> List<T> {
        
        let converted = results.reduce(List<T>()) { (list, element) -> List<T> in
            list.append(element)
            return list
        }
        
        return converted
    }
    
}
