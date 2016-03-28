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
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func commonSetUp() {
        self.font = defaultFont
        self.textColor = UIColor.whiteColor()
        
        
        //TODO: Missing KVO
        
        self.tokens = highlightingTokens()
    }
    
    func highlightingTokens() -> [CYRToken!] {
        
        let tokens = [
            CYRToken(name: "square_brackets",
                expression: "(HTML|START|END|KEYWORDS|ROBOTS|DESCRIPTION|AUTHOR|TITLE|VIEWPORT|VIEWPORT|HEAD|BODY|H1|LINK|META|H2|H3|H4|H5|H6|P|BR|TABLE|TR|TD|CODE|UL|IMPORT|B|I|LI)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.orangeColor(),
                    NSFontAttributeName : self.defaultFont
                ]
            ),
        
            
            CYRToken(name: "Tag",
                expression: "<.*?(>)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.redColor(),
                    NSFontAttributeName : self.defaultFont
                ]
            ),
            
            
            CYRToken(name: "reserved_words",
                expression: "(algin|width|height|color|text|border|bgcolor|description|name|content|href|src|initialScale|charset|class|role|id|<!DOCTYPE html>|border)",
                attributes: HighlighterExtention.attributesForKey(.ReservedWords)
            ),
            
            
            CYRToken(name: "string",
                expression: HighlighterExtention.macroForKey(.String),
                attributes: HighlighterExtention.attributesForKey(.String)
            )
        ]
        
        return tokens
    }

}
