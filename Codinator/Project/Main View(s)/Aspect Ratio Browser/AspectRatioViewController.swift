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
    
    var webView: WKWebView!
    var previewPath: String!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Configure WebView
        let configuration = WKWebViewConfiguration()
     
        configuration.applicationNameForUserAgent = "Codinator"
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.requiresUserActionForMediaPlayback = false
        configuration.allowsPictureInPictureMediaPlayback = true
        
        
        
        // Display up WebView
        webView = WKWebView(frame: self.view.frame, configuration:configuration)
        webView.allowsLinkPreview = true
        
        self.view.addSubview(webView)
    
        // Autoresizing for webview
        webView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleHeight, .FlexibleWidth]
    
        
        webView.bindFrameToSuperviewBounds()
    
        
    
        
        let url = NSURL(fileURLWithPath: previewPath)
        // Load url
        webView.loadFileURL(url, allowingReadAccessToURL: NSURL(fileURLWithPath:previewPath, isDirectory: true))

        
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
    
    
    // MARK: - Relaod
    
    @IBAction func refreshDidPush() {
        webView.reload()
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
