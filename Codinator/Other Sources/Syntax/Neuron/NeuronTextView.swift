//
//  NeuronTextView.swift
//  Codinator
//
//  Created by Vladimir Danila on 28/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class NeuronTextView: CYRTextView {

    var defaultFont: UIFont = NSUserDefaults.standardUserDefaults().fontForKey("Font: 0") {
        didSet {
            tokens = highlightingTokens()
        }
    }
    
    var boldFont: UIFont = NSUserDefaults.standardUserDefaults().fontForKey("Font: 1") {
        didSet {
            tokens = highlightingTokens()
        }
    }
    
    var italicFont: UIFont = NSUserDefaults.standardUserDefaults().fontForKey("Font: 2") {
        didSet {
            tokens = highlightingTokens()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetUp()
    }
    
    
    func commonSetUp() {
        self.font = defaultFont
        self.textColor = UIColor.whiteColor()
        self.indicatorStyle = .White
        
        self.tokens = highlightingTokens()
    }
    
    func highlightingTokens() -> [CYRToken!] {
        
        let tokens = [
            

            
            CYRToken(name: "reserved_words",
                expression: "\\b(algin|width|height|color|text|border|bgcolor|description|name|content|href|src|initialScale|charset|class|role|id|<!DOCTYPE html>|border)\\b",
                attributes:
                [
                    NSForegroundColorAttributeName : NSUserDefaults.standardUserDefaults().colorForKey("Color: 5"),
                    NSFontAttributeName : self.defaultFont
                ]
            ),
            
            CYRToken(name: "Tags_neuron_Short",
                expression: "\\b(P|B|I|)\\b",
                attributes:
                [
                    NSForegroundColorAttributeName : NSUserDefaults.standardUserDefaults().colorForKey("Color: 3"),
                    NSFontAttributeName : self.defaultFont
                ]
            ),
            
            
            CYRToken(name: "Tags_neuron_Long",
                expression: "\\b[A-Z][A-Z0-9]+\\b",
                attributes:
                [
                    NSForegroundColorAttributeName : NSUserDefaults.standardUserDefaults().colorForKey("Color: 3"),
                    NSFontAttributeName : self.defaultFont
                ]
            ),
            
            CYRToken(name: "Tag",
                expression: HighlighterExtention.macroForKey(.Tag),
                attributes: HighlighterExtention.attributesForKey(.Tag)
            ),
            
            
            CYRToken(name: "string",
                expression: HighlighterExtention.macroForKey(.String),
                attributes: HighlighterExtention.attributesForKey(.String)
            )
        ]
        
        return tokens
    }

}
