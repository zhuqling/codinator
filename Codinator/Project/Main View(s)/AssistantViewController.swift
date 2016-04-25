//
//  AssistantViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 22/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit


protocol AssistantViewControllerDelegate {
    func renamedFileWithName(name: String)
}


class AssistantViewController: UIViewController, SnippetsDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var fileExtensionTextField: UITextField!
    
    @IBOutlet weak var pathLabel: UILabel!
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var modifiedLabel: UILabel!
    
    
    
    @IBOutlet weak var snippetsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var snippetsSegmentControl: UISegmentedControl!
    
    
    var delegate: SnippetsDelegate?
    var renameDelegate: AssistantViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let insets = UIEdgeInsets(top: 0, left: 0, bottom: snippetsViewHeightConstraint.constant, right: 0)
        
        scrollView.scrollIndicatorInsets = insets
        scrollView.contentInset = insets
        
        
        fileNameTextField.delegate = self
        fileExtensionTextField.delegate = self
    
    }
    
    var fileUrl: NSURL?
    func setFilePathTo(projectManager: Polaris) {
        
        fileUrl = NSURL(fileURLWithPath: projectManager.selectedFilePath, isDirectory: false)
        
        let name: NSString = (projectManager.selectedFilePath as NSString).lastPathComponent
        fileNameTextField.text = name.stringByDeletingPathExtension
        fileExtensionTextField.text = name.pathExtension
                
        pathLabel.text = projectManager.fakePathForFileSelectedFile()
        
        do {
            let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(projectManager.selectedFilePath)
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            
            let fileSize = (attributes["NSFileSize"] as! Int)
            let createdDate = attributes["NSFileCreationDate"] as! NSDate
            let modifiedDate = attributes["NSFileModificationDate"] as! NSDate
            
            fileSizeLabel.text = "Size: \(fileSize) B"
            createdLabel.text = "Created: " + dateFormatter.stringFromDate(createdDate)
            modifiedLabel.text = "Modified: " + dateFormatter.stringFromDate(modifiedDate)
            
            
        } catch {
            
            fileSizeLabel.text = "Failed loading file size"
            createdLabel.text = "Failed loading created date"
            modifiedLabel.text = "Failed loading modified date"
            
            
        }
        
    }
    
    
    @IBOutlet weak var enumerationButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var colorPicker: UIButton!
    
    @IBAction func segmendDidChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            enumerationButton.hidden = false
            imageButton.hidden = false
            linkButton.hidden = false
            
            colorPicker.hidden = true
        }
        else {
            enumerationButton.hidden = true
            imageButton.hidden = true
            linkButton.hidden = true
            
            colorPicker.hidden = false
        }
    }
    
    
    
    // MARK: - Snippets delegate
    
    func snippetWasCoppied(status: String) {
        delegate?.snippetWasCoppied(status)
    }
    
    func colorDidChange(color: UIColor) {
        delegate?.colorDidChange(color)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.moveItemAtURL(fileUrl!, toURL: fileUrl!.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(fileNameTextField.text! + "." + fileExtensionTextField.text!))
            
            self.renameDelegate?.renamedFileWithName(fileNameTextField.text! + "." + fileExtensionTextField.text!)
            
        } catch let error as NSError {
            Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Something went wrong!", viewController: self)
        }
        
        
        return false
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "img":
            let vc = segue.destinationViewController as! ImgSnippetsViewController
            vc.delegate = self
   
        case "link":
            let vc = segue.destinationViewController as! LinkSnippetsViewController
            vc.delegate = self
            
        case "list":
            let vc = segue.destinationViewController as! ListSnippetsViewController
            vc.delegate = self
            
        case "colorPicker":
            let vc = segue.destinationViewController as! ColorPickerViewController
            vc.delegate = self
            
        default:
            break
        }
    }
    

}
