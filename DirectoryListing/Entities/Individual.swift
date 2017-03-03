//
//  Individual.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage
import Realm
import RealmSwift

class Individual: BaseEntity {
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var birthdate: String = ""
    dynamic var profilePicture: String = ""
    dynamic var affiliation: String = ""
    var forceSensitive = RealmOptional<Bool>()
    
    dynamic var realmLoadedProfileImageData: Data? = nil
    private var loadedProfileImage: UIImage?
    
    var id : String { // Needed for primary key
        get {
            return "\(lastName)-\(firstName)-\(birthdate)"
        }
        set {
            // Do nothing
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        birthdate <- map["birthdate"]
        profilePicture <- map["profilePicture"]
        forceSensitive <- map["forceSensitive"]
        affiliation <- map["affiliation"]
    }
    
    func friendlyBirthdate() -> String? {
        return self.birthdate.friendlyDate()
    }
    
    func friendlyAffiliation() -> String {
        return affiliation.replacingOccurrences(of: "_", with: " ").lowercased().localizedCapitalized
    }
    
    func debugText() -> String {
        return "\(self.firstName) \(self.lastName) \(self.birthdate) \(self.profilePicture) \(self.forceSensitive) \(self.affiliation)"
    }
    
    func clearImage() {
        self.realmLoadedProfileImageData = nil
    }
    
    func preloadImage(finished: @escaping ClosureFinished) {
        
        if (realmLoadedProfileImageData != nil) {
            DLog("loaded image file from database with key: \(self.id)")
            
            self.loadedProfileImage = self.convertDataToUIImage(realmLoadedProfileImageData)
            
            finished()
            
            return
        }
        
        self.getImage(url: profilePicture) { (image) in
            self.loadedProfileImage = image
            
            guard let returnImage = image else {
                self.clearImage()
                return
            }
            
            do {
                let realm = try Realm()
                
                try realm.write {
                    self.realmLoadedProfileImageData = UIImagePNGRepresentation(returnImage)
                }
                
            } catch let error {
                DLog("Realm write profile image error \(error)")
                return
            }
            
            
            finished()
        }
        return

    }
    
    func profileImage() -> UIImage?
    {
        guard let tempImage = loadedProfileImage else { return nil }
        
        let size = CGSize(width: 100.0, height: 100.0)
        let imageFilter = AspectScaledToFillSizeCircleFilter(size: size)
        
        return imageFilter.filter(tempImage)
    }
    
    func profileDetailImage() -> UIImage?
    {
        guard let tempImage = loadedProfileImage else { return nil }
        
        let imageFilter = RoundedCornersFilter(radius: 10)
        
        return imageFilter.filter(tempImage)
    }
}
