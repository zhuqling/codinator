//
//  NewPlaygroundViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 22/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class NewPlaygroundViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var violett: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Save Violett color
        violett = nextButton.backgroundColor
        
        
        // Configure next Button
        nextButton.backgroundColor = UIColor.grayColor()
        nextButton.enabled = false

        // Configure fileNameTextField
        fileNameTextField.attributedPlaceholder = NSAttributedString(string: "Playground name", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        fileNameTextField.layer.masksToBounds = true
        fileNameTextField.layer.borderColor = violett?.CGColor
        fileNameTextField.layer.borderWidth = 1.0
        fileNameTextField.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Buttons

    
    // Generate a new File
    @IBAction func nextDidPush(sender: AnyObject) {
        let document = PlaygroundFileCreator.generatePlaygroundFileWithName(fileNameTextField.text!)
        let url = PlaygroundFileCreator.fileUrlForPlaygroundWithName(fileNameTextField.text!)

        document.saveToURL(url, forSaveOperation: .ForOverwriting) { (success) in
            if success {
                self.dismissViewControllerAnimated(true, completion: { 
                    NSNotificationCenter.defaultCenter().postNotificationName("createdProj", object: nil, userInfo: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("relead", object: nil, userInfo: nil)
                })
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "Failed to create Playground", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { (UIAlertAction) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    // Close View 
    @IBAction func closeDidPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    // MARK: - Textfield Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.isEmpty == true {
            textField.layer.masksToBounds = true
            textField.layer.borderColor = violett?.CGColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 5
            
            // Textfield is emtpy so disable NextButton
            nextButton.enabled = false
            nextButton.backgroundColor = UIColor.grayColor()
        }
        else {
            
            // Textfield is not empty so enable NextButton
            nextButton.enabled = true
            nextButton.backgroundColor = violett
        }
    }

}
