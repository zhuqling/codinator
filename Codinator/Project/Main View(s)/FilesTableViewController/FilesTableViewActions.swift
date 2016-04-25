//
//  FilesTableViewActions.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension FilesTableViewController: PeekProtocol {
    
    func print() {
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .General
        printInfo.jobName = "Print File"
        printInfo.orientation = .Portrait
        printInfo.duplex = .LongEdge
        
        let printController = UIPrintInteractionController.sharedPrintController()
        printController.printInfo = printInfo
        printController.showsPageRange = true
        
        let pathExtension = (self.projectManager.deletePath as NSString).pathExtension
        switch pathExtension {
            
        case "jpg", "jped", "png", "bmp":
            let image = UIImage(contentsOfFile: self.projectManager.deletePath)
            let imageView = UIImageView(image: image)
            printController.printFormatter = imageView.viewPrintFormatter()
            
        default:
            
            if pathExtension != "" {
                let textView = UITextView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
                try! textView.text = String(contentsOfFile: self.projectManager.deletePath)
                
                printController.printFormatter = textView.viewPrintFormatter()
            }
            else {
                
                Notifications.sharedInstance.alertWithMessage(nil, title: "File type not supported")
                
            }
            
        }
        
        printController.presentAnimated(true, completionHandler: nil)
        
        if self.getSplitView.displayMode == .PrimaryHidden {
            self.getSplitView.preferredDisplayMode = .PrimaryOverlay
        }
    }
    
    func move() {
        self.performSegueWithIdentifier("moveFile", sender: self)
        
        if self.getSplitView.displayMode == .PrimaryHidden {
            self.getSplitView.preferredDisplayMode = .PrimaryOverlay
        }
    }
    
    func rename() {
        let message = "Rename \((self.projectManager.deletePath as NSString).lastPathComponent)"
        
        let alert = UIAlertController(title: "Rename", message: message, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ textField in
            textField.placeholder = (self.projectManager.deletePath as NSString).lastPathComponent
            
            textField.keyboardAppearance = .Dark
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .None
        })
        
        
        let processAction = UIAlertAction(title: "Rename", style: .Default, handler: { _ in
            
            let newName = alert.textFields?.first?.text
            let newPath = ((self.projectManager.deletePath as NSString).stringByDeletingLastPathComponent as NSString).stringByAppendingPathComponent(newName!)
            
            do {
                
                try NSFileManager.defaultManager().moveItemAtPath(self.projectManager.deletePath, toPath: newPath)
                
                self.reloadData()
                
                if self.getSplitView.displayMode == .PrimaryHidden {
                    self.getSplitView.preferredDisplayMode = .PrimaryOverlay
                }
                
                
            } catch let error as NSError {
                Notifications.sharedInstance.displayErrorMessage(error.localizedDescription)
            }
            
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(processAction)
        alert.addAction(cancelAction)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func share() {
        // Create an NSURL for the file you want to send to another app
        let fileUrl = NSURL(fileURLWithPath: self.projectManager.deletePath)
        
        
        // Create the interaction controller
        self.documentInteractionController = UIDocumentInteractionController(URL: fileUrl)
        
        // Present the app picker display
        let cell = self.tableView.cellForRowAtIndexPath(self.indexPath!)!
        self.documentInteractionController?.presentOptionsMenuFromRect(cell.imageView!.frame, inView: cell.imageView!.superview!, animated: true)
    }
    
    func delete() {
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(self.projectManager.deletePath)
        
        if fileExists {
            
            let alert = UIAlertController(title: "Are you sure you want to delete \((self.projectManager.deletePath as NSString).lastPathComponent)?", message: nil, preferredStyle: .Alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: { _ in
                
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(self.projectManager.deletePath)
                    
                    self.reloadData()
                    
                    if self.getSplitView.displayMode == .PrimaryHidden {
                        self.getSplitView.preferredDisplayMode = .PrimaryOverlay
                    }
                    
                    
                } catch let error as NSError{
                    Notifications.sharedInstance.displayErrorMessage(error.localizedDescription)
                }
                
            })
            
            
            alert.addAction(delete)
            alert.addAction(cancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else {
            Notifications.sharedInstance.displayErrorMessage("There was an unexpected error")
        }
        
    }
    
}