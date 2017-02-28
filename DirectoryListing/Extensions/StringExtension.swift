//
//  StringExtension.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/21/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit

extension String {
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let datePublished = dateFormatter.date(from: self) {
            return datePublished
        }
        
        return nil
    }
    
    func friendlyDate() -> String? {
        guard let date = self.date() else {
            return error()
        }
        
        return date.friendlyDate()
    }
    
    func base64Encoded() -> String? {
        guard let plainData = data(using: String.Encoding.utf8) else {
            return error()
        }
        
        let base64String = plainData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        return base64String
    }
    
    func base64Decoded() -> String? {
        guard let decodedData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0)) else {
            return error()
        }
        
        let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue)
        
        return decodedString as String?
    }
    
    func error() -> String? { // Control error output here for consistency
        return nil
    }
}
