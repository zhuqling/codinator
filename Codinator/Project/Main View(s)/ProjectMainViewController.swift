//
//  ProjectMainViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 27-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit
import WebKit



class ProjectMainViewController: UIViewController {

    var webView: WKWebView?

    var getSplitView: ProjectSplitViewController? {
     
        get {
            return (self.childViewControllers[0] as? ProjectSplitViewController)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        
        // WebView
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.requiresUserActionForMediaPlayback = false
        configuration.applicationNameForUserAgent = "Codinator"
        
        webView = WKWebView(frame: bottomView.frame, configuration: configuration)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(webView!)
        
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Top, relatedBy: .Equal, toItem: webView, attribute: .Top, multiplier: 1.0, constant: 0.0))
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: webView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Left, relatedBy: .Equal, toItem: webView, attribute: .Left, multiplier: 1.0, constant: 0.0))
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Right, relatedBy: .Equal, toItem: webView, attribute: .Right, multiplier: 1.0, constant: 0.0))
        
        
        // webView
        if let splitViewController = getSplitView {
            splitViewController.webView = webView
        }
        
        // Override trait collection
        let horizontallyRegularTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        self.setOverrideTraitCollection(horizontallyRegularTraitCollection, forChildViewController: getSplitView!)

        
    }
    override func viewDidAppear(animated: Bool) {
        if let splitView = getSplitView {
            let projectName = splitView.projectManager.getSettingsDataForKey("ProjectName") as! String
            self.navigationController?.navigationBar.topItem?.title = projectName
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        getSplitView?.projectManager.close()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var searchBarVisible = false
    @IBAction func search(sender: UIBarButtonItem) {
        getSplitView?.dealWithSearchBar()
    }
    
    @IBOutlet var grabberConstraint: NSLayoutConstraint!
    @IBAction func grabber(sender: UIPanGestureRecognizer) {
        getSplitView?.webViewDidChange()

        grabberConstraint.constant = view.frame.height - sender.locationInView(view).y
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func left(sender: UIBarButtonItem) {
        if let splitViewController = getSplitView {
            UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                if splitViewController.preferredDisplayMode == .PrimaryHidden {
                    splitViewController.preferredDisplayMode = .Automatic
                } else {
                    splitViewController.preferredDisplayMode = .PrimaryHidden
                }
                
                }, completion: { (completion: Bool) in
                    
            })
        }
    }
    
    
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var grabberView: UIView!
    @IBAction func bottom(sender: UIBarButtonItem) {
        if bottomView.hidden == true {
            self.bottomView.hidden = false
            self.grabberView.hidden = false
            
            grabberConstraint.active = true
            bottomConstraint.active = false
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (completion: Bool) in
                    self.getSplitView?.webViewDidChange()
            })
        } else {
            grabberConstraint.active = false
            bottomConstraint.active = true
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (completion: Bool) in
                    self.bottomView.hidden = true
                    self.grabberView.hidden = true
                    
                    self.getSplitView?.webViewDidChange()

            })
        }
    }
    
    
    // MARK: - Trait Collection
    @IBOutlet weak var leftButton: UIBarButtonItem!

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown  {
            leftButton.enabled = false

            
            UIView.animateWithDuration(0.4, animations: { 
                self.getSplitView?.preferredDisplayMode = .PrimaryHidden
                }, completion: { bool in
                    self.getSplitView?.preferredDisplayMode = .PrimaryOverlay
            })
            
        }
        else {
            
            if self.view.traitCollection.horizontalSizeClass == .Regular {
                self.leftButton.enabled = true
                self.getSplitView!.preferredDisplayMode = .AllVisible
            }
            else if self.view.traitCollection.horizontalSizeClass == .Compact {
                leftButton.enabled = false
                
                self.getSplitView!.preferredDisplayMode = .PrimaryHidden
            }
            
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        if UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown  {
            
            self.getSplitView?.preferredDisplayMode = .PrimaryHidden
            
            leftButton.enabled = false
        }

    }
    
    
    
}
