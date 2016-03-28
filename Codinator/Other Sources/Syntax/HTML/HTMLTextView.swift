//
//  HTMLTextView.swift
//  Codinator
//
//  Created by Vladimir Danila on 28/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit


enum HighlightingDictionaryKey: String {
    case Tag = "Macro:3 Attribute"
    case SquareBrackets = "Macro:4 Attribute"
    case ReservedWords = "Macro:5 Attribute"
    case String = "Macro:6 Attribute"
}

enum HighlightingMacroKey: String {
    case Tag = "Macro:3"
    case SquareBrackets = "Macro:4"
    case ReservedWords = "Macro:5"
    case String = "Macro:6"
}


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
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func commonSetUp() {
        self.font = defaultFont
        self.textColor = UIColor.whiteColor()
    
        
        //TODO: Missing KVO
        
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
            )
        ]
        
        return tokens as! [CYRToken]
    }
    
    
}
