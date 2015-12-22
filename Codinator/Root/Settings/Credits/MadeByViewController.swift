//
//  MadeByViewController.swift
//  Codinator
//
//  Created by Vladimir on 03/06/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import UIKit

class MadeByViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pupilsDidPressed(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: "Vladimir Danila - 16 y.o 🇩🇪\n Sam Miller - 15 y.o 🇨🇦\n Enoch Appathurai - 14 y.o 🇦🇺", preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor.purpleColor()
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
}
