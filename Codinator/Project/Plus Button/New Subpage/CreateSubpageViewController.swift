//
//  CreateSubpageViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 4/21/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class CreateSubpageViewController: UIViewController, UITextFieldDelegate {

    var projectManager: Polaris!
    @IBOutlet var textField: UITextField!
    
    var delegate: NewFilesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func saveDidPush(sender: UIBarButtonItem) {
        if textField.text!.isEmpty {
            textField.becomeFirstResponder()
        }
        else {
            
            let dirUrl = NSURL(fileURLWithPath: projectManager.inspectorPath, isDirectory: true).URLByAppendingPathComponent(textField.text!, isDirectory: true)
            
            let fileManager = NSFileManager.defaultManager()
            
            // Create folder
            do {
                try fileManager.createDirectoryAtURL(dirUrl, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Something went wrong.", viewController: self)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            
            
            let indexFileBody = FileTemplates.htmlTemplateFileForName(textField.text!)
            let indexFileUrl = dirUrl.URLByAppendingPathComponent("index.html", isDirectory: false)

            
            // Create file
            do {
                try indexFileBody.writeToURL(indexFileUrl, atomically: true, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Something went wrong", viewController: self)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                return

            }
            
            
            delegate?.reloadData()
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    @IBAction func cancelDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
