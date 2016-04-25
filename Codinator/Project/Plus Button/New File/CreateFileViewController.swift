//
//  CreateFileViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 21/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class CreateFileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var extensionTextField: UITextField!
    
    var items: [String]?
    var path: String?
    
    var delegate: NewFilesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.becomeFirstResponder()
    }

    
    
    @IBAction func createFile(sender: UIBarButtonItem) {
        
        if extensionTextField.text!.isEmpty {
            extensionTextField.becomeFirstResponder()
            return
        }
        
        if nameTextField.text!.isEmpty {
            nameTextField.becomeFirstResponder()
            return
        }
        
        
        let fileName = NewFiles.availableName(nameTextField.text! + "." + extensionTextField.text!, nameWithoutExtension: nameTextField.text!, Extension: extensionTextField.text!, items: items!)
        
        var fileContent: String {
            
            switch extensionTextField.text! {
            case "html":
                return FileTemplates.htmlTemplateFileForName(nameTextField.text!)

            case "css":
                return FileTemplates.cssTemplateFile()
                
            case "js":
                return FileTemplates.jsTemplateFile()
                
            case "txt":
                return FileTemplates.txtTemplateFile()
                
            case "php":
                return FileTemplates.phpTemplateFile()
                
            default:
                return ""
            }
            
        }
       
        
        let fileUrl = NSURL(fileURLWithPath: path!, isDirectory: false).URLByAppendingPathComponent(fileName)
        
        do {
            try fileContent.writeToURL(fileUrl, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Something went wrong", viewController: self)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        self.dismissViewControllerAnimated(true) { 
            self.delegate?.reloadData()
        }
        
        
    }
    
    
    @IBAction func cancelDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if extensionTextField.text!.isEmpty && nameTextField.text!.isEmpty {
            if extensionTextField.text!.isEmpty {
                extensionTextField.becomeFirstResponder()
            }
            
            if nameTextField.text!.isEmpty {
                nameTextField.becomeFirstResponder()
            }
        }
        else {
            createFile(UIBarButtonItem())
        }
        
        
        return false
    }
    
    
    // MARK: - File types Shortcut
    
    @IBAction func html(sender: UIButton) {
        extensionTextField.text = "html"
    }

    @IBAction func css(sender: UIButton) {
        extensionTextField.text = "css"
    }
    
    @IBAction func js(sender: UIButton) {
        extensionTextField.text = "js"
    }
    
    @IBAction func php(sender: UIButton) {
        extensionTextField.text = "php"
    }
    
    @IBAction func txt(sender: UIButton) {
        extensionTextField.text = "txt"
    }
    
}
