//
//  CloudSettingsTableViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 29/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class cloudHelper {
    class func cloudAvailable() -> Bool {
        if let _ = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents") {
           return true
        }
        else {
            return false
        }
    }
}

class CloudSettingsTableViewController: UITableViewController {
    
    @IBOutlet var cells: [UITableViewCell]!

    
    @IBOutlet var useCloud: UISwitch!
    @IBOutlet var cloudAvailableLabel: UILabel!
    
    
    
    let kUseCloud = "CnCloud"
    let userDefauls = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        cells.forEach { $0.backgroundColor = tableView.backgroundColor }
        
        
        if let _ = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents") {
            useCloud.on = !userDefauls.boolForKey(kUseCloud)
            cloudAvailableLabel.text = ""
        }
        else {
            cloudAvailableLabel.text = "Please make sure iCloud is enabled in Settings."
            useCloud.enabled = false
        }
        
        
    }

    @IBAction func cloudSwitchChanged(sender: UISwitch) {
        userDefauls.setBool(!useCloud.on, forKey: kUseCloud)
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
    }
    
    
    @IBAction func doneDidPush(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
    
}
