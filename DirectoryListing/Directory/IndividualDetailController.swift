//
//  IndividualDetailController.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import ObjectMapper

class IndividualDetailController: UIViewController {
    
    @IBOutlet var personImageView: UIImageView?
    @IBOutlet var fullNameLabel: UILabel?
    @IBOutlet var birthDateLabel: UILabel?
    @IBOutlet var affiliationLabel: UILabel?
    
    @IBOutlet var fullNameTextField: UITextField?
    @IBOutlet var birthDateTextField: UITextField?
    @IBOutlet var affiliationTextField: UITextField?
    
    @IBOutlet var saveButton: UIButton?
    
    var individual : Individual?
    var individualIndex : Int = -1
    
    var directoryDelegate : DirectoryControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let tempIndividual = individual else {
            DLog("Individual must be set for individual detail controller.")
            return
        }
        
        fullNameTextField?.text = "\(tempIndividual.firstName) \(tempIndividual.lastName)"
        
        affiliationTextField?.text = tempIndividual.friendlyAffiliation()
        
        if (AppManager.shared().authenticated()) {
            fullNameTextField?.editing(true)
            birthDateTextField?.editing(true)
            affiliationTextField?.editing(true)
            saveButton?.isHidden = false
            
            birthDateTextField?.text = tempIndividual.birthdate
        } else {
            fullNameTextField?.disabled()
            birthDateTextField?.disabled()
            affiliationTextField?.disabled()
            saveButton?.isHidden = true
            
            birthDateTextField?.text = (tempIndividual.friendlyBirthdate() ?? "Unknown")
        }

        personImageView?.image = nil
        
        tempIndividual.preloadImage(checkIndex: self.individualIndex) { (returnedIndex) in
            if (self.individualIndex == returnedIndex) {
                self.personImageView!.image = tempIndividual.profileDetailImage()
            }
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
    
    @IBAction func save(_ sender: Any) {
        guard let tIndividual = self.individual else {
            return
        }
        
        guard let tempId = tIndividual.id as String?,
              let tempProfilePicture = tIndividual.profilePicture as String?,
              let tempFullName = self.fullNameTextField?.text,
              let tempBirthDate = self.birthDateTextField?.text,
              let tempAffiliate = self.affiliationTextField?.text else {
            return
        }
        
        let tempIndividual = Individual()
        tempIndividual.firstName = tempFullName
        tempIndividual.lastName = String("")
        tempIndividual.birthdate = tempBirthDate
        tempIndividual.affiliation = tempAffiliate
        tempIndividual.profilePicture = tempProfilePicture
        tempIndividual.forceSensitive.value = false
        
        if (tempId == "") {
            AppManager.shared().webService.createIndividual(tempIndividual) { (createdIndividualId, createdIndividual) in
                
                guard let createdId = createdIndividualId else {
                    DLog("Failed to create individual.")
                    return
                }
                
                DLog("Created individual \(createdId).")
                self.directoryDelegate?.getIndividuals();
                self.dismiss()
            }
            
            return
        }
        AppManager.shared().webService.modifyIndividual(tempId, tempIndividual) { (modifiedIndividualId, modifiedIndividual) in
            
            guard let modifiedId = modifiedIndividualId else {
                DLog("Failed to modify individual.")
                return
            }
            
            DLog("Modified individual \(modifiedId).")
            self.directoryDelegate?.getIndividuals();
            self.dismiss()
        }
    }
    
    func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }

}
