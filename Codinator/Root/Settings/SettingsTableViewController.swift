//
//  SettingsTableViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var cells: [UITableViewCell]!
    
    
    let kLineNumber = "CnLineNumber"
    let kWebServer = "CnWebServer"
    let kWebDavServer = "CnWebDavServer"
    let kUploadServer = "CnUploadServer"
    
    @IBOutlet weak var showLineNumberSwitch: UISwitch!
    
    @IBOutlet var useWebDavServerSwitch: UISwitch!
    @IBOutlet weak var useWebServerSwitch: UISwitch!
    @IBOutlet weak var useUploadServerSwitch: UISwitch!
    
    let userDefauls = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        cells.forEach { $0.backgroundColor = tableView.backgroundColor }
        
        self.showLineNumberSwitch.on = userDefauls.boolForKey(kLineNumber)
        
        self.useWebServerSwitch.on = userDefauls.boolForKey(kWebServer);
        self.useWebDavServerSwitch.on = userDefauls.boolForKey(kWebDavServer);
        self.useUploadServerSwitch.on = userDefauls.boolForKey(kUploadServer);
        
    }

    //MARK: Switches Changed
    
    
    @IBAction func showLineNumberSwichChanged(sender: AnyObject) {
        userDefauls.setBool(self.showLineNumberSwitch.on, forKey: kLineNumber)
        userDefauls.synchronize()
    }
    
    
    
    @IBAction func webDavSwichChanged(sender: AnyObject) {
        userDefauls.setBool(self.useWebDavServerSwitch.on, forKey: kWebDavServer)
        userDefauls.synchronize()
    }
    
    
    @IBAction func webServerSwichChanged(sender: AnyObject) {
        userDefauls.setBool(self.useWebServerSwitch.on, forKey: kWebDavServer)
        userDefauls.synchronize()
    }
    
    
    @IBAction func uploadServerSwichChanged(sender: AnyObject) {
        userDefauls.setBool(self.useUploadServerSwitch.on, forKey: kWebDavServer)
        userDefauls.synchronize()
    }
    
    @IBAction func doneDidPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
}
