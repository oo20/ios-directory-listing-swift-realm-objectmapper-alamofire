//
//  IndividualDetailController.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit

class IndividualDetailController: UIViewController {
    
    @IBOutlet var personImageView: UIImageView?
    @IBOutlet var fullNameLabel: UILabel?
    @IBOutlet var birthDateLabel: UILabel?
    @IBOutlet var affiliationLabel: UILabel?
    
    var individual : Individual?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let tempIndividual = individual else {
            DLog("Individual must be set for individual detail controller.")
            return
        }
        
        guard let tempFullNameLabel = fullNameLabel, let tempBirthDateLabel = birthDateLabel, let tempAffiliationLabel = affiliationLabel else {
            DLog("All IBOutlets must be set for the individual detail controller.")
            return
        }
        
        tempFullNameLabel.text = "Name: \(tempIndividual.firstName) \(tempIndividual.lastName)"
        tempBirthDateLabel.text = "Born: " + tempIndividual.friendlyBirthdate()
        tempAffiliationLabel.text = "Affiliation: " + tempIndividual.friendlyAffiliation()

        personImageView!.image = nil
        
        individual!.preloadImage { () in
            self.personImageView!.image = self.individual!.profileDetailImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
