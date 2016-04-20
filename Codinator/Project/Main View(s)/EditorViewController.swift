//
//  EditorViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate, WUTextSuggestionDisplayControllerDataSource, ProjectSplitViewControllerDelegate {
    let textView: HTMLTextView = HTMLTextView()
    
    var text: String? {
        get {
            return textView.text
        }
        
        set {
          textView.text = newValue
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
        
        // Subscribe to Delegate
        getSplitView.splitViewDelegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Keyboard Accessory
        if self.view.traitCollection.horizontalSizeClass == .Compact || self.view.traitCollection.verticalSizeClass == .Compact || UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            textView.inputAccessoryView = VWASAccessoryView(textView: textView)
    
        }
        else{
        
            textView.inputAccessoryView = nil;
            KOKeyboardRow.applyToTextView(textView)

        }
        
        // Keyboard show/hide notifications 
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: "changedWebViewSize", object: nil)
        
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
    
    // MARK: - Keyboard show/hide 
    
    var keyboardHeight: CGFloat = 0
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        dealWithAddingInsetsOnKeyboard()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
        
        var insets = textView.contentInset
        insets.bottom = 0
        
        textView.contentInset = insets
        textView.scrollIndicatorInsets = insets
    
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
    
    
    
    // MARK: - Auto Completion
    
    
    func textSuggestionDisplayController(textSuggestionDisplayController: WUTextSuggestionDisplayController!, suggestionDisplayItemsForSuggestionType suggestionType: WUTextSuggestionType, query suggestionQuery: String!) -> [AnyObject]! {
        if suggestionType == WUTextSuggestionType.At {
            var suggestionDisplayItems : [WUTextSuggestionDisplayItem] = []
            for name in self.filteredNamesUsingQuery(suggestionQuery) {
                let item = WUTextSuggestionDisplayItem(title: name)
                suggestionDisplayItems.append(item)
            }
            return suggestionDisplayItems
        }
        
        return nil;
    }
    
    func filteredNamesUsingQuery(query : String) -> [String] {
        if let filteredNames = self.names().filteredArrayUsingPredicate(NSPredicate(block: { (evaluatedObject : AnyObject, bindings: [String : AnyObject]?) -> Bool in
            if let evaluatedObject = evaluatedObject as? String {
                if evaluatedObject.lowercaseString.hasPrefix(query.lowercaseString) {
                    return true
                }
            }
            
            return false
        })) as? [String] {
            return filteredNames
        }
        
        return []
    }

    func names() -> NSArray {
        return ["h1>","/h1>","h2>","/h2>","h3>","/h3>","h4>","h5>","h6>","head>","body>","/body>","!Doctype html>","center>","img src=","a href=","font ","meta","table border=","tr>","td>","div>","div class=","style>","title>","li>","em>","p>","li>","section class=","header>","footer>","ul>","del>","em>","sub>","sup>","var>","cite>","dfn>","big>","small>","strong>","code>","frameset","blackquote>","br>"]
    }

    func range() {
    
        guard let rangeString = NSUserDefaults.standardUserDefaults().stringForKey("range") else {
            return
        }

        
        
        // Get string nearby the typing area
        let stringFromRange = (textView.text as NSString).substringWithRange( NSRange(location: textView.selectedRange.location - 10, length: 10))
        
        // Find where the tag starts
        let findTag = stringFromRange.characters.enumerate().filter { $0.element == "<"}.last?.index
    
        // Try to find the distance between the cursor and the beginning of the tag. Since we don't want to delete the tag we do +1
        let itemsToDeleteTillTag = stringFromRange.characters.count - findTag! - 1
        
        // Delete the charachters that are after the tag
        for _ in 1...itemsToDeleteTillTag {
            textView.deleteBackward()
        }
        
        
        
        // Complete the tag
        
        
        
        var checkString : String {
            if rangeString.characters.last == " " {
                return rangeString.substringToIndex(rangeString.endIndex.predecessor())
            }
            else {
                return rangeString
            }
        }
        
        
        // Check if tag needs closing tag or not and insert the tag
        switch checkString {
        case "h1>", "h2>", "h3>",  "h4>", "h5>", "h6>", "head>", "body>", "!Documentype html>", "center>", "tr>", "title>", "li>", "section>", "header>", "footer>", "ul>", "del>", "em>", "sub>", "sup>", "var>", "small>", "strong>", "code>", "blackquote>", "p>","h1> ", "h2> ", "h3> ",  "h4>", "h5> ", "h6> ", "head> ", "body> ", "!Documentype html> ", "center> ", "tr> ", "title> ", "li> ", "section> ", "header> ", "footer> ", "ul> ", "del> ", "em> ", "sub> ", "sup> ", "var> ", "small> ", "strong> ", "code> ", "blackquote> ", "p> ":
        
            let br = "</\(checkString)"
            
            textView.insertText(checkString + br)
            
            // Move cursor back +1 since count starts with 0
            self.moveCursorBy(br.characters.count, diretion: .Back)

            
        default:
            
            let br = "/\(checkString)"
            
            textView.insertText(br)
            //self.moveCursorBy(br.characters.count, diretion: .Forward)

        }
        
    
        
    }
    
    enum MoveCursorDirection {
        case Back
        case Forward
    }
    
    func moveCursorBy(number: Int, diretion: MoveCursorDirection) {
        let range = textView.selectedRange
        
        switch diretion {
        case .Back:
            textView.selectedRange = NSMakeRange(range.location - number, 0)

        case .Forward:
            textView.selectedRange = NSMakeRange(range.location + number, 0)
        }
       //textView.undoManager?.registerUndoWithTarget(self, selector: <#T##Selector#>, object: nil)
    
    }
    
    
    
}
