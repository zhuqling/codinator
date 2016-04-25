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
    func searchBarAppeared()
    func searchBarDisAppeard()
}

class ProjectSplitViewController: UISplitViewController{

    var rootVC: ProjectMainViewController!
    
    
    var webView: WKWebView?
    var projectManager : Polaris!
    
    var redoButton: UIBarButtonItem!
    var undoButton: UIBarButtonItem!

    var splitViewDelegate: ProjectSplitViewControllerDelegate?

    
    var assistantViewController: AssistantViewController?
    
    
    var filesTableView: FilesTableViewController? {
        get {
            
            guard let filesTableNavCoontroller = self.viewControllers.first as? UINavigationController else {
                assertionFailure("Empty FilesTable Nav Controller")
                return nil
            }
            
            guard let filesTableVC = filesTableNavCoontroller.viewControllers.last as? FilesTableViewController else {
                assertionFailure("Empty FilesTable VC")
                return nil
            }
            
            return filesTableVC
        }
    }
    
    var editorView: EditorViewController? {
        get {
            
            guard let editorVC = self.viewControllers.last as? EditorViewController else {
                assertionFailure("Empty EditorVC")
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: - Searchbar
    
    var searchBarVisible = false
    func dealWithSearchBar() {
        switch searchBarVisible {
        case true:
            searchBarDissappeared()
            
        case false:
            searchBarAppeared()
        }

    }
    
    func searchBarAppeared() {
        searchBarVisible = true
        splitViewDelegate?.searchBarAppeared()
    }
    
    func searchBarDissappeared() {
        searchBarVisible = false
        splitViewDelegate?.searchBarDisAppeard()
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
