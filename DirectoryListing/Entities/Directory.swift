//
//  Directory.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Directory: BaseEntity {
    var individuals : List<Individual>? = List<Individual>()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        individuals <- (map["individuals"], ListTransform<Individual>())

    }

}
