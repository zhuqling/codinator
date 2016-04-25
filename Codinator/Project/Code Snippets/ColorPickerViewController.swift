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
    
    
    override func viewDidDisappear(animated: Bool) {
        delegate?.colorDidChange(colorPickerView.color)
    }
    
    
    
//    override func viewDidLoad() {
//        if let color = NSUserDefaults.standardUserDefaults().colorForKey("colorPickerCn"){
//            colorPickerView.color = color
//        }
//        else{
//            colorPickerView.color = UIColor.purpleColor()
//        }
//        
//        self.view.addSubview(colorPickerView)
//        colorPickerView.addTarget(self, action: #selector(ColorPickerViewController.colorPickerDidChanged), forControlEvents: UIControlEvents.ValueChanged)
//    }
//    
//    
//    func colorPickerDidChanged(){
//        
//        NSUserDefaults.standardUserDefaults().setColor(colorPickerView.color, forKey: "colorPickerCn")
//        
//        if (!displayed){
//            
//            displayed = true
//            
//            let label = UILabel(frame: CGRectMake(0, 550, 400, 50))
//            label.text = "The hex code has been copied to your clipboard."
//            self.view.addSubview(label)
//        }
//        
//        
//    }
    
    
}

