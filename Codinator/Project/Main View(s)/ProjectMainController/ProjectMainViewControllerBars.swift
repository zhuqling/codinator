//
//  ProjectMainViewControllerBars.swift
//  Codinator
//
//  Created by Vladimir Danila on 24/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension ProjectMainViewController {
    
    
    // MARK: - Panels
    
    
    @IBAction func left(sender: UIBarButtonItem) {
        if let splitViewController = getSplitView {
            
            if isCompact == false {
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                    
                    
                    if splitViewController.preferredDisplayMode == .PrimaryHidden {
                        splitViewController.preferredDisplayMode = .AllVisible
                    } else {
                        splitViewController.preferredDisplayMode = .PrimaryHidden
                    }
                    
                    }, completion: { (completion: Bool) in
                        
                })
                
            }
            else {
                
                Notifications.sharedInstance.alertWithMessage("Swipe from the left to the right to bring up the view", title: nil)
                
            }
        }
    }
    
    @IBAction func right(sender: UIBarButtonItem) {
        
        if isCompact {
            
            // View hidden
            if assistantGrabberConstraint.constant == 0 {
                assistantGrabberConstraint.constant = 216
                
                UIView.animateWithDuration(0.4) {
                    self.view.layoutIfNeeded()
                }

            }
            
            // Not hidden
            else {
                assistantGrabberConstraint.constant = 0
                
                UIView.animateWithDuration(0.4) {
                    self.view.layoutIfNeeded()
                }
            }
            
            
        }
        else {
            
            if assistantView.hidden == true {
                self.assistantView.hidden = false
                self.assistantGrabberView.hidden = false
                
                assistantGrabberConstraint.active = true
                assistantConstraint.active = false
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { (completion: Bool) in
                        
                        // Completed Animation
                        
                })
            } else {
                assistantGrabberConstraint.active = false
                assistantConstraint.active = true
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: .BeginFromCurrentState, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { (completion: Bool) in
                        self.assistantGrabberView.hidden = true
                        self.assistantView.hidden = true
                        
                        
                })
            }
        }
        
    }
    
    
    @IBAction func bottom(sender: UIBarButtonItem) {
        
        if isCompact {
            
            if grabberConstraint.constant == 0 {
                grabberConstraint.constant = 200
                getSplitView?.webViewDidChange()
                
                
                UIView.animateWithDuration(0.4) {
                    self.view.layoutIfNeeded()
                }
            }
            else {
                self.view.layoutIfNeeded()
                
                grabberConstraint.constant = 0
                getSplitView?.webViewDidChange()
                
                
                UIView.animateWithDuration(0.4) {
                    self.view.layoutIfNeeded()
                }
            }
            
        }
        else {
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
    }

    
    
    
    
    func hidesRightPanel() {
        assistantGrabberConstraint.active = false
        assistantConstraint.active = true
        
        self.assistantGrabberView.hidden = true
        self.assistantView.hidden = true
        
        self.view.layoutIfNeeded()
        
        
    }
    
    func showRightPanel() {
        self.assistantView.hidden = false
        self.assistantGrabberView.hidden = false
        
        assistantGrabberConstraint.active = true
        assistantConstraint.active = false
        
        self.view.layoutIfNeeded()
    }
    
    
    
    // MARK: - Grabbers
    
    @IBAction func assistantGrabber(sender: UIPanGestureRecognizer) {
        
        assistantGrabberConstraint.constant = view.frame.width - sender.locationInView(view).x
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.4) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func grabber(sender: UIPanGestureRecognizer) {
        getSplitView?.webViewDidChange()
        
        grabberConstraint.constant = view.frame.height - sender.locationInView(view).y
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
}