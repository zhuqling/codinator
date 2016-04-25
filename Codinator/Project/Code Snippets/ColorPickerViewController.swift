//
//  ColorPickerViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 23/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController{

    
    
    @IBOutlet weak var colorPickerView: HRColorPickerView!
    var delegate: SnippetsDelegate?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = NSUserDefaults.standardUserDefaults().colorForKey("colorPickerCn"){
            colorPickerView.color = color
        }
        else{
            colorPickerView.color = UIColor.purpleColor()
        }
        
    }
    
    @IBAction func doneDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        delegate?.colorDidChange(colorPickerView.color)
    }
    

    
    
}

