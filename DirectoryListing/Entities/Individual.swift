//
//  Individual.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm
import RealmSwift
import AlamofireImage

class Individual: BaseEntity {
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var birthdate: String = ""
    dynamic var profilePicture: String = ""
    dynamic var affiliation: String = ""
    var forceSensitive = RealmOptional<Bool>()
    
    private var loadedProfileImage: UIImage?
    private var loadedProfileThumbnailImage: UIImage?
    
    private var requestedLoad : Bool = false
    
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
        self.loadedProfileImage = nil
        self.loadedProfileThumbnailImage = nil
        self.requestedLoad = false
    }
    
    func preloadImage(checkIndex: Int, finished: @escaping ClosureIndexFinished) {
        
        if (loadedProfileImage != nil && loadedProfileThumbnailImage != nil) {
            DLog("image already loaded in memory for key: \(self.id)")
            
            finished(checkIndex)
            return
        }
        
        if (self.requestedLoad == true) {
            return
        }
        
        self.requestedLoad = true

        self.getImage(url: profilePicture) { (image) in
        
            self.loadedProfileImage = image
            
            self.loadedProfileImage = self.profileDetailImage()
            
            self.loadedProfileThumbnailImage = self.profileImage()
            
            if (image == nil || self.loadedProfileImage == nil || self.loadedProfileThumbnailImage == nil) {
                self.clearImage()
                return
            }
            
            DispatchQueue.main.async {
                finished(checkIndex)
            }
        }
        
        return
    }
    
    func profileImage() -> UIImage?
    {
        if (self.loadedProfileThumbnailImage != nil) {
            return self.loadedProfileThumbnailImage
        }
        
        guard let tempImage = loadedProfileImage else { return nil }
        
        let size = CGSize(width: 100.0, height: 100.0)
        let imageFilter = AspectScaledToFillSizeCircleFilter(size: size)
        
        return imageFilter.filter(tempImage)
    }
    
    func profileDetailImage() -> UIImage?
    {
        if (self.loadedProfileImage != nil) {
            return self.loadedProfileImage
        }
        
        guard let tempImage = loadedProfileImage else { return nil }
        
        let size = CGSize(width: 200.0, height: 200.0)
        let imageFilter = AspectScaledToFitSizeFilter(size: size)
        
        return imageFilter.filter(tempImage)
    }
}
