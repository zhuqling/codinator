//
//  CreateDirViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 21/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class CreateDirViewController: UIViewController, UITextFieldDelegate {

    var delegate: NewFilesDelegate?
    var projectManager: Polaris!
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder()
    }
    
    @IBAction func saveDidPush() {
        if textField.text!.isEmpty {
            textField.becomeFirstResponder()
        } else {
            
            // Create dir
            
            let dirUrl = NSURL(fileURLWithPath: projectManager.inspectorPath, isDirectory: true).URLByAppendingPathComponent(textField.text!, isDirectory: true)
            
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.createDirectoryAtURL(dirUrl, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Something went wrong", viewController: self)
            }
            
            self.dismissViewControllerAnimated(true, completion: { 
                self.delegate?.reloadData()
            })
            
        }
    }
    
    @IBAction func cancelDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveDidPush()

        return false
    }
    
    
}
