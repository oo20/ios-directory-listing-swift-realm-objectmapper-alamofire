//
//  ImageExtension.swift
//  DirectoryListing
//
//  Created by Michael Steele on 5/15/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func getSystemImage(_ systemItem: UIBarButtonSystemItem)-> UIImage? {
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        for view in itemView.subviews {
            if let button = view as? UIButton, let imageView = button.imageView {
                return imageView.image
            }
        }
        
        return nil
    }

}
