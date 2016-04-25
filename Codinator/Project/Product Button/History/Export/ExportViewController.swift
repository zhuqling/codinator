//
//  ExportViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 24/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController, SSZipArchiveDelegate, UIDocumentInteractionControllerDelegate {

    var path: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var preparingFilesLabel: UILabel!
    
    @IBOutlet weak var chooseHowToSendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        createZipArchive()
    }
    
    
    // MARK: - Zipping
    
    
    func createZipArchive() {
    
        let zipTmpPath = NSHomeDirectory() + "/Documents/Temp.zip"
        SSZipArchive.createZipFileAtPath(zipTmpPath, withContentsOfDirectory: path, delegate: self)
        
        
    }
    
    
    var documentInteractionController: UIDocumentInteractionController?
    func zipArchiveDidZippedArchiveToPath(path: String!) {

        UIView.animateWithDuration(0.4, animations: {
            self.preparingFilesLabel.hidden = true
            self.activityIndicator.hidden = true
            }) { bool in
            self.chooseHowToSendButton.hidden = false
        }
        
        let url = NSURL(fileURLWithPath: path, isDirectory: false)
     
        // Create the interaction controller
        documentInteractionController = UIDocumentInteractionController(URL: url)

        documentInteractionController?.delegate = self
        
        documentInteractionController?.presentOpenInMenuFromRect(chooseHowToSendButton.frame, inView: self.view, animated: true)
        
    }
    
    @IBAction func shareDidPush(sender: UIButton) {
        
        let zipTmpPath = NSHomeDirectory() + "/Documents/Temp.zip"
        let url = NSURL(fileURLWithPath: zipTmpPath, isDirectory: false)
        
        // Create the interaction controller
        documentInteractionController = UIDocumentInteractionController(URL: url)
        
        documentInteractionController?.delegate = self
        
        documentInteractionController?.presentOpenInMenuFromRect(sender.frame, inView: self.view, animated: true)
    
    }
    
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    

    func documentInteractionController(controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    @IBAction func cancelDidPush(sender: AnyObject) {
    
        dispatch_async(dispatch_get_main_queue(),{
            self.dismissViewControllerAnimated(true, completion: nil)
        })

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    

}
