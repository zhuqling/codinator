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

    var webView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let splitViewController = self.childViewControllers[0] as? ProjectSplitViewController {
            splitViewController.webView = webView
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func search(sender: UIBarButtonItem) {
        
    }
    
    @IBOutlet var grabberConstraint: NSLayoutConstraint!
    @IBAction func grabber(sender: UIPanGestureRecognizer) {
        grabberConstraint.constant = view.frame.height - sender.locationInView(view).y
    }
    
    @IBAction func left(sender: UIBarButtonItem) {
        if let splitViewController = self.childViewControllers[0] as? ProjectSplitViewController {
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
                    
            })
        } else {
            grabberConstraint.active = false
            bottomConstraint.active = true
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (completion: Bool) in
                    self.bottomView.hidden = true
                    self.grabberView.hidden = true
            })
        }
    }
}
