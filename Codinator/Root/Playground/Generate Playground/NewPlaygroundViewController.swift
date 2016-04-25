//
//  NewPlaygroundViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 22/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class NewPlaygroundViewController: UIViewController, UITextFieldDelegate{

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
        
        fileNameTextField.addTarget(self, action: #selector(NewPlaygroundViewController.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)

        
        self.nextButton.backgroundColor = UIColor.grayColor()
        self.nextButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        
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
                    NSNotificationCenter.defaultCenter().postNotificationName("reload", object: self, userInfo: nil)
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
    
    func textFieldDidChange() {
        if fileNameTextField.text?.isEmpty == true {
            fileNameTextField.layer.masksToBounds = true
            fileNameTextField.layer.borderColor = violett?.CGColor
            fileNameTextField.layer.borderWidth = 1
            fileNameTextField.layer.cornerRadius = 5
            
            // Textfield is emtpy so disable NextButton
            nextButton.enabled = false
            
            UIView.animateWithDuration(0.2, animations: { 
                self.nextButton.backgroundColor = UIColor.grayColor()
                self.nextButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)

            })
        }
        else {
            
            // Textfield is not empty so enable NextButton
            nextButton.enabled = true
            
            UIView.animateWithDuration(0.2, animations: {
                self.nextButton.backgroundColor = self.violett
                self.nextButton.setTitleColor(self.view.tintColor, forState: UIControlState.Normal)
            })
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    

}
