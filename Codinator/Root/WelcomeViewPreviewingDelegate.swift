//
//  WelcomeViewPreviewingDelegate.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension WelcomeViewController: UIViewControllerPreviewingDelegate, PeekShortProtocol {
    
    public func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.collectionView.indexPathForItemAtPoint(location),
            let cell = collectionView.cellForItemAtIndexPath(indexPath) else {
                return nil
        }
        
        
        if indexPath.section != 0 {
            return nil
        }
    
        let fileName: NSString = projectsArray[indexPath.row].lastPathComponent!
        
        let root: NSString = AppDelegate.storagePath()
        let projectsRootDirPath: NSString = root.stringByAppendingPathComponent("Projects")
        let projectPath = projectsRootDirPath.stringByAppendingPathComponent(fileName as String)

        
        if fileName.pathExtension != ".zip" {
            let path = projectPath + "/Assets/index.html"
            
            guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("webViewPeek") as? PeekWebViewController else {
                return nil
            }
            
            //        previewVC.delegate = self
            previewVC.isProjects = true
            previewVC.previewPath = path
            previewingContext.sourceRect = cell.frame
            
            
            previewVC.projectsDelegate = self
            
            
            self.forceTouchPath = projectPath
            
            return previewVC
        }
        else {
            return nil
        }
    }
    
    
    public func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
     
        if forceTouchPath.characters.count > 5 {
            
            document = CodinatorDocument(fileURL: NSURL(fileURLWithPath: forceTouchPath))
            document.openWithCompletionHandler { sucess in
                
                if sucess {
                    self.projectIsOpened = true
                    
                    self.projectsPath = self.forceTouchPath
                    self.forceTouchPath = ""
                    
                    self.performSegueWithIdentifier("projectPop", sender: nil)
                }
                else {
                    Notifications.sharedInstance.alertWithMessage("Failed opening the project.", title: "Error", viewController: self)
                }
                
            }
            
        }
    }
    
    
    // MARK: - Actions
    
    func rename() {
        let message = "Rename \(((forceTouchPath as NSString).lastPathComponent as NSString).stringByDeletingPathExtension)"
        
        let alertController = UIAlertController(title: "Rename", message: message, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Projects new name"
            textField.keyboardAppearance = .Dark
            textField.tintColor = self.view.tintColor
        }
        
        let processRenaming = UIAlertAction(title: "Rename", style: .Default) { _ in
            let newName = alertController.textFields![0].text! + ".cnProj"
            let newPath = (self.forceTouchPath as NSString).stringByDeletingLastPathComponent + newName
            
            let polaris = Polaris(projectPath: self.forceTouchPath!, currentView: nil, withWebServer: false, uploadServer: false, andWebDavServer: false)
            polaris.updateSettingsValueForKey("ProjectName", withValue: (newName as NSString).stringByDeletingPathExtension)
            
            do {
                try NSFileManager.defaultManager().moveItemAtPath(self.forceTouchPath, toPath: newPath)
                self.reloadData()
                
            } catch let error as NSError {
                Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Something went wrong", viewController: self)
            }
            
            
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(processRenaming)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func delete() {
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(self.forceTouchPath)
            forceTouchPath = ""
            self.reloadData()
        } catch let error as NSError{
            Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Someting went wrong", viewController: self)
        }
        
    }
    
    
}