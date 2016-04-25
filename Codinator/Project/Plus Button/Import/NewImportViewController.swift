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

    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    
    var items: [String]!
    var webUploaderURL: String!
    var inspectorPath: String!

    var delegate: NewFilesDelegate?
    
    

    
    
    // MARK: - Shortcuts
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: "W", modifierFlags: .Command, action: #selector(NewImportViewController.close2), discoverabilityTitle: "Close Window")]
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
                    self.delegate?.reloadData()
                })
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            
            controller.addAction(reloadDataBase)
            controller.addAction(cancel)
            
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        else{
            
            let deviceName = UIDevice.currentDevice().model
            Notifications.sharedInstance.alertWithMessage("Please connect your " + deviceName + " to a Wi-Fi network and make sure web uploader is enabled in Settings.", title: "Error ❌", viewController: self)
            
        }
    
    
    }
    
    

    @IBAction func icloudDidPush(sender: AnyObject) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.vladidanila.VWAS-HTML.html","public.data","public.text","public.rtf","public.movie","public.audio","public.image","com.adobe.pdf","com.apple.keynote.key","com.microsoft.word.doc","com.microsoft.excel.xls","com.microsoft.powerpoint.ppt","public.svg-image","com.taptrix.inkpad","public.source-code","public.script","public.shell-script","public.executable"], inMode: UIDocumentPickerMode.Import)
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }
    

    
    // MARK: image picker

    
    @IBAction func cameraDidPush(sender: AnyObject) {

        
        if (textField.text!.isEmpty){
            
            textField.alpha = 0
            label.alpha = 0
            textField.hidden = false
            label.hidden = false
            UIView.animateWithDuration(0.4, animations: {
                self.textField.alpha = 1
                self.label.alpha = 1
            })
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
            popover.sourceRect = sender.frame
            
            
            presentViewController(picker, animated: true, completion: nil)
            


        }
    }
    
    
    
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
        
        
        
        let newFileName = NewFiles.availableName(fileUrl.lastPathComponent!, nameWithoutExtension: fileUrl.URLByDeletingPathExtension!.lastPathComponent!, Extension: fileUrl.pathExtension!, items: items)
        fileUrl = fileUrl.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(newFileName)
        
    
        
        let content = UIImagePNGRepresentation(image)
        
        NSFileManager.defaultManager().createFileAtPath((fileUrl.path)!, contents: content, attributes: nil)
        
        
        picker.dismissViewControllerAnimated(true, completion: {
            self.delegate?.reloadData()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    

    
    
    // MARK: textfield
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
        if (textField.tag == 2){  //Image name
            
            cameraDidPush(cameraButton)
            textField.hidden = true
        }
        

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.tag == 2){  //Image name
            
            cameraDidPush(cameraButton)
            textField.hidden = true
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    
    
    // MARK: cloud
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if (controller.documentPickerMode == UIDocumentPickerMode.Import){
            
            let name = url.lastPathComponent!
            let pathToWriteFile = inspectorPath! + "/" + name

            let content = NSData(contentsOfURL: url)
            NSFileManager.defaultManager().createFileAtPath(pathToWriteFile, contents: content, attributes: nil)
            
            content?.writeToFile(inspectorPath!, atomically: true)
        }
    
        self.dismissViewControllerAnimated(true, completion: {
            self.delegate?.reloadData()
        })
    }
    

    // MARK: - Default
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
}


