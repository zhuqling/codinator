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
    
    var document: PlaygroundDocument = PlaygroundDocument(fileURL: NSURL(fileURLWithPath: NSUserDefaults.standardUserDefaults().stringForKey("PlaygroundPath")!, isDirectory: false))
    
    var htmlTextView: PlaygroundTextView = PlaygroundTextView()
    var cssTextView: QEDTextView = QEDTextView()
    var jsTextView: JsTextView = JsTextView()
   
    
    var neuronText: String = ""
    var cssText: String = ""
    var jsText: String = ""
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var closeButton: UIButton!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        document.openWithCompletionHandler { (success) -> Void in
            
            if (success){
                if (self.document.contents.count == 3){
                    self.neuronText = self.document.contents[0] as! String
                    self.cssText = self.document.contents[1] as! String
                    self.jsText = self.document.contents[2] as! String
                }
            }
            else{
                //Error
                print("Error opening file")
            }
            
        }
        
        
        self.performSegueWithIdentifier("QSG", sender: self)
    }

    
    override func viewDidAppear(animated: Bool) {
 
        if (self.view.bounds.size.width <= 1000){
            
            let height = self.view.frame.size.height - self.webView.frame.size.height - 37
            self.rootHTML = CGRectMake(0, 37, self.view.bounds.size.width, height)
            
            self.rootCSS = rootHTML
            self.rootJS = rootHTML
            
        }
        else{
            
            rootHTML = CGRectMake(0, 37, self.view.bounds.width/3-3, self.view.bounds.size.height - self.webView.bounds.size.height - 37)
            rootCSS = CGRectMake(self.view.bounds.width/3, 37, self.view.bounds.width/3-3, self.view.bounds.size.height - self.webView.bounds.size.height - 37)
            rootJS = CGRectMake(self.view.bounds.width/3 * 2, 37, self.view.bounds.width/3, self.view.bounds.size.height - self.webView.bounds.size.height - 37)
            
        }
        
        
        
        self.htmlTextView = PlaygroundTextView(frame: rootHTML)
        self.cssTextView  = QEDTextView(frame: rootCSS)
        self.jsTextView   = JsTextView(frame: rootJS)
        
        self.htmlTextView.backgroundColor = UIColor.blackColor()
        self.cssTextView.backgroundColor = UIColor.blackColor()
        self.jsTextView.backgroundColor = UIColor.blackColor()
        
        let appearance = UIKeyboardAppearance.Dark
        
        self.htmlTextView.alwaysBounceVertical = true
        self.cssTextView.alwaysBounceVertical = true
        self.jsTextView.alwaysBounceVertical = true
        
        self.htmlTextView.keyboardAppearance = appearance
        self.cssTextView.keyboardAppearance = appearance
        self.jsTextView.keyboardAppearance = appearance
        
        self.htmlTextView.keyboardDismissMode = .Interactive
        self.cssTextView.keyboardDismissMode = .Interactive
        self.jsTextView.keyboardDismissMode = .Interactive
        
        self.htmlTextView.tintColor = UIColor.orangeColor()
        self.cssTextView.tintColor = UIColor.orangeColor()
        self.jsTextView.tintColor = UIColor.orangeColor()
        
        
        // Create keyboard
        
        // let snippet = UIBarButtonItem(title: "Tab", style: UIBarButtonItemStyle.Plain, target: self, action: "insertTab")
        let snippet = UIBarButtonItem(image: UIImage(named: "tab"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertTab))
        let snippetOne = UIBarButtonItem(image: UIImage(named: "quoteSign"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertStringSnippet))
        let snippetTwo = UIBarButtonItem(image: UIImage(named: "bracketOpenSC"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertOpenBracket))
        let snippetThree = UIBarButtonItem(image: UIImage(named: "bracketCloseSC"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertCloseBracket))
        let snippetFour = UIBarButtonItem(image: UIImage(named: "doubleDotsSC"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaygroundViewController.insertDoublePoint))
        
        let barButtonItems = [snippet,snippetOne, snippetTwo, snippetThree, snippetFour];
        
        let group = UIBarButtonItemGroup(barButtonItems: barButtonItems, representativeItem: nil)
        htmlTextView.inputAssistantItem.trailingBarButtonGroups = [group]
        
        
        
        
        self.htmlTextView.tag = 1
        self.cssTextView.tag = 2
        self.jsTextView.tag = 3
        
        self.view.addSubview(self.htmlTextView)
        self.view.addSubview(self.cssTextView)
        self.view.addSubview(self.jsTextView)
        
        
        self.closeButton.layer.masksToBounds = true
        self.closeButton.layer.cornerRadius = 5
        
        
        self.htmlTextView.text = neuronText
        self.cssTextView.text = cssText
        self.jsTextView.text = jsText
        self.setUpPlayground()
        
        
        
        
        
        self.htmlTextView.delegate = self
        self.cssTextView.delegate = self
        self.jsTextView.delegate = self
        
        if (self.view.bounds.size.width <= 1000){
            self.cssTextView.hidden = true
            self.jsTextView.hidden = true
        }
        
        
        let resizingMask: UIViewAutoresizing = [.FlexibleWidth, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
        
        self.htmlTextView.autoresizingMask = resizingMask
        self.cssTextView.autoresizingMask = resizingMask
        self.jsTextView.autoresizingMask = resizingMask
        

    }
    
    
    
    //MARK: Delegates
    
    func textViewDidChange(textView: UITextView) {
        
        let tmpPath = NSTemporaryDirectory()
        
        
        
        switch (textView.tag) {
        case 1:
            
            do{
                
                document.contents[0] = self.htmlTextView.text
                
                let cssString = self.document.contents[1] as! String
                let jsString = self.document.contents[2] as! String
                
                try Neuron.neuronCode(self.htmlTextView.text, cssString: cssString, jsString: jsString).writeToFile (tmpPath + "/index.html", atomically: true, encoding: NSUTF8StringEncoding)

            }
            catch{
            //ERROR
                
                
                print("Error copying file to tmp path")
                
            }
            
            
            
            
            break
        case 2:

            do{
                document.contents[1] = self.cssTextView.text
                
                let startingHTMLString = self.document.contents[0] as! String
                let jsString = self.document.contents[2] as! String
                
                try Neuron.neuronCode(startingHTMLString, cssString: cssTextView.text, jsString: jsString).writeToFile(tmpPath + "/index.html", atomically: true, encoding: NSUTF8StringEncoding)
            
            }
            catch{
                //ERROR
            }

            
            break
        case 3:

            do{
                document.contents[2] = self.jsTextView.text
                
                let startingHTMLString = self.document.contents[0] as! String
                let cssString = self.document.contents[1] as! String
                
                try Neuron.neuronCode(startingHTMLString, cssString: cssString, jsString: self.jsTextView.text).writeToFile(tmpPath + "/index.html", atomically: true, encoding: NSUTF8StringEncoding)
                
            }
            catch{
                //ERROR
            }
            
            break
            
        default:
            break
        }
        

        document.saveToURL(NSURL(fileURLWithPath: NSUserDefaults.standardUserDefaults().stringForKey("PlaygroundPath")!), forSaveOperation: UIDocumentSaveOperation.ForOverwriting) { (success) -> Void in
            
        }

        
        
        let url = NSURL(fileURLWithPath: tmpPath + "/index.html", isDirectory: false)
        let request = NSURLRequest(URL: url)
        
        self.webView.loadRequest(request)
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if (self.view.bounds.size.width >= 1000){
            
            var frame1 = self.htmlTextView.frame
            var frame2 = self.cssTextView.frame
            var frame3 = self.jsTextView.frame
            
            let noInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            self.htmlTextView.contentInset = noInsets
            self.cssTextView.contentInset = noInsets
            self.jsTextView.contentInset = noInsets

            textView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)

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
                
                self.htmlTextView.frame = frame1
                self.cssTextView.frame = frame2
                self.jsTextView.frame = frame3
                
                }, completion: nil)
            
        }
        
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
    
        
        if (self.view.bounds.size.width >= 1000){
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                
                self.htmlTextView.frame = self.rootHTML
                self.cssTextView.frame = self.rootCSS
                self.jsTextView.frame = self.rootJS
                
                }, completion: nil)
            
        }
        
    }
    
    
    
    //MARK: Set UP II
    
    func setUpPlayground() {
        
        let tmpPath = NSTemporaryDirectory()
        
        
        do{
            
            let startingHTMLString = self.document.contents[0] as! String
            let cssString = self.document.contents[1] as! String
            let jsString = self.document.contents[2] as! String
            
            try Neuron.neuronCode(startingHTMLString, cssString: cssString, jsString: jsString).writeToFile(tmpPath + "/index.html", atomically: true, encoding: NSUTF8StringEncoding)
        
        }
        catch {
            //ERROR
        }
        
        
        let url = NSURL(fileURLWithPath: tmpPath + "/index.html", isDirectory: false)
        let request = NSURLRequest(URL: url)
        
        self.webView.loadRequest(request)
        
    }
    
    
    
    //MARK: Small screen devices only
    
    
    
    @IBAction func segmentDidChanged(sender: AnyObject) {
        
        
        let segment: UISegmentedControl = sender as! UISegmentedControl
        
        switch (segment.selectedSegmentIndex){
            
        case 0:
            self.htmlTextView.hidden = false
            self.cssTextView.hidden = true
            self.jsTextView.hidden = true
            break
        case 1:
            self.htmlTextView.hidden = true
            self.cssTextView.hidden = false
            self.jsTextView.hidden = true
            break
        case 2:
            self.htmlTextView.hidden = true
            self.cssTextView.hidden = true
            self.jsTextView.hidden = false
            break
        default:
            break
        }
        
    }
    

    
    //MARK: Snippets

    func insertTab(){
        self.htmlTextView.insertText("    ");
    }
    
    func insertStringSnippet(){
        self.htmlTextView.insertText("\"");
    }

    func insertOpenBracket(){
        self.htmlTextView.insertText("(");
    }
    
    func insertCloseBracket(){
        self.htmlTextView.insertText(")");
    }
    
    func insertDoublePoint(){
        self.htmlTextView.insertText(":");
    }
    
    
    //MARK: Extra
    
    @IBAction func closeDidPush(sender: AnyObject) {
        
        document.saveToURL(NSURL(fileURLWithPath: NSUserDefaults.standardUserDefaults().stringForKey("PlaygroundPath")!), forSaveOperation: UIDocumentSaveOperation.ForOverwriting) { (success) -> Void in
            
            if (success){
                
                self.document.closeWithCompletionHandler({ (success) -> Void in
                    if (success){
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                })
            }

        }
        

        
        
        
    }
    
    
    @IBAction func actionsDidPush(sender: AnyObject) {
        
        let button = sender as! UIButton
        
        let popup = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        popup.view.tintColor = UIColor.orangeColor()
        
        popup.popoverPresentationController?.sourceView = button.superview
        popup.popoverPresentationController?.sourceRect = button.frame
        
        
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
            
            
            let startingHTMLString = self.document.contents[0] as! String
            let cssString = self.document.contents[1] as! String
            let jsString = self.document.contents[2] as! String
            
            pasteboard.string = Neuron.neuronCode(startingHTMLString, cssString: cssString, jsString: jsString)
            
        }
        
        
        let documetationAction = UIAlertAction(title: "Neuron Documentation 📚", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let url: NSURL = NSURL(string: "http://vwas.cf/neuron/docs")!
            
            let safariVC: SFSafariViewController = SFSafariViewController(URL: url)
            safariVC.view.tintColor = UIColor.orangeColor()
            self.presentViewController(safariVC, animated: true, completion: nil)
            
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        popup.addAction(printAction)
        popup.addAction(convertAction)
        popup.addAction(documetationAction)
        popup.addAction(cancel)
        
        self.presentViewController(popup, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func playgroundDidPush(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Playground - noun:", message: "A place where people can play and prototype stuff...\n\nVersion 1.0\n(Compatible with Polaris 1.3+)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.blackColor()
        
        let closeAlert = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(closeAlert)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: Layout Managing

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if (self.view.bounds.size.width <= 1000){
            
            let height = self.view.frame.size.height - self.webView.frame.size.height - 37
            self.rootHTML = CGRectMake(0, 37, self.view.bounds.size.width, height)
            
            self.rootCSS = rootHTML
            self.rootJS = rootHTML
            
        }
        else{
            
            rootHTML = CGRectMake(0, 37, self.view.bounds.width/3-3, self.view.bounds.size.height - self.webView.bounds.size.height - 37)
            rootCSS = CGRectMake(self.view.bounds.width/3, 37, self.view.bounds.width/3-3, self.view.bounds.size.height - self.webView.bounds.size.height - 37)
            rootJS = CGRectMake(self.view.bounds.width/3 * 2, 37, self.view.bounds.width/3, self.view.bounds.size.height - self.webView.bounds.size.height - 37)
            
        }
        
        self.htmlTextView.frame = rootHTML
        self.cssTextView.frame = rootCSS
        self.jsTextView.frame = rootJS
        
        
    }
    
}
