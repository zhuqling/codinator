//
//  EditorViewControllerTextViewsExtension.swift
//  Codinator
//
//  Created by Vladimir Danila on 06/05/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension EditorViewController {
    
    func setUpTextView(textView: CYRTextView) {
        // Setting up TextView
        textView.frame = self.view.frame
        textView.text = text
        textView.delegate = self
        textView.tintColor = UIColor.whiteColor()
        textView.alwaysBounceVertical = true
        
        view.addSubview(textView)
        textView.bindFrameToSuperviewBounds()
        
        
        // Keyboard
        textView.inputAssistantItem.trailingBarButtonGroups = []
        textView.inputAssistantItem.leadingBarButtonGroups = []
        
//        textView.layer.drawsAsynchronously = true
    }
    
    func setUpKeyboardForTextView(textView: CYRTextView) {
        // Keyboard Accessory
        if self.view.traitCollection.horizontalSizeClass == .Compact || self.view.traitCollection.verticalSizeClass == .Compact || UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            
            textView.inputAccessoryView = VWASAccessoryView(textView: textView)
            
        }
        else{
            
            textView.inputAccessoryView = nil;
            KOKeyboardRow.applyToTextView(textView)
            
        }
    }
    
}