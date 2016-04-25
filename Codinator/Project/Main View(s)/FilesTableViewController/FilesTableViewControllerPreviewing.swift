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
        

        let fileName: NSString = items[indexPath.row].lastPathComponent!
        let path = (inspectorPath as NSString?)?.stringByAppendingPathComponent(fileName as String)
        
        self.projectManager.deletePath = path
        
        switch fileName.pathExtension {
    
        case "png", "jpg", "jpeg", "bmp", "":
            
            guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("imageViewPeek") as? PeekImageViewController,
            imageView = previewVC.view.subviews.first as? UIImageView else {
                return nil
            }
            
            imageView.image = cell.imageView?.image
            previewingContext.sourceRect = cell.frame
            
            self.indexPath = indexPath
            previewVC.delegate = self
            
            if fileName.pathExtension == "" {
                let imageViewSize = cell.imageView!.frame.size
                previewVC.preferredContentSize = CGSizeMake(imageViewSize.width * 3, imageViewSize.height * 3)
            }
            
            return previewVC
            
            
        default:
            guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("webViewPeek") as? AspectRatioViewController else {
                return nil
            }
            
            previewVC.previewPath = path
            previewingContext.sourceRect = cell.frame
            
            return previewVC
        }
        
    }
    
    
    // Pop
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        
        
    }
    
}