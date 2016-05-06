//
//  EngineViewControllerColorPicker.swift
//  Codinator
//
//  Created by Vladimir Danila on 26/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension EngineViewController: ColorProtocol {
 
    func colorDidChange(color: UIColor) {
        changeColorButton.tintColor = color
        NSUserDefaults.standardUserDefaults().setColor(color, forKey: "Color: \(selectedType)");
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "colorPicker" {
            let destViewController = segue.destinationViewController as! ColorPickerViewController
            destViewController.colorDelegate = self
            destViewController.color = changeColorButton.tintColor
            destViewController.navigationItem.title = "Color Picker"
        }
    }
    
}