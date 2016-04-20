//
//  ProjectSplitViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

protocol ProjectSplitViewControllerDelegate {
    func webViewSizeDidChange()
}

class ProjectSplitViewController: UISplitViewController {

    var webView: WKWebView?
    var projectManager : Polaris = Polaris(projectPath: NSUserDefaults.standardUserDefaults().stringForKey("ProjectPath"), currentView: nil, withWebServer: NSUserDefaults.standardUserDefaults().boolForKey("CnWebServer"), uploadServer: NSUserDefaults.standardUserDefaults().boolForKey("CnUploadServer"), andWebDavServer: NSUserDefaults.standardUserDefaults().boolForKey("CnWebDavServer"))

    var splitViewDelegate: ProjectSplitViewControllerDelegate?

    
    var filesTableView: FilesTableViewController? {
        get {
            
            guard let FilesTableVC = self.viewControllers[0] as? FilesTableViewController else {
                print("Empty FilesTableVC")
                return nil
            }
            
            return FilesTableVC
        }
    }
    
    var editorView: EditorViewController? {
        get {
            
            guard let editorVC = self.viewControllers[1] as? EditorViewController else {
                
                print("Empty EditorVC")
                return nil
            }
            
            return editorVC
        }
    }
    
    var webViewOnScreen: Bool {
        get {
            return isVisible(webView!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minimumPrimaryColumnWidth = 200
        self.maximumPrimaryColumnWidth = 200
        self.preferredPrimaryColumnWidthFraction = 0.25
        
        
        let horizontallyRegularTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        self.setOverrideTraitCollection(horizontallyRegularTraitCollection, forChildViewController: self)
    }
    
    
    
    // MARK: - Custom API
    
    private func isVisible(view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convertRect(view.bounds, fromView: view)
            if CGRectIntersectsRect(viewFrame, inView.bounds) {
                return isVisible(view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view, inView: view.superview)
    }
    
    func webViewDidChange() {
        splitViewDelegate?.webViewSizeDidChange()
    }
    
}
