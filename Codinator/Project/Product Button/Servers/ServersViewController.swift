//
//  ServersViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 20/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ServersViewController: UIViewController {

    var projectManager: Polaris!
    
    @IBOutlet var webDavLabel: UILabel!
    @IBOutlet var webServerLabel: UILabel!
    @IBOutlet var webUploaderLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let wifiErrorMessage = "No Wi-Fi"
        let offErrorMessage = "Turned Off"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let webDavIp = projectManager.webDavServerURL() {
            if webDavIp.isEmpty {
                
                if userDefaults.boolForKey("CnWebDavServer") {
                    webDavLabel.text = wifiErrorMessage
                }
                else {
                    webDavLabel.text = offErrorMessage;
                }
                
            }
            else {
                webDavLabel.text = webDavIp
                    .stringByReplacingOccurrencesOfString("http://", withString: "")
                    .stringByReplacingOccurrencesOfString("/", withString: "")
                
            }
        }
        
        if let webServerIp = projectManager.webServerURL() {
            if webServerIp.isEmpty {
                if userDefaults.boolForKey("CnWebServer") {
                    webServerLabel.text = wifiErrorMessage
                }
                else {
                    webServerLabel.text = offErrorMessage;
                }
            }
            else {
                webServerLabel.text = webServerIp
                    .stringByReplacingOccurrencesOfString("http://", withString: "")
                    .stringByReplacingOccurrencesOfString("/", withString: "")
            }
        }
        
        
        
        if let webUploaderIp = projectManager.webUploaderServerURL() {
            if webUploaderIp.isEmpty {
                if userDefaults.boolForKey("CnUploadServer") {
                    webServerLabel.text = wifiErrorMessage
                }
                else {
                    webServerLabel.text = offErrorMessage;
                }            }
            else {
                webUploaderLabel.text = webUploaderIp
                    .stringByReplacingOccurrencesOfString("http://", withString: "")
                    .stringByReplacingOccurrencesOfString("/", withString: "")
            }
        }
        
    
    }
    
    
    
    @IBAction func doneDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
