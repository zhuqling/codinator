//
//  HTMLTextView.swift
//  Codinator
//
//  Created by Vladimir Danila on 28/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit


class HTMLTextView: CYRTextView {

    
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
        self.keyboardAppearance = .Dark
        
        self.indicatorStyle = .White
        self.tokens = highlightingTokens()
    }
    
    func highlightingTokens() -> [CYRToken] {
        
        let tokens = [
            
            CYRToken(name: "Tag",
                expression: HighlighterExtention.macroForKey(.Tag),
                attributes: HighlighterExtention.attributesForKey(.Tag)
            ),
            
            
            CYRToken(name: "square_brackets",
                expression: HighlighterExtention.macroForKey(.SquareBrackets),
                attributes: HighlighterExtention.attributesForKey(.SquareBrackets)
            ),
            
            
            CYRToken(name: "reserved_words",
                expression: HighlighterExtention.macroForKey(.ReservedWords),
                attributes: HighlighterExtention.attributesForKey(.ReservedWords)
            ),
            
            
            CYRToken(name: "string",
                expression: HighlighterExtention.macroForKey(.String),
                attributes: HighlighterExtention.attributesForKey(.String)
            ),
            
            CYRToken(name: "comment",
                expression: "<!--.*?(--!>|$)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor(hexString: "46A544")
                ]
            )
            
        ]
        
        return tokens as! [CYRToken]
    }
    

}
