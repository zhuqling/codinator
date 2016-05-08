//
//  NeuronTextView.swift
//  Codinator
//
//  Created by Vladimir Danila on 28/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class JsTextView: CYRTextView {

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
        
        let regexAttributes = [
            NSForegroundColorAttributeName : SyntaxHighlighterDefaultColors.darkGoldColor
        ]
        
        let commentAttributes = [
                NSForegroundColorAttributeName : SyntaxHighlighterDefaultColors.commentGreen,
        ]
    
        
        
        let tokens = [
            
//            CYRToken(name: "special_numbers",
//                expression: "[ʝ]",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.orangeColor()
//                ]
//            ),
//            
//            CYRToken(name: "mod",
//                expression: "\\bmod\\b",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 245, g: 0, b: 110)
//                ]
//            ),
//
//            
//            CYRToken(name: "hex_1",
//                expression: "\\$[\\d a-f]+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            CYRToken(name: "octal_1",
//                expression: "&[0-7]+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            CYRToken(name: "binary_1",
//                expression: "%[01]+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            
//            CYRToken(name: "hex_2",
//                expression: "0x[0-9 a-f]+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            
//            CYRToken(name: "octal_2",
//                expression: "0o[0-7]+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            
//            CYRToken(name: "binary_2",
//                expression: "0b[01]+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            
//            CYRToken(name: "float",
//                expression: "\\d+\\.?\\d+e[\\+\\-]?\\d+|\\d+\\.\\d+|∞",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//            
//            CYRToken(name: "integer",
//                expression: "\\d+",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
//            
//
//            CYRToken(name: "operator",
//                expression: "[/\\*,\\;:=<>\\+\\-\\^!·≤≥]",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 255)
//                ]
//            ),
//            
//            
//            CYRToken(name: "round_brackets",
//                expression: "[\\(\\)]",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 255)
//                ]
//            ),
//            
//            CYRToken(name: "square_brackets",
//                expression: "[\\[\\]]",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 255)
//                ]
//            ),
//            
//            CYRToken(name: "absolute_brackets",
//                expression: "[|]",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 171)
//                ]
//            ),
            
            CYRToken(name: "reserved_words",
                expression: "\\b(as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield)\\b",
                attributes: HighlighterExtention.attributesForKey(.Tag)
            ),

            
//            CYRToken(name: "chart_parameters",
//                expression: "(chartheight|charttitle|chartwidth|color|seriesname|showlegend|showxmajorgrid|showxminorgrid|showymajorgrid|showyminorgrid|transparency|thickness|xautoscale|xaxisrange|xlabel|xlogscale|xrange|yautoscale|yaxisrange|ylabel|ylogscale|yrange)",
//                attributes:
//                [
//                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
//                ]
//            ),
            
            CYRToken(name: "string",
                expression: "\".*?(\"|$)|'.*?('|$)",
                attributes: HighlighterExtention.attributesForKey(.String)
            ),
            
            
            
            CYRToken(name: "regular_expression",
                expression: "/.*?(/|$)",
                attributes: regexAttributes
            ),
            
            CYRToken(name: "regular_expression_with_I",
                expression: "/.*?(/i|$)",
                attributes: regexAttributes
            ),
            
            CYRToken(name: "regular_expression_with_G",
                expression: "/.*?(/g|$)",
                attributes: regexAttributes
            ),
            
            
            
            CYRToken(name: "documentation_comment",
                expression: "\\/\\*[\\w\\W]*?\\*\\/",
                attributes: commentAttributes
            ),
            
            
            
            CYRToken(name: "comment",
                expression: "(^|[^\\\\:])\\/\\/.*",
                attributes: commentAttributes
            )
            
        ]
        
        return tokens
    }
}
