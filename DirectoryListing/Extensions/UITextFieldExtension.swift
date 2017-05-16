//
//  UITextFieldExtension.swift
//  DirectoryListing
//
//  Created by Michael Steele on 5/16/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit

extension UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func editing(_ editingAllowed: Bool) {
        self.borderStyle = editingAllowed == true ? .roundedRect : .none
        self.isEnabled = true
    }
    
    func disabled() {
        self.borderStyle = .none
        self.isEnabled = false
    }
}
