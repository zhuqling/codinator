//
//  SettingsGeneralViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 13/06/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

import UIKit
import Crashlytics

class SettingsGeneralViewController: UIViewController {

    
    
    @IBOutlet weak var showLineNumberSwitch: UISwitch!
    
    @IBOutlet var useWebDavServerSwitch: UISwitch!
    @IBOutlet weak var useWebServerSwitch: UISwitch!
    @IBOutlet weak var useUploadServerSwitch: UISwitch!
    
    let userDefauls = NSUserDefaults.standardUserDefaults()
    
    let kLineNumber = "CnLineNumber"
    let kWebServer = "CnWebServer"
    let kWebDavServer = "CnWebDavServer"
    let kUploadServer = "CnUploadServer"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.showLineNumberSwitch.on = userDefauls.boolForKey(kLineNumber)
    
        self.useWebServerSwitch.on = userDefauls.boolForKey(kWebServer);
        self.useWebDavServerSwitch.on = userDefauls.boolForKey(kWebDavServer);
        self.useUploadServerSwitch.on = userDefauls.boolForKey(kUploadServer);
        
        
        
    }

    
    
    
    //MARK: Switches Changed
    
    
    @IBAction func showLineNumberSwichChanged(sender: AnyObject) {
        
        Answers.logCustomEventWithName("showLineNumber",
            customAttributes: ["Enabled": showLineNumberSwitch.on])
        
        userDefauls.setBool(self.showLineNumberSwitch.on, forKey: kLineNumber)
        userDefauls.synchronize()
    }
    
    
    
    @IBAction func webDavSwichChanged(sender: AnyObject) {
        
        Answers.logCustomEventWithName("webDavSwitchChanged",
            customAttributes: ["Enabled": useWebDavServerSwitch.on])
        
        userDefauls.setBool(self.useWebDavServerSwitch.on, forKey: kWebDavServer)
        userDefauls.synchronize()
    }
    
    
    @IBAction func webServerSwichChanged(sender: AnyObject) {
        
        Answers.logCustomEventWithName("webServerSwitchChanged",
            customAttributes: ["Enabled": useWebServerSwitch.on])
        
        userDefauls.setBool(self.useWebServerSwitch.on, forKey: kWebDavServer)
        userDefauls.synchronize()
    }
    
    
    @IBAction func uploadServerSwichChanged(sender: AnyObject) {
        
        Answers.logCustomEventWithName("uploadServerSwichChanged",
            customAttributes: ["Enabled": useUploadServerSwitch.on])
        
        userDefauls.setBool(self.useUploadServerSwitch.on, forKey: kWebDavServer)
        userDefauls.synchronize()
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
