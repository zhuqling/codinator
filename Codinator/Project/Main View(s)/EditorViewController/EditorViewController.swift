//
//  EditorViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate, WUTextSuggestionDisplayControllerDataSource, ProjectSplitViewControllerDelegate, UISearchBarDelegate, SnippetsDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    let textView: HTMLTextView = HTMLTextView()
    
    
    var text: String? {
        get {
            return textView.text
        }
        
        set {
            textView.text = newValue
            textView.undoManager!.removeAllActions()
        }
    }
    
    var getSplitView: ProjectSplitViewController! {
        
        get {
            return self.splitViewController as! ProjectSplitViewController
        }
        
    }
    
    var projectManager: Polaris! {
        get {
            return getSplitView.projectManager
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setting up TextView
        textView.frame = self.view.frame
        textView.text = text
        textView.delegate = self
        textView.tintColor = UIColor.whiteColor()
        textView.alwaysBounceVertical = true
        
        view.addSubview(textView)
        textView.bindFrameToSuperviewBounds()

        
        // Keyboard
        textView.inputAssistantItem.trailingBarButtonGroups = []
        textView.inputAssistantItem.leadingBarButtonGroups = []
        
        
        // Auto Completion
        let suggestionDisplayController = WUTextSuggestionDisplayController()
        suggestionDisplayController.dataSource = self
        let suggestionController = WUTextSuggestionController(textView: textView, suggestionDisplayController: suggestionDisplayController)
        suggestionController.suggestionType = .At
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(range), name: "range", object: nil)

        
        
        view.layoutSubviews()
        
        // Subscribe to Delegates
        getSplitView.splitViewDelegate = self
//        searchBar.delegate = self
        
        // Set up notification view
        Notifications.sharedInstance.viewController = self
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Keyboard Accessory
        if self.view.traitCollection.horizontalSizeClass == .Compact || self.view.traitCollection.verticalSizeClass == .Compact || UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            textView.inputAccessoryView = VWASAccessoryView(textView: textView)
    
        }
        else{
        
            textView.inputAccessoryView = nil;
            KOKeyboardRow.applyToTextView(textView)

        }
        
        getSplitView.assistantViewController!.delegate = self
        
        
        // Keyboard show/hide notifications 
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: "changedWebViewSize", object: nil)
        
        self.view.bringSubviewToFront(searchBar)
        searchBar.keyboardAppearance = .Dark
        
    }

    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    
        // Remove Keyboard show/hide notifications
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let operation = NSOperation()
        operation.queuePriority = .Low
        operation.qualityOfService = .Background
        operation.completionBlock = {
            
            let fileURL = NSURL(fileURLWithPath: self.projectManager.selectedFilePath, isDirectory: false)
            let root = NSURL(fileURLWithPath: (self.projectManager.selectedFilePath as NSString).stringByDeletingLastPathComponent, isDirectory: true)
            
            dispatch_async(dispatch_get_main_queue(), { 
                if let splitViewController = self.splitViewController as? ProjectSplitViewController {
                    splitViewController.webView!.loadFileURL(fileURL, allowingReadAccessToURL: root)
                }
            })
            
            do {
                try textView.text.writeToFile(self.projectManager.selectedFilePath, atomically: false, encoding: NSUTF8StringEncoding)
            } catch {
                
            }
            
        }
        
        NSOperationQueue.mainQueue().addOperation(operation)
    
    }
    
    
    // MARK: - Searchbar
    
    //Show searchbar and add insets
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    func searchBarAppeared() {
        
        searchBar.hidden = false
        
        view.layoutIfNeeded()
        searchBarTopConstraint.constant = 0

        var insets = textView.contentInset
        insets.top = searchBar.frame.height
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()

            self.textView.contentInset = insets
            self.textView.scrollIndicatorInsets = insets
        }, completion : { bool in
          self.searchBar.becomeFirstResponder()
        })
    }
    
    // Hide searchbar and reset insets
    func searchBarDisAppeard() {
        
        searchBar.hidden = true
        
        view.layoutIfNeeded()
        searchBarTopConstraint.constant = -searchBar.frame.height
        
        var insets = textView.contentInset
        insets.top = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
            
            self.textView.contentInset = insets
            self.textView.scrollIndicatorInsets = insets

            
            }, completion: { bool in
                self.searchBar.resignFirstResponder()
                self.searchBar.hidden = true
            })
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        getSplitView.searchBarDissappeared()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // Search algorithm
        searchForText(searchBar.text!)
        getSplitView.searchBarDissappeared()
        
    }
    
    var startedSearchInstance = false
    func searchForText(text: String) {
            let range = (textView.text as NSString).rangeOfString(text, options: .CaseInsensitiveSearch)
            
            if range.location == NSNotFound {
                Notifications.sharedInstance.displayErrorMessage("No occupancy found!")
            }
            else {
                textView.becomeFirstResponder()
                textView.selectedRange = range
            }
        
    }
    
    
    
    
    // MARK: - Keyboard show/hide 
    
    var keyboardHeight: CGFloat = 0
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        dealWithAddingInsetsOnKeyboard()
        
        getSplitView.undoButton.enabled = true
        getSplitView.redoButton.enabled = true

    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
        
        var insets = textView.contentInset
        insets.bottom = 0
        
        textView.contentInset = insets
        textView.scrollIndicatorInsets = insets
        
        
        getSplitView.undoButton.enabled = false
        getSplitView.redoButton.enabled = false
    
    }
    
    func webViewSizeDidChange() {
        if keyboardHeight != 0 {
            dealWithAddingInsetsOnKeyboard()
        }
    }
    
    let grabberViewHeight = CGFloat(15)
    func dealWithAddingInsetsOnKeyboard() {
        
        var insetValue: CGFloat = 0
        
        // Create insets depending: if the webivew is on screen and bigger than the webView
        let keyboardHigher = (getSplitView.webView!.frame.height + grabberViewHeight) < keyboardHeight
    
        if keyboardHigher {
            
            // Make sure the webView is on screen otherwise dont include it in the calculations
            if getSplitView.webViewOnScreen {
                insetValue = keyboardHeight - getSplitView.webView!.frame.height - grabberViewHeight
            }
            else {
                insetValue = keyboardHeight
            }
        }
    
        
        // Apply insets
        var insets = textView.contentInset
        insets.bottom = insetValue
        
        textView.contentInset = insets
        textView.scrollIndicatorInsets = insets

    }
    
    
    // MARK: - AssistantViewController
    
    func snippetWasCoppied(status: String) {
        
        print("status: " + status)
        
        if status == "copied" {
            Notifications.sharedInstance.displayNeutralMessage("Snippet was copied")
        }
        else {
            Notifications.sharedInstance.displayNeutralMessage("Fill out all the fields.")
        }
    }
    
    func colorDidChange(color: UIColor) {
        
        let colorHex = color.toHexString()
        
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = colorHex
        
        Notifications.sharedInstance.displayNeutralMessage("HEX Color was copied")

        
    }
    

    

    // MARK: - Split View
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        textView.resignFirstResponder()
        
    }
    
    
}
