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
    dynamic var firstName: String? = ""
    dynamic var lastName: String? = ""
    dynamic var birthdate: String? = ""
    dynamic var profilePicture: String? = ""
    dynamic var affiliation: String? = ""
    var forceSensitive = RealmOptional<Bool>()
    
    dynamic var realmLoadedProfileImageData: Data? = nil
    private var loadedProfileImage: UIImage?
    
    var id : String { // Needed for primary key
        get {
            return "\(lastName!)-\(firstName!)-\(birthdate!)!"
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
        return self.birthdate?.friendlyDate()
    }
    
    func friendlyAffiliation() -> String? {
        return affiliation?.replacingOccurrences(of: "_", with: " ").lowercased().localizedCapitalized
    }
    
    func debugText() -> String {
        assert(self.firstName != nil)
        assert(self.lastName != nil)
        assert(self.birthdate != nil)
        assert(self.profilePicture != nil)
        assert(self.affiliation != nil)

        return "\(self.firstName!) \(self.lastName!) \(self.birthdate!) \(self.profilePicture!) \(self.forceSensitive) \(self.affiliation!)"
    }
    
    func preloadImage(finished: @escaping ClosureFinished) {
        if (self.realmLoadedProfileImageData != nil) {
            DLog("loaded image file from database with key: \(self.id)")
            self.loadedProfileImage = UIImage(data: self.realmLoadedProfileImageData!)
            finished()
            return
        }
        self.getImage(url: profilePicture!) { (image) in
            self.loadedProfileImage = image
            let realm = try! Realm()
            try! realm.write {
                if (image != nil) {
                    self.realmLoadedProfileImageData = UIImagePNGRepresentation(image!)
                } else {
                    self.realmLoadedProfileImageData = nil
                }
            }
            finished()
        }
    }
    
    func profileImage() -> UIImage?
    {
        guard (loadedProfileImage != nil) else { return nil }
        
        let size = CGSize(width: 100.0, height: 100.0)
        let imageFilter = AspectScaledToFillSizeCircleFilter(size: size)
        return imageFilter.filter(loadedProfileImage!)
    }
    
    func profileDetailImage() -> UIImage?
    {
        guard (loadedProfileImage != nil) else { return nil }
        
        let imageFilter = RoundedCornersFilter(radius: 10)
        
        return imageFilter.filter(loadedProfileImage!)
    }
}
