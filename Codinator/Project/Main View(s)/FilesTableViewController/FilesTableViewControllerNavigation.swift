//
//  FilesTableViewControllerLongPress.swift
//  Codinator
//
//  Created by Vladimir Danila on 24/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension FilesTableViewController {
    
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.blackColor()
        cell.selectedBackgroundView = bgColorView
        
        
        if let text = items[indexPath.row].lastPathComponent {
            cell.textLabel?.text = text
            
            if let path = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(text) {
                let manager = Thumbnail()
                cell.imageView?.image = manager.thumbnailForFileAtPath(path)
            }
        }
        
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FilesTableViewController.tableViewCellWasLongPressed))
        cell.addGestureRecognizer(longPressGestureRecognizer)
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedPath = (inspectorPath as NSString?)?.stringByAppendingPathComponent(items[indexPath.row].lastPathComponent!) {
            var isDirectory : ObjCBool = ObjCBool(false)
            
            if (NSFileManager.defaultManager().fileExistsAtPath(selectedPath, isDirectory: &isDirectory) && Bool(isDirectory) == true) {
                                
                projectManager.inspectorPath = selectedPath
                
                if let controller = storyboard?.instantiateViewControllerWithIdentifier("filesTableView") as? FilesTableViewController {
                    controller.inspectorPath = selectedPath
                    
                    
                    count += 1
                    
                    controller.navigationHidden = false
                    self.navigationController?.showViewController(controller, sender: self)
                }
                
            } else {
                
                projectManager?.selectedFilePath = selectedPath
                
                
                switch (selectedPath as NSString).pathExtension {
                    
                case "png","img","jpg","jpeg", "gif":
                    
                    projectManager.tmpFilePath = selectedPath
                    
                    let cell = tableView.cellForRowAtIndexPath(indexPath)!
                    
                    
                    
                    let imageInfo = JTSImageInfo()
                    imageInfo.image = cell.imageView!.image
                    
                    imageInfo.referenceRect = cell.imageView!.frame
                    imageInfo.referenceView = cell.imageView?.superview
                    
                    let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Blurred)
                    
                    imageViewer.showFromViewController(self, transition: .FromOriginalPosition)
                    
                    
                case "zip":
                    break
                    
                case "pdf":
                    projectManager.tmpFilePath = projectManager.selectedFilePath
                    self.performSegueWithIdentifier("run", sender: self)
                    
                    
                default:
                    
                    guard let webView = getSplitView.webView else {
                        return
                    }
                    
                    webView.loadFileURL( NSURL(fileURLWithPath: selectedPath, isDirectory: false), allowingReadAccessToURL: NSURL(fileURLWithPath: projectManager!.selectedFilePath, isDirectory: true))
                    
                    
                    if let data = NSFileManager.defaultManager().contentsAtPath(selectedPath) {
                        let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                        
                        getSplitView.editorView!.text = contents as? String
                        
                        getSplitView.assistantViewController?.setFilePathTo(projectManager)
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    

    
    func tableViewCellWasLongPressed(sender: UILongPressGestureRecognizer) {
        let point = sender.locationInView(tableView)
        let position = CGRectMake(point.x, point.y, 20, 0)
        
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if sender.state == .Began && indexPath != nil {
            projectManager.deletePath = (projectManager.inspectorPath as NSString).stringByAppendingPathComponent(items[indexPath!.row].lastPathComponent!)
            
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { _ in
                self.delete()
            })
            
            
            let previewAction = UIAlertAction(title: "Preview", style: .Default, handler: { _ in
                self.performSegueWithIdentifier("run", sender: self)
            })
            
            
            let printAction = UIAlertAction(title: "Print", style: .Default, handler: { _ in
                self.print()
            })
            
            
            let moveAction = UIAlertAction(title: "Move file", style: .Default, handler: { _ in
                self.move()
            })
            
            
            let renameAction = UIAlertAction(title: "Rename", style: .Default, handler: { _ in
                self.rename()
            })
            
            
            let shareAction = UIAlertAction(title: "Share", style: .Default, handler: { _ in
                self.indexPath = indexPath
                self.share()
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in
                
                if self.getSplitView.displayMode == .PrimaryHidden {
                    self.getSplitView.preferredDisplayMode = .PrimaryOverlay
                }

                
            })
            
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let pathExtension = (self.projectManager.deletePath as NSString).pathExtension
            
            
            if pathExtension != "" {
                alertController.addAction(previewAction)
                alertController.addAction(printAction)
            }
            
            alertController.addAction(moveAction)
            alertController.addAction(renameAction)
            
            if pathExtension != "" {
                alertController.addAction(shareAction)
            }
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            alertController.popoverPresentationController?.sourceView = tableView
            alertController.popoverPresentationController?.sourceRect = position
            
            
            if getSplitView.displayMode != .PrimaryOverlay {
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {

                alertController.title = (projectManager.deletePath as NSString).lastPathComponent
                alertController.message = "What do you want to do with the file?"
                
                getSplitView.preferredDisplayMode = .PrimaryHidden
                getSplitView!.rootVC.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
        
    }

    
    func refreashData() {
        
    }
    
}