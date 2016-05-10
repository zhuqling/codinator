//
//  EditorViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate, ProjectSplitViewControllerDelegate, UISearchBarDelegate, SnippetsDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    let htmlTextView = HTMLTextView()
    let jsTextView = JsTextView()
    let cssTextView = CSSTextView()
    
    
    var text: String? {
        get {
            if let polaris = unsafeProjectManager {
                let fileExtension = polaris.selectedFileURL.pathExtension!
                switch fileExtension {
                case "css":
                    return cssTextView.text
                case "js":
                    return jsTextView.text
                    
                default:
                    return htmlTextView.text
                }
            }
            else {
                return htmlTextView.text
            }
        }
        
        set {
            let fileExtension = projectManager.selectedFileURL.pathExtension!
            
            switch fileExtension {
            case "css":
                cssTextView.text = newValue
                cssTextView.undoManager!.removeAllActions()
                jsTextView.hidden = true
                htmlTextView.hidden = true
                cssTextView.hidden = false
                
                if htmlTextView.isFirstResponder() {
                    htmlTextView.resignFirstResponder()
                    cssTextView.becomeFirstResponder()
                }
                
                if jsTextView.isFirstResponder() {
                    jsTextView.resignFirstResponder()
                    cssTextView.becomeFirstResponder()
                }
                
                
            case "js":
                jsTextView.text = newValue
                jsTextView.undoManager!.removeAllActions()
                cssTextView.hidden = true
                htmlTextView.hidden = true
                jsTextView.hidden = false
                
                if htmlTextView.isFirstResponder() {
                    htmlTextView.resignFirstResponder()
                    jsTextView.becomeFirstResponder()
                }
                
                if cssTextView.isFirstResponder() {
                    cssTextView.resignFirstResponder()
                    jsTextView.becomeFirstResponder()
                }
                
            default:
                htmlTextView.text = newValue
                htmlTextView.undoManager!.removeAllActions()
                jsTextView.hidden = true
                cssTextView.hidden = true
                htmlTextView.hidden = false
                
                if jsTextView.isFirstResponder() {
                    jsTextView.resignFirstResponder()
                    htmlTextView.becomeFirstResponder()
                }
                
                if cssTextView.isFirstResponder() {
                    cssTextView.resignFirstResponder()
                    htmlTextView.becomeFirstResponder()
                }
            }
            
        }
    }
    
    
    private var textView: CYRTextView {
        get {
            let fileExtension = projectManager.selectedFileURL.pathExtension!
            switch fileExtension {
            case "css":
                return cssTextView
            case "js":
                return jsTextView
                
            default:
                return htmlTextView
            }
        }
    }
    
    var getSplitView: ProjectSplitViewController! {
        
        get {
            return self.splitViewController as! ProjectSplitViewController
        }
        
    }
    
    private var unsafeProjectManager: Polaris? {
        get {
            return getSplitView.projectManager
        }
    }
    
    var projectManager: Polaris! {
        get {
            return getSplitView.projectManager
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextView(jsTextView)
        setUpTextView(cssTextView)
        setUpTextView(htmlTextView)

        
        // Auto Completion
        let suggestionDisplayController = WUTextSuggestionDisplayController()
        suggestionDisplayController.dataSource = self
        let suggestionController = WUTextSuggestionController(textView: htmlTextView, suggestionDisplayController: suggestionDisplayController)
        suggestionController.suggestionType = .At
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(range), name: "range", object: nil)

        
        
        view.layoutSubviews()
        
        // Subscribe to Delegates
        getSplitView.splitViewDelegate = self
        
        // Set up notification view
        Notifications.sharedInstance.viewController = self
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpKeyboardForTextView(htmlTextView)
        setUpKeyboardForTextView(cssTextView)
        setUpKeyboardForTextView(jsTextView)
        
        
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
            
            let fileURL = self.projectManager.selectedFileURL
            let root = self.projectManager.selectedFileURL.URLByDeletingLastPathComponent
            
            dispatch_async(dispatch_get_main_queue(), { 
                if let splitViewController = self.splitViewController as? ProjectSplitViewController {
                    splitViewController.webView!.loadFileURL(fileURL, allowingReadAccessToURL: root!)
                }
            })
            
            do {
                try textView.text.writeToURL(self.projectManager.selectedFileURL, atomically: false, encoding: NSUTF8StringEncoding)
            } catch {
                
            }
            
        }
        
        NSOperationQueue.mainQueue().addOperation(operation)
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
        
            // Get the line
            let line = (textView.text as NSString).substringToIndex(range.location)
                .componentsSeparatedByString("\n")
                .last!

            
            // Get indent
            var indentingString: String {
                let characters = line.characters
                var indentations = ""
                
                for character in characters {
                    if character == " " {
                        indentations += String(character)
                    }
                    else {
                        break
                    }
                }
                return indentations
            }
            
            // line break + indent
            textView.insertText("\n" + indentingString)
            return false
        }
        else if range.length == 1 {
            
            // Get the line
            let line = (textView.text as NSString).substringToIndex(range.location + 1)
                .componentsSeparatedByString("\n")
                .last!

            
            let containsOtherCharacters = line.characters.filter { $0 != " " }
            
            // if there's a indentation delete 4 characters at once
            if containsOtherCharacters.count == 0 && line.characters.count != 0{
                textView.deleteBackward()
                textView.deleteBackward()
                textView.deleteBackward()
                textView.deleteBackward()
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
    
    
    // MARK: - Searchbar
    
    //Show searchbar and add insets
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    func searchBarAppeared() {
        
        searchBar.hidden = false
        
        view.layoutIfNeeded()
        searchBarTopConstraint.constant = 0

        var insets = htmlTextView.contentInset
        insets.top = searchBar.frame.height
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()

            self.htmlTextView.contentInset = insets
            self.htmlTextView.scrollIndicatorInsets = insets
        }, completion : { bool in
          self.searchBar.becomeFirstResponder()
        })
    }
    
    // Hide searchbar and reset insets
    func searchBarDisAppeard() {
        
        searchBar.hidden = true
        
        view.layoutIfNeeded()
        searchBarTopConstraint.constant = -searchBar.frame.height
        
        var insets = htmlTextView.contentInset
        insets.top = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
            
            self.htmlTextView.contentInset = insets
            self.htmlTextView.scrollIndicatorInsets = insets

            
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
            let range = (htmlTextView.text as NSString).rangeOfString(text, options: .CaseInsensitiveSearch)
            
            if range.location == NSNotFound {
                Notifications.sharedInstance.displayErrorMessage("No occupancy found!")
            }
            else {
                htmlTextView.becomeFirstResponder()
                htmlTextView.selectedRange = range
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
        
        var insets = htmlTextView.contentInset
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
        var insets = htmlTextView.contentInset
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
        
        htmlTextView.resignFirstResponder()
        
    }
    
    
}
