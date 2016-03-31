//
//  GetReadyViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 20/09/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

import UIKit

class GetReadyViewController: UIViewController {
    
    @IBOutlet weak var welcomeToCodinatorLabel: LTMorphingLabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
        
        self.callSelector(#selector(GetReadyViewController.finishLoading), object: self, delay: 3.0)
    }

    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(),{
            self.welcomeToCodinatorLabel.text = "Welcome to Codinator"
            self.welcomeToCodinatorLabel.morphingEffect = .Evaporate
        })
    }
    
    
    func finishLoading() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.activityIndicator.alpha = 0
            
            
        }) { (Bool) -> Void in
            self.activityIndicator.hidden = true
            
            self.welcomeToCodinatorLabel.text = "Magnificent. Simple. Powerful."
            
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.nextButton.alpha = 1.0
            })
            
        }
    }
    
    
    
    @IBAction func doneDidPush(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CNFirstRunEver")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
