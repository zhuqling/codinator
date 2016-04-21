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

        let webDavIp = projectManager.webDavServerURL()
            .stringByReplacingOccurrencesOfString("http://", withString: "")
            .stringByReplacingOccurrencesOfString("/", withString: "")
        
        let webServerIp = projectManager.webServerURL()
            .stringByReplacingOccurrencesOfString("http://", withString: "")
            .stringByReplacingOccurrencesOfString("/", withString: "")
        
        let webUploaderIp = projectManager.webUploaderServerURL()
            .stringByReplacingOccurrencesOfString("http://", withString: "")
            .stringByReplacingOccurrencesOfString("/", withString: "")
        

        let errorMessage = "Please connect to a Wi-Fi network."
        
        if webDavIp.isEmpty {
            webDavLabel.text = errorMessage
        }
        else {
            webDavLabel.text = webDavIp
        }

        if webServerIp.isEmpty {
            webServerLabel.text = errorMessage
        }
        else {
            webServerLabel.text = webServerIp
        }

        
        if webUploaderIp.isEmpty {
            webUploaderLabel.text = errorMessage
        }
        else {
            webUploaderLabel.text = webUploaderIp
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
