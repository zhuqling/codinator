//
//  ArchiveViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 20/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController {

    var projectManager: Polaris!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5
    
    }

    
    @IBAction func cancelDidPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func archiveDidPush(sender: UIBarButtonItem) {
        textView.resignFirstResponder()
        
        if textView.text.isEmpty {
            Notifications.sharedInstance.alertWithMessage("Commit message can't be emtpy!", title: "", viewController: self)
        }
        else {
            projectManager.archiveWorkingCopyWithCommitMessge(textView.text)
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
