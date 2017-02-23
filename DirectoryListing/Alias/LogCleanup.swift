//
//  LogCleanup.swift
//  DirectoryListing
//
//  Created by Michael Steele on 2/22/17.
//  Copyright © 2017 Michael Steele. All rights reserved.
//

import UIKit

#if DEBUG
    func DLog(_ format: String, _ args: CVarArg...) {
        NSLog(format, args)
    }
#else
    func DLog(_ format: String, _ args: CVarArg...) {
    }
    func NSLog(_ format: String, _ args: CVarArg...) {
    }
#endif
