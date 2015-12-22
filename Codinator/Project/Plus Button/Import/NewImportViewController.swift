//
//  ImportViewController.swift
//  VWAS-HTML
//
//  Created by Vladi Danila on 28/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import UIKit
import MessageUI

class NewImportViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentPickerDelegate,UITextFieldDelegate,NSURLConnectionDelegate{

    let inspectorPath = NSUserDefaults.standardUserDefaults().stringForKey("inspectorPath")
    let webUploaderURL = NSUserDefaults.standardUserDefaults().stringForKey("webUploaderServerURL")
    
    var error = NSError?()
    var content : NSData?
    var items = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSUserDefaults.standardUserDefaults().stringForKey("inspectorPath")!)
    
    @IBOutlet var textField: UITextField!
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView?
    @IBOutlet var urlTextField: UITextField?
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    
    
    @IBOutlet weak var cameraRollButton: UIButton!
    

    
    
    
    
    override func viewDidLoad() {

        closeButton.layer.cornerRadius = 5

            NSNotificationCenter.defaultCenter().addObserver(self, selector: "close2", name: "filesImported", object: nil)
        

        
        activity!.hidden = true
     

    }
    
    // MARK: - Shortcuts
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override var keyCommands: [UIKeyCommand]? {
    
        return [UIKeyCommand(input: "W", modifierFlags: .Command, action: "close2", discoverabilityTitle: "Close Window")]
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    
    func close2(){
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func cancelDidPush(sender: AnyObject) {
        close2()
    }
    
    
    
    
    @IBAction func computerDidPush(sender: AnyObject) {
        
        
        if let webUploaderReference = webUploaderURL{
            let controller = UIAlertController(title: "Importing", message: "Visit this URL on another device (In the same network) to transfer your files:\n\n" + webUploaderReference, preferredStyle: .Alert)
            controller.view.tintColor = UIColor.blackColor()
            let reloadDataBase = UIAlertAction(title: "Reload File-Database ", style: .Default) { (UIAlertAction) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: {
                    NSNotificationCenter.defaultCenter().postNotificationName("fileImported", object: self, userInfo: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("history", object: self, userInfo: nil)
                })
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            
            controller.addAction(reloadDataBase)
            controller.addAction(cancel)
            
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        else{
            
            let deviceName = UIDevice.currentDevice().model
            
            let controller = UIAlertController(title: "Error ❌", message: "Please connect your " + deviceName + " to a Wi-Fi network", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Ok!", style: .Cancel, handler: nil)
            controller.addAction(cancel)
            self.presentViewController(controller, animated: true, completion: nil)

            
        }
    
    
    }
    
    

    @IBAction func icloudDidPush(sender: AnyObject) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.vladidanila.VWAS-HTML.html","public.data","public.text","public.rtf","public.movie","public.audio","public.image","com.adobe.pdf","com.apple.keynote.key","com.microsoft.word.doc","com.microsoft.excel.xls","com.microsoft.powerpoint.ppt","public.svg-image","com.taptrix.inkpad","public.source-code","public.script","public.shell-script","public.executable"], inMode: UIDocumentPickerMode.Import)
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }
    

    
    
    @IBAction func cameraDidPush(sender: AnyObject) {

        
        if (textField.text!.isEmpty){
            textField.hidden = false
            textField.becomeFirstResponder()
        }
        else{
         
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.modalPresentationStyle = UIModalPresentationStyle.Popover
        
            

            let popover : UIPopoverPresentationController = picker.popoverPresentationController!
            
            popover.sourceView = self.view
            popover.sourceRect = cameraRollButton.frame
            
            
            presentViewController(picker, animated: true, completion: nil)
            


        }
    }
    
    

    
    
    
    
    
    
    
    

    
    
    // MARK: textfield
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.tag == 1){  //URL
        
            textField.text = "http://"
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        if (textField.tag == 2){  //Image name
            
            cameraDidPush(textField)
            textField.hidden = true
        }
        

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.tag == 2){  //Image name
            
            cameraDidPush(textField)
            textField.hidden = true
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: image picker
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let pathToWriteFile = inspectorPath! + "/" + textField.text!
        var fileUrl = NSURL(fileURLWithPath: pathToWriteFile)
        
        if (fileUrl.lastPathComponent == ""){
            fileUrl = fileUrl.URLByAppendingPathExtension("png")
        }
        else{
           fileUrl = fileUrl.URLByDeletingPathExtension!
           fileUrl = fileUrl.URLByAppendingPathExtension("png")
        }
        
        
        content = UIImagePNGRepresentation(image)
        
        NSFileManager.defaultManager().createFileAtPath((fileUrl.path)!, contents: content, attributes: nil)
        
        
        picker.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("fileImported", object: self, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("history", object: self, userInfo: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    

    
    
    
    // MARK: cloud
    
    
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if (controller.documentPickerMode == UIDocumentPickerMode.Import){
            
            let name = url.lastPathComponent
            let pathToWriteFile = inspectorPath! + "/" + (name! as String)

            content = NSData(contentsOfURL: url)
            NSFileManager.defaultManager().createFileAtPath(pathToWriteFile, contents: content, attributes: nil)
            
            content?.writeToFile(inspectorPath!, atomically: true)
        }
    
        self.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("fileImported", object: self, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("history", object: self, userInfo: nil)
        })
    }
    
    
    
    
}


