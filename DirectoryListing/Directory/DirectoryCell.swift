//
//  DirectoryCell.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DirectoryCell: UITableViewCell {
    
    @IBOutlet var personImageView: UIImageView?
    
    var individual : Individual?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayData() {
        assert(individual != nil)
        guard (individual!.profilePicture != nil) else {
            DLog("Individual has no profile picture.")
            return
        }
        self.personImageView!.image = nil
        self.personImageView!.isHidden = true
        
        individual?.preloadImage(finished: { () in
            self.personImageView!.image = self.individual!.profileImage()
            self.personImageView!.isHidden = false
        })
    }
    
}
