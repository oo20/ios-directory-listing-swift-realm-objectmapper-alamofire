//
//  IndividualDetailController.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit
import ObjectMapper
import CameraManager

class IndividualDetailController: ScrollViewController, UITextFieldDelegate {
    
    @IBOutlet var personImageView: UIImageView?
    @IBOutlet var fullNameLabel: UILabel?
    @IBOutlet var birthDateLabel: UILabel?
    @IBOutlet var affiliationLabel: UILabel?
    
    @IBOutlet var fullNameTextField: UITextField?
    @IBOutlet var birthDateTextField: UITextField?
    @IBOutlet var affiliationTextField: UITextField?
    
    @IBOutlet var saveButton: UIButton?
    
    @IBOutlet var personImageTapGesture: UITapGestureRecognizer?
    @IBOutlet var captureButton: UIButton?
    
    @IBOutlet var individualDetailsView: UIView?
    
    var individual : Individual?
    var individualIndex : Int = -1
    
    var directoryDelegate : DirectoryControllerDelegate?
    
    var uploadImage : UIImage?
    
    var cameraManager : CameraManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let tempIndividual = individual else {
            DLog("Individual must be set for individual detail controller.")
            return
        }
        
        fullNameTextField?.text = "\(tempIndividual.firstName) \(tempIndividual.lastName)"
        fullNameTextField?.delegate = self
        
        affiliationTextField?.text = tempIndividual.friendlyAffiliation()
        affiliationTextField?.delegate = self
        
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
        
        birthDateTextField?.delegate = self

        personImageView?.image = nil
        
        personImageView?.isUserInteractionEnabled = true
        
        captureButton?.isHidden = true
        
        if (tempIndividual.profilePicture.isEmpty == false) {
            tempIndividual.preloadImage(checkIndex: self.individualIndex) { (returnedIndex) in
                if (self.individualIndex == returnedIndex) {
                    self.personImageView!.image = tempIndividual.profileDetailImage()
                }
            }
        } else {
            personImageView?.image = UIImage(named: "Missing");
        }
        
        positionScrollViewTopCenter()
        
        registerKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == fullNameTextField) {
            birthDateTextField?.becomeFirstResponder()
        } else if (textField == birthDateTextField) {
            affiliationTextField?.becomeFirstResponder()
        } else if (textField == affiliationTextField) {
            affiliationTextField?.resignFirstResponder()
        }
        
        return true
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
        
        self.uploadImage = self.personImageView?.image
        
        if (tempId == "") {
            AppManager.shared().webService.createIndividual(tempIndividual) { (createdIndividualId, createdIndividual) in
                guard let createdId = createdIndividualId else {
                    DLog("Failed to create individual.")
                    return
                }
                
                self.individual = createdIndividual
                
                DLog("Created individual \(createdId).")
                
                if let image = self.uploadImage {
                    AppManager.shared().webService.uploadTempFile(createdId, image, {
                        self.saveDone()
                    })
                } else {
                    self.saveDone();
                }
            }
            
            return
        }
        
        AppManager.shared().webService.modifyIndividual(tempId, tempIndividual) { (modifiedIndividualId, modifiedIndividual) in
            
            guard let modifiedId = modifiedIndividualId else {
                DLog("Failed to modify individual.")
                return
            }
            
            DLog("Modified individual \(modifiedId).")
            
            if let image = self.uploadImage {
                AppManager.shared().webService.uploadTempFile(modifiedId, image, {
                    self.saveDone()
                })
            } else {
                self.saveDone();
            }
        }
    }
    
    func recacheImageSaveDone(_ tempIndividual: Individual) {
        tempIndividual.preloadImage(checkIndex: self.individualIndex, forceRefresh: true) { (returnedIndex) in
            self.saveDone()
        }
    }
    
    func saveDone() {
        individual?.clearImage()
        AppManager.shared().clearData()
        self.directoryDelegate?.getIndividuals();
        self.dismiss()
    }
    
    func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhoto(_ sender: UITapGestureRecognizer) {
        DLog("Take Photo")
        
        if (cameraManager == nil) {
            cameraManager = CameraManager()
        }
        
        guard let manager = cameraManager else {
            return
        }
        
        if (manager.cameraIsReady == false) {
            manager.askUserForCameraPermission { (allowed) in
                self.startCamera(manager)
                return
            }
        } else {
            startCamera(manager)
        }
        
    }
    
    func startCamera(_ manager: CameraManager) {
        
        guard let personView = self.personImageView else {
            return
        }
        
        _ = manager.addPreviewLayerToView(personView)
        
        manager.cameraDevice = .front
        manager.cameraOutputMode = .stillImage
        manager.cameraOutputQuality = .medium
        
        if (manager.hasFlash) {
            manager.flashMode = .auto
        } else {
            manager.flashMode = .off
        }
        
        
        manager.writeFilesToPhoneLibrary = false
        
        manager.showAccessPermissionPopupAutomatically = true

        captureButton?.isHidden = false
    }
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        
        guard let manager = self.cameraManager else {
            return
        }
        
        manager.capturePictureWithCompletion({ (image, error) -> Void in
            self.personImageView?.image = image
            self.captureButton?.isHidden = true
            self.stopCamera()
        })
    }
    
    func stopCamera() {
        
        guard let manager = self.cameraManager else {
            return
        }
        
        manager.stopAndRemoveCaptureSession()
        self.cameraManager = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.unregisterKeyboardNotifications()
        
        super.viewWillDisappear(animated)
        
        if (self.isMovingToParentViewController){
            stopCamera()
        }
    }
    
}
