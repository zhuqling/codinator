//
//  UIAlertViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 31/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    /// Creates a simple alert
    class func alertWithTitle(title: String, message: String, cancelButtonTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancel)
        
        return alertController
    }
}