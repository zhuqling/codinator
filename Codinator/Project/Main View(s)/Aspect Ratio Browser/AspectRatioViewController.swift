//
//  AspectRatioViewController.swift
//  VWAS-HTML
//
//  Created by Vladimir on 01/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import UIKit
import WebKit


class AspectRatioViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet weak var effectPannel: UIVisualEffectView!
    @IBOutlet weak var easterEggLabel: UILabel!
    
    
    var webView: WKWebView!
    
    
    let previewPath: NSString = NSUserDefaults.standardUserDefaults().stringForKey("aspectPreviewPath")!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Round Corner
        closeButton.layer.cornerRadius = 5
        
        // Configure WebView
        let configuration = WKWebViewConfiguration()
     
        configuration.applicationNameForUserAgent = "Codinator"
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.requiresUserActionForMediaPlayback = false
        configuration.allowsPictureInPictureMediaPlayback = true
        
        
        
        // Display up WebView
        webView = WKWebView(frame: CGRect(x: 0, y: 45, width: self.view.frame.width, height: self.view.frame.height), configuration:configuration)
        self.view.insertSubview(webView, belowSubview: effectPannel)
    
        // Autoresizing for webview
        webView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleHeight, .FlexibleWidth]
        
        
        // Round Corners for Effect Pannel
        let maskPath2 = UIBezierPath(roundedRect: effectPannel.bounds, byRoundingCorners: .TopLeft, cornerRadii: CGSizeMake(10.0, 10.0))
        
        let maskLayer2 = CAShapeLayer()
        maskLayer2.frame = self.view.bounds
        maskLayer2.path = maskPath2.CGPath
        self.effectPannel.layer.mask = maskLayer2
        
        
        // Add the icon at bottom for a neat easter egg
        let dataBase = ["🐍","🐰","🚄","✈️","🚇","🚲","☕️","📚","🐍","🐰","🚄","✈️","🚇","🚲","☕️","⏳","🐝","🚀"]
        
        let int = arc4random_uniform(UInt32(dataBase.count))
        easterEggLabel.text = dataBase[Int(int)]
        
        
    }

    override func viewDidAppear(animated: Bool) {
        
        let url = NSURL(fileURLWithPath: previewPath as String)

        // Load url
        webView.loadFileURL(url, allowingReadAccessToURL: NSURL(fileURLWithPath:(previewPath.stringByDeletingLastPathComponent), isDirectory: true))
        
    
        
    }
    
    
    // MARK: - Shortcuts
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override var keyCommands: [UIKeyCommand]? {
        
        return [UIKeyCommand(input: "W", modifierFlags: .Command, action: #selector(AspectRatioViewController.close), discoverabilityTitle: "Close Window")]
    }
    
    

    
    
    //MARK: print
    
    
    
    @IBAction func printDidPush(sender: AnyObject) {
        
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = "CnProj Webpage"
        printInfo.orientation = UIPrintInfoOrientation.Portrait
        printInfo.duplex = UIPrintInfoDuplex.LongEdge
        
        
        let printInteractionController = UIPrintInteractionController.sharedPrintController()
        printInteractionController.printInfo = printInfo
        printInteractionController.showsPageRange = true
        printInteractionController.printFormatter = self.webView.viewPrintFormatter()
        
        [printInteractionController .presentAnimated(true, completionHandler: nil)]
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func close(){
        NSNotificationCenter.defaultCenter().postNotificationName("resetCloseBool", object: self, userInfo: nil)
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func closeDidPush(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("resetCloseBool", object: self, userInfo: nil)
        self.dismissViewControllerAnimated(true, completion: nil);
    }



}
