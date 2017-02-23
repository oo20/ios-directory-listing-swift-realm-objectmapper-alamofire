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
        let date = self.date()
        guard (date != nil) else { return nil }
        return date!.friendlyDate()
    }
    
    func base64Encoded() -> String {
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    func base64Decoded() -> String {
        let decodedData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: String.Encoding.utf8.rawValue)
        return decodedString as! String
    }
}
