//
//  ColorPickerViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 23/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

protocol ColorProtocol {
    func colorDidChange(color: UIColor)
}

class ColorPickerViewController: UIViewController{

    
    
    @IBOutlet weak var colorPickerView: HRColorPickerView!
    var delegate: SnippetsDelegate?
    var colorDelegate: ColorProtocol?
    
    var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let predefinedColor = color {
            colorPickerView.color = predefinedColor
        }
        else {
            if let color = NSUserDefaults.standardUserDefaults().colorForKey("colorPickerCn"){
                colorPickerView.color = color
            }
            else{
                colorPickerView.color = UIColor.purpleColor()
            }
        }
        
    }

    
    @IBAction func doneDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        delegate?.colorDidChange(colorPickerView.color)
        colorDelegate?.colorDidChange(colorPickerView.color)
    }
    
}

