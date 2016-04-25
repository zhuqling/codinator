//
//  QuickStartQuide.swift
//  VWAS-HTML
//
//  Created by Vladimir on 02/04/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import UIKit

class QuickStartQuide: UIViewController {

    
    
    @IBOutlet weak var okButton: UIButton?
    
    
    @IBAction func closeDidPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 13
        self.view.layer.borderColor = UIColor(red: 55/255, green: 27/255, blue: 98/255, alpha: 1.0).CGColor
        self.view.layer.borderWidth = 3
        
    }
    

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone){
            return UIInterfaceOrientationMask.Portrait
        }
        else{
            return UIInterfaceOrientationMask.All
        }
    
    }
    
    
}





class QuickStartQuidePlaygrounds: UIViewController {
    
    @IBInspectable var viewTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = viewTitle
    }
    
    @IBAction func closeDidPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}












