//
//  FilesTableViewControllerPreviewing.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension FilesTableViewController: UIViewControllerPreviewingDelegate {
    
    // Peek
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
            
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            let cell = tableView.cellForRowAtIndexPath(indexPath) else {
                return nil
        }
        

        let fileName = items[indexPath.row].lastPathComponent!
        let path = inspectorURL!.URLByAppendingPathComponent(fileName)
        
        self.projectManager.deleteURL = path
        
        switch path.pathExtension! {
    
        case "png", "jpg", "jpeg", "bmp", "":
            
            guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("imageViewPeek") as? PeekImageViewController,
            imageView = previewVC.view.subviews.first as? UIImageView else {
                return nil
            }
            
            imageView.image = cell.imageView?.image
            previewingContext.sourceRect = cell.frame
            
            self.indexPath = indexPath
            previewVC.delegate = self
            
            if path.pathExtension == "" {
                let imageViewSize = cell.imageView!.frame.size
                previewVC.preferredContentSize = CGSizeMake(imageViewSize.width * 3, imageViewSize.height * 3)
                previewVC.isDir = true

            }
            
            return previewVC
            
            
        default:
            guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("webViewPeek") as? PeekWebViewController else {
                return nil
            }
            previewVC.delegate = self
            previewVC.previewPath = path.path
            previewingContext.sourceRect = cell.frame
            
            return previewVC
        }
        
    }
    
    
    // Pop
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        let path = self.projectManager.deleteURL
        
        switch path.pathExtension! {
        case "png", "jpg", "jpeg", "bmp", "":
            break
            
            
        default:
            guard let webView = getSplitView.webView else {
                return
            }
            
            
            webView.loadFileURL(path, allowingReadAccessToURL: path.URLByDeletingLastPathComponent!)
            
            projectManager.selectedFileURL = path
            projectManager.deleteURL = nil
            
            if let data = NSFileManager.defaultManager().contentsAtPath(path.path!) {
                let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                getSplitView.editorView!.text = contents as? String
                
                getSplitView.assistantViewController?.setFilePathTo(projectManager)
                
                self.selectFileWithName(path.lastPathComponent!)
                
            }
            
        }
        
        
    }
    
}