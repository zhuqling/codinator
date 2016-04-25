//
//  imgSnippetViewController.swift
//  VWAS-HTML
//
//  Created by Vladimir on 29/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import UIKit


protocol SnippetsDelegate {
    func snippetWasCoppied(status: String)
    func colorDidChange(color: UIColor)
}


class ImgSnippetsViewController: UIViewController,UITextFieldDelegate {
   
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var width: UITextField!
    @IBOutlet var height: UITextField!
   
    var delegate: SnippetsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.attributedPlaceholder = NSAttributedString(string:"link or path to projects", attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func copyDidPush(sender: AnyObject) {
     
        var status = ""
        
        let text = textField.text
        let characterCount = text!.characters.count
        
        if characterCount != 0 {
            let image = (textField.text! as NSString).lastPathComponent
            let imageName = (image as NSString).stringByDeletingPathExtension
            let code = "<img src=\"\(text!)\" alt=\"\(imageName)\"  width=\"\(width.text!)\" height=\"\(height.text!)\">"
            status = "copied"
            
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = code
        }
        else{
            print("Error")
            status = "copiedError"
        }
        
        
        
        self.dismissViewControllerAnimated(true, completion: {
            self.delegate?.snippetWasCoppied(status)
        })
        
    }
    
    
    @IBAction func viewDidTapped(sender: AnyObject) {
        textField.resignFirstResponder()
        width.resignFirstResponder()
        height.resignFirstResponder()
    }

    
}



class LinkSnippetsViewController :UIViewController,UITextFieldDelegate{
    @IBOutlet var textField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    var delegate: SnippetsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.attributedPlaceholder = NSAttributedString(string:"name", attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        nameTextField.attributedPlaceholder = NSAttributedString(string:"http link", attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        
    }
    
    @IBAction func generateDidPush(sender: AnyObject) {
    
        if nameTextField.text!.isEmpty {
            nameTextField.becomeFirstResponder()
        }
        else if textField.text!.isEmpty {
            textField.becomeFirstResponder()
        }
        else{
            let code = "<a href=\"\(textField.text!)\">\(nameTextField.text!)</a>"
            let pasteBoard = UIPasteboard.generalPasteboard()
            pasteBoard.string = code
            
            self.dismissViewControllerAnimated(true, completion: {
                
                self.delegate?.snippetWasCoppied("copied")
            
            })
        }
    }
    
    

    func textFieldShouldReturn(textField2: UITextField) -> Bool {
       textField2.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField2: UITextField) {
        let placeHolder = textField2.placeholder
        print(placeHolder)
        
        if (placeHolder == "http link to subpage "){
            textField.text = "http://"
        }
    }
    
    @IBAction func viewDidTapped(sender: AnyObject) {
        textField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
}







class ListSnippetsViewController :UIViewController{
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var enumNumberLabel: UILabel!
    
    var delegate: SnippetsDelegate?
    
    @IBAction func stepperDidPush(sender: AnyObject) {
        let integer = Int(stepper.value)
        enumNumberLabel.text = "\(integer)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let integer = Int(stepper.value)
        enumNumberLabel.text = "\(integer)"
    }
    
    @IBAction func generateDidPush(sender: AnyObject) {
        var  tags = "<ul> \n"
        
      
        for _ in 1...Int(stepper.value)
        {
            let middleTag = "   <li></li> \n"
            tags += middleTag
        }
        tags += "</ul> "
        
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = tags
        
        self.dismissViewControllerAnimated(true, completion: {
            self.delegate?.snippetWasCoppied("copied")
        })
    }
    
    
    
}

