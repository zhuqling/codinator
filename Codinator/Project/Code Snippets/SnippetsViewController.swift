//
//  imgSnippetViewController.swift
//  VWAS-HTML
//
//  Created by Vladimir on 29/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import UIKit

class ImgSnippetsViewController: UIViewController,UITextFieldDelegate {
   
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var width: UITextField!
    @IBOutlet var height: UITextField!
   
    
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
            let code = "<img src=\"\(text)\" alt=\"\(imageName)\"  width=\"\(width.text!)\" height=\"\(height.text!)\">"
            status = "copied"
            
            let pasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = code
        }
        else{
            print("Error")
            status = "copiedError"
        }
        
        
        
        self.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName(status as String, object: self)
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
                NSNotificationCenter.defaultCenter().postNotificationName("copied", object: self)
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
    
    
    @IBAction func stepperDidPush(sender: AnyObject) {
        let integer = Int(stepper.value)
        enumNumberLabel.text = "\(integer)"
    }
    
    override func viewDidLoad() {
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
            NSNotificationCenter.defaultCenter().postNotificationName("copied", object: self)
        })
    }
    
    
    
}



class ColorPickerViewController: UIViewController{

    var displayed = false
    let colorPickerView = HRColorPickerView(frame: CGRectMake(0, 0, 400, 550))
    
    
    override func viewDidLoad() {
        if let color = NSUserDefaults.standardUserDefaults().colorForKey("colorPickerCn"){
            colorPickerView.color = color
        }
        else{
            colorPickerView.color = UIColor.purpleColor()
        }
        
        self.view.addSubview(colorPickerView)
        colorPickerView.addTarget(self, action: "colorPickerDidChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func colorPickerDidChanged(){
        
        NSUserDefaults.standardUserDefaults().setColor(colorPickerView.color, forKey: "colorPickerCn")
        
        if (!displayed){
            
            displayed = true
            
            let label = UILabel(frame: CGRectMake(0, 550, 400, 50))
            label.text = "The hex code has been copied to your clipboard."
            self.view.addSubview(label)
        }

    
    }
    
     
}


