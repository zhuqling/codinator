//
//  PlaygroundViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 29/06/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

import UIKit
import SafariServices

class PlaygroundViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var changeFileSegment: UISegmentedControl!
    
    var rootHTML: CGRect = CGRect()
    var rootCSS: CGRect = CGRect()
    var rootJS: CGRect = CGRect()
    
    var document: PlaygroundDocument!
    var filePath: String!

    
    var neuronTextView: NeuronTextView = NeuronTextView()
    var cssTextView: HTMLTextView = HTMLTextView()
    var jsTextView: JsTextView = JsTextView()
   
    
    var neuronText: String = ""
    var cssText: String = ""
    var jsText: String = ""
    
    
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var textViewSpace: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        document = PlaygroundDocument(fileURL: NSURL(fileURLWithPath: filePath, isDirectory: false))
        document.openWithCompletionHandler { (success) -> Void in
            
            if (success){
                self.neuronText = self.document.embeddedFile(.Neuron)
                self.cssText = self.document.embeddedFile(.CSS)
                self.jsText = self.document.embeddedFile(.JS)
                
                
                self.navigationItem.title = (self.document.fileURL.lastPathComponent! as NSString).stringByDeletingPathExtension + " Playground"
                
            }
            else{
                //Error
                print("Error opening file")
            }
            
        }
        
        
        // Set up frames
        
        self.applyFramesForViewSize(self.textViewSpace.frame.size)
        
        self.neuronTextView.backgroundColor = UIColor.blackColor()
        self.cssTextView.backgroundColor = UIColor.blackColor()
        self.jsTextView.backgroundColor = UIColor.blackColor()
        
        
        // Add to subView
        self.textViewSpace.addSubview(self.neuronTextView)
        self.textViewSpace.addSubview(self.cssTextView)
        self.textViewSpace.addSubview(self.jsTextView)
        
        
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        applyFramesForViewSize(textViewSpace.frame.size)
        let appearance = UIKeyboardAppearance.Dark
        
        self.neuronTextView.alwaysBounceVertical = true
        self.cssTextView.alwaysBounceVertical = true
        self.jsTextView.alwaysBounceVertical = true
        
        self.neuronTextView.keyboardAppearance = appearance
        self.cssTextView.keyboardAppearance = appearance
        self.jsTextView.keyboardAppearance = appearance
        
        self.neuronTextView.keyboardDismissMode = .Interactive
        self.cssTextView.keyboardDismissMode = .Interactive
        self.jsTextView.keyboardDismissMode = .Interactive
        
        let textViewTintColor = UIColor.whiteColor()
        self.neuronTextView.tintColor = textViewTintColor
        self.cssTextView.tintColor = textViewTintColor
        self.jsTextView.tintColor = textViewTintColor
        
        
        // Create keyboard
        
        let snippet = UIBarButtonItem(image: UIImage(named: "tab"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertTab))
        let snippetOne = UIBarButtonItem(image: UIImage(named: "quoteSign"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertStringSnippet))
        let snippetTwo = UIBarButtonItem(image: UIImage(named: "bracketOpenSC"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertOpenBracket))
        let snippetThree = UIBarButtonItem(image: UIImage(named: "bracketCloseSC"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertCloseBracket))
        let snippetFour = UIBarButtonItem(image: UIImage(named: "doubleDotsSC"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertDoublePoint))
        
        let barButtonItems = [snippet,snippetOne, snippetTwo, snippetThree, snippetFour];
        
        let group = UIBarButtonItemGroup(barButtonItems: barButtonItems, representativeItem: nil)
        neuronTextView.inputAssistantItem.trailingBarButtonGroups = [group]
        
        
        
        
        self.neuronTextView.tag = 1
        self.cssTextView.tag = 2
        self.jsTextView.tag = 3
    
        
        
        self.neuronTextView.text = neuronText
        self.cssTextView.text = cssText
        self.jsTextView.text = jsText
        self.setUpPlayground()
        
        
        
        
        self.neuronTextView.delegate = self
        self.cssTextView.delegate = self
        self.jsTextView.delegate = self
        
        if (self.view.bounds.size.width <= 1000){
            self.cssTextView.hidden = true
            self.jsTextView.hidden = true
        }
        
        
        let resizingMask: UIViewAutoresizing = [.FlexibleWidth, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
        
        self.neuronTextView.autoresizingMask = resizingMask
        self.cssTextView.autoresizingMask = resizingMask
        self.jsTextView.autoresizingMask = resizingMask
        
        
        let key = "PlaygroundQSGWasDisplayedOnce"
        let display = NSUserDefaults.standardUserDefaults().boolForKey(key)
        
        if display == false {
            self.performSegueWithIdentifier("QSG", sender: self)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: key)
        }
        
    }
    
    
    
    //MARK: Delegates
    
    func textViewDidChange(textView: UITextView) {
        
        let tmpPath = NSTemporaryDirectory()
        
        // Save the recent change
        switch (textView.tag) {
        
        case 1:
            document.setFile(.Neuron, toFile: neuronTextView.text)
        
        case 2:
            document.setFile(.CSS, toFile: cssTextView.text)
        
        case 3:
            document.setFile(.JS, toFile: jsTextView.text)
        
        default:
            break
        }
        
        
        let neuronString = document.embeddedFile(.Neuron)
        let cssString = document.embeddedFile(.CSS)
        let jsString = document.embeddedFile(.JS)
        
        try! Neuron.neuronCode(neuronString, cssString: cssString, jsString: jsString).writeToFile(tmpPath + "/index.html", atomically: true, encoding: NSUTF8StringEncoding)

            
        document.saveToURL(document.fileURL, forSaveOperation: .ForOverwriting) { (success) -> Void in
            
        }
        
        
        
        let url = NSURL(fileURLWithPath: tmpPath + "/index.html", isDirectory: false)
        let request = NSURLRequest(URL: url)
        
        self.webView.loadRequest(request)
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if (self.view.bounds.size.width >= 1000){
            
            var frame1 = self.neuronTextView.frame
            var frame2 = self.cssTextView.frame
            var frame3 = self.jsTextView.frame
            
            let noInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            self.neuronTextView.contentInset = noInsets
            self.cssTextView.contentInset = noInsets
            self.jsTextView.contentInset = noInsets

            let insets =  UIEdgeInsetsMake(0, 0, 45, 0)
            textView.contentInset = insets
            textView.scrollIndicatorInsets = insets
            
            self.changeFileSegment.selectedSegmentIndex = textView.tag - 1
            
            switch (textView.tag) {
                case 1:
                    
                    frame1.size.width = self.view.frame.size.width - 48 * 2 - 4
                    
                    frame2.origin.x = self.view.frame.size.width - 48 * 2 - 2
                    frame2.size.width = 48
                    
                    frame3.origin.x = self.view.frame.size.width - 48
                    frame3.size.width = 48
                    break
                case 2:
                    frame1.size.width = 48
                    
                    frame2.origin.x  = 50
                    frame2.size.width = self.view.frame.size.width - 48 * 2 - 4
                    
                    frame3.origin.x = self.view.frame.size.width - 48
                    frame3.size.width = 48
                    break
                case 3:
                    frame1.size.width = 48
                    
                    frame2.origin.x = 50
                    frame2.size.width = 48
                    
                    frame3.origin.x = 48 * 2 + 4
                    frame3.size.width = self.view.frame.size.width - 48 * 2 - 4
                    break
                
                default:
                    break
            }
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.neuronTextView.frame = frame1
                self.cssTextView.frame = frame2
                self.jsTextView.frame = frame3
                
                }, completion: nil)
            
        }
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {


        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            let noInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            textView.contentInset = noInsets
            textView.scrollIndicatorInsets = noInsets
            
            self.applyFramesForViewSize(self.textViewSpace.frame.size)
            
            }, completion: nil)
        
    }
    
    
    
    //MARK: Set UP II
    
    func setUpPlayground() {
        
        let tmpPath = NSTemporaryDirectory()
        
        let startingNeuronString = document.embeddedFile(.Neuron)
        let cssString = document.embeddedFile(.CSS)
        let jsString = document.embeddedFile(.JS)
            
        try! Neuron.neuronCode(startingNeuronString, cssString: cssString, jsString: jsString).writeToFile(tmpPath + "/index.html", atomically: true, encoding: NSUTF8StringEncoding)
        
        
        let url = NSURL(fileURLWithPath: tmpPath + "/index.html", isDirectory: false)
        let request = NSURLRequest(URL: url)
        
        self.webView.loadRequest(request)
        
    }
    
    
    
    //MARK: Small screen devices only
    
    
    
    @IBAction func segmentDidChanged(sender: UISegmentedControl) {
        
        
        switch (sender.selectedSegmentIndex){
            
        case 0:
            self.neuronTextView.hidden = false
            self.cssTextView.hidden = true
            self.jsTextView.hidden = true
            break
        case 1:
            self.neuronTextView.hidden = true
            self.cssTextView.hidden = false
            self.jsTextView.hidden = true
            break
        case 2:
            self.neuronTextView.hidden = true
            self.cssTextView.hidden = true
            self.jsTextView.hidden = false
            break
        default:
            break
        }
        
        
        
    }
    

    
    //MARK: Snippets

    func insertTab(){
        self.neuronTextView.insertText("    ");
    }
    
    func insertStringSnippet(){
        self.neuronTextView.insertText("\"");
    }

    func insertOpenBracket(){
        self.neuronTextView.insertText("(");
    }
    
    func insertCloseBracket(){
        self.neuronTextView.insertText(")");
    }
    
    func insertDoublePoint(){
        self.neuronTextView.insertText(":");
    }
    
    
    //MARK: Extra
    
    @IBAction func closeDidPush(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func actionsDidPush(sender: UIBarButtonItem) {
        
        let popup = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        popup.view.tintColor = UIColor.orangeColor()
        
        popup.popoverPresentationController?.barButtonItem = sender
        
        
        let printAction = UIAlertAction(title: "Print 📠", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let pi = UIPrintInfo.printInfo()
            pi.outputType = UIPrintInfoOutputType.General
            pi.jobName = "Print Playground"
            pi.orientation = UIPrintInfoOrientation.Portrait
            pi.duplex = UIPrintInfoDuplex.LongEdge
            
            
            let pic = UIPrintInteractionController.sharedPrintController()
            pic.printInfo = pi
            pic.showsPageRange = true
            pic.printFormatter = self.webView.viewPrintFormatter()
            
            pic.presentAnimated(true, completionHandler: nil)
            
        }
        
        let convertAction = UIAlertAction(title: "Copy Converted to Clipboard 📎", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let pasteboard = UIPasteboard.generalPasteboard()
            
            
            let startingNeuronString = self.document.embeddedFile(.Neuron)
            let cssString = self.document.embeddedFile(.CSS)
            let jsString = self.document.embeddedFile(.JS)
            
            pasteboard.string = Neuron.neuronCode(startingNeuronString, cssString: cssString, jsString: jsString)
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        popup.addAction(printAction)
        popup.addAction(convertAction)
        popup.addAction(cancel)
        
        self.presentViewController(popup, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func documentationDidPush(sender: UIBarButtonItem) {
        
        let popup = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        popup.view.tintColor = UIColor.orangeColor()
        
        popup.popoverPresentationController?.barButtonItem = sender
        
        let documetationAction = UIAlertAction(title: "Neuron Documentation 📚", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let url: NSURL = NSURL(string: "http://vwas.cf/neuron/docs")!
            
            let safariVC: SFSafariViewController = SFSafariViewController(URL: url)
            safariVC.view.tintColor = self.view.tintColor
            
            safariVC.modalPresentationStyle = .FormSheet
            
            self.presentViewController(safariVC, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        popup.addAction(documetationAction)
        popup.addAction(cancelAction)
        
        self.presentViewController(popup, animated: true, completion: nil)
        
        self.neuronTextView.frame = rootHTML
        self.cssTextView.frame = rootCSS
        self.jsTextView.frame = rootJS
        
    }
    
    // MARK: - Frames
    
    func applyFramesForViewSize(size: CGSize) {
        
        // Set up frames
        
        if (size.width <= 1000){
            
            self.rootHTML = CGRectMake(0, 0, self.view.bounds.size.width, size.height)
            self.rootCSS = rootHTML
            self.rootJS = rootHTML
            
            changeFileSegment.hidden = false
            
        }
        else{
            
            rootHTML = CGRectMake(0, 0, self.view.bounds.width/3-3, size.height)
            rootCSS = CGRectMake(self.view.bounds.width/3, 0, self.view.bounds.width/3-3, size.height)
            rootJS = CGRectMake(self.view.bounds.width/3 * 2, 0, self.view.bounds.width/3, size.height)
            
            changeFileSegment.hidden = true
        }

        
        self.neuronTextView.frame = rootHTML
        self.cssTextView.frame = rootCSS
                self.jsTextView.frame = rootJS

        
        
    }
    
    //MARK: Layout Managing

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        applyFramesForViewSize(size)
        
    }
    
}
