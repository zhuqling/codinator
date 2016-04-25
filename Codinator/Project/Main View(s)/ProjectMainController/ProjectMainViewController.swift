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

    
    var path: String!
    
    // Assistant Grabber
    
    @IBOutlet weak var assistantGrabberConstraint: NSLayoutConstraint!
    @IBOutlet weak var assistantConstraint: NSLayoutConstraint!
    @IBOutlet weak var assistantGrabberView: UIView!
    @IBOutlet var assistantView: UIView!
    
    // WebView Grabber
    
    @IBOutlet var grabberConstraint: NSLayoutConstraint!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var grabberView: UIView!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    
    
    var webView: WKWebView?
    var getSplitView: ProjectSplitViewController! {
     
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
        webView?.allowsLinkPreview = true
        
        webView?.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(webView!)
        
        
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Top, relatedBy: .Equal, toItem: webView, attribute: .Top, multiplier: 1.0, constant: 0.0))
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Bottom, relatedBy: .Equal, toItem: webView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Left, relatedBy: .Equal, toItem: webView, attribute: .Left, multiplier: 1.0, constant: 0.0))
        bottomView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: .Right, relatedBy: .Equal, toItem: webView, attribute: .Right, multiplier: 1.0, constant: 0.0))
        
        
        // webView
        getSplitView.webView = webView
        getSplitView.projectManager = Polaris(projectPath: path, currentView: nil, withWebServer: NSUserDefaults.standardUserDefaults().boolForKey("CnWebServer"), uploadServer: NSUserDefaults.standardUserDefaults().boolForKey("CnUploadServer"), andWebDavServer: NSUserDefaults.standardUserDefaults().boolForKey("CnWebDavServer"))
    
        
        // Override trait collection
        let horizontallyRegularTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        self.setOverrideTraitCollection(horizontallyRegularTraitCollection, forChildViewController: getSplitView!)

        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let projectName = getSplitView.projectManager.getSettingsDataForKey("ProjectName") as! String
            self.navigationController?.navigationBar.topItem?.title = projectName
            getSplitView.rootVC = self
        
        
        if self.isCompact {
            self.getSplitView?.preferredDisplayMode = .PrimaryOverlay
        }

        getSplitView.undoButton = undoButton
        getSplitView.redoButton = redoButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        
        print("Path 1: " + getSplitView!.projectManager.projectUserDirectoryPath() + "\nPath2: " + getSplitView!.projectManager.inspectorPath)
        
        
        
        if getSplitView?.projectManager.projectUserDirectoryPath() == getSplitView?.projectManager.inspectorPath {
            getSplitView?.projectManager.close()
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            getSplitView.filesTableView?.navigationController?.popViewControllerAnimated(true)
        }
        
        
    }
    
    @IBAction func search(sender: UIBarButtonItem) {
        getSplitView?.dealWithSearchBar()
    }
    
    
    var documentInteractionController: UIDocumentInteractionController?
    @IBAction func shareDidPush(sender: UIBarButtonItem) {
        
        // Create an NSURL for the file you want to send to another app
        let fileUrl = NSURL(fileURLWithPath: getSplitView!.projectManager.selectedFilePath)
        

        // Create the interaction controller
        documentInteractionController = UIDocumentInteractionController(URL: fileUrl)
        
        // Present the app picker display
        documentInteractionController!.presentOptionsMenuFromBarButtonItem(sender, animated: true)
    }
    

    
    // MARK: - Trait Collection

    var isCompact: Bool {
        get {
            return UIApplication.sharedApplication().statusBarOrientation == .Portrait || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown ||  self.view.traitCollection.horizontalSizeClass == .Compact ||  self.view.traitCollection.horizontalSizeClass == .Compact
        }
    }
    
    
    @IBOutlet var undoButton: UIBarButtonItem!
    @IBOutlet var redoButton: UIBarButtonItem!
    var removedOnce = false
    var firstStartHappened = false
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        
        // Hide undo button
        if self.view.frame.width >= 480 {
            
            if removedOnce {
                self.navigationItem.leftBarButtonItems?.append(undoButton)
                self.navigationItem.leftBarButtonItems?.append(redoButton)
                removedOnce = false
            }
        }
        else {
            
            if removedOnce == false {
                self.navigationItem.leftBarButtonItems?.removeLast()
                self.navigationItem.leftBarButtonItems?.removeLast()
                removedOnce = true
            }
            
        }
        
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        

    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "assistantView" {
            self.getSplitView!.assistantViewController = segue.destinationViewController as? AssistantViewController
        }
        
        
    }
    
    
}
