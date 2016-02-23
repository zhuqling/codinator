//
//  ContributeViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 2/22/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit
import SafariServices
import Crashlytics

class ContributeViewController: UIViewController {
    
    @IBOutlet weak var gitHubButton: UIButton!
    @IBOutlet weak var slackButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slackButton.layer.borderWidth = 2.0
        slackButton.layer.cornerRadius = 5.0
        slackButton.layer.borderColor = slackButton.tintColor.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func contributeOnGitHubDidPush(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(
            NSURL(string: "https://github.com/VWAS/Codinator")!
        )
    }
    
    
    @IBAction func joinUsOnSlackDidPush(sender: AnyObject) {
        Answers.logCustomEventWithName("joinUsOnSlack", customAttributes: [:])
        
        let sfController = SFSafariViewController(URL:
            NSURL(string: "https://vwas-slack.herokuapp.com")!
        )
        
        sfController.modalPresentationStyle = .PageSheet
        presentViewController(sfController, animated: true, completion: nil)
    }
    
}
