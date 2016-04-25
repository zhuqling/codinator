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
        
        let tokens = [
            
            CYRToken(name: "special_numbers",
                expression: "[ʝ]",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.orangeColor()
                ]
            ),
            
            CYRToken(name: "mod",
                expression: "\\bmod\\b",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 245, g: 0, b: 110)
                ]
            ),
            
            CYRToken(name: "string",
                expression: "\".*?(\"|$)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 24, g: 110, b: 109)
                ]
            ),
            
            CYRToken(name: "string2",
                expression: "'.*?('|$)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            CYRToken(name: "hex_1",
                expression: "\\$[\\d a-f]+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            CYRToken(name: "octal_1",
                expression: "&[0-7]+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            CYRToken(name: "binary_1",
                expression: "%[01]+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            
            CYRToken(name: "hex_2",
                expression: "0x[0-9 a-f]+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            
            CYRToken(name: "octal_2",
                expression: "0o[0-7]+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            
            CYRToken(name: "binary_2",
                expression: "0b[01]+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            
            CYRToken(name: "float",
                expression: "\\d+\\.?\\d+e[\\+\\-]?\\d+|\\d+\\.\\d+|∞",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            
            CYRToken(name: "integer",
                expression: "\\d+",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            

            CYRToken(name: "operator",
                expression: "[/\\*,\\;:=<>\\+\\-\\^!·≤≥]",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 255)
                ]
            ),
            
            
            CYRToken(name: "round_brackets",
                expression: "[\\(\\)]",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 255)
                ]
            ),
            
            CYRToken(name: "square_brackets",
                expression: "[\\[\\]]",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 255)
                ]
            ),
            
            CYRToken(name: "absolute_brackets",
                expression: "[|]",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 255, g: 255, b: 171)
                ]
            ),
            
            CYRToken(name: "reserved_words",
                expression: "(abs|acos|acosh|function|asin|asinh|atan|atanh|atomicweight|ceil|complex|cos|cosh|crandom|deriv|erf|erfc|exp|eye|floor|frac|gamma|gaussel|getconst|imag|inf|integ|integhq|inv|ln|log10|log2|machineprecision|max|maximize|min|minimize|molecularweight|ncum|ones|pi|plot|random|real|round|sgn|sin|sqr|sinh|sqrt|tan|tanh|transpose|trunc|true|false|func|var|zeros|@import|void|return)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),

            
            CYRToken(name: "chart_parameters",
                expression: "(chartheight|charttitle|chartwidth|color|seriesname|showlegend|showxmajorgrid|showxminorgrid|showymajorgrid|showyminorgrid|transparency|thickness|xautoscale|xaxisrange|xlabel|xlogscale|xrange|yautoscale|yaxisrange|ylabel|ylogscale|yrange)",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 186, g: 114, b: 181)
                ]
            ),
            
            
            CYRToken(name: "comment",
                expression: "//.*",
                attributes:
                [
                    NSForegroundColorAttributeName : UIColor.rgb(r: 31, g: 131, b: 0),
                    NSFontAttributeName : self.italicFont
                ]
            )
            
            ]
        
        return tokens
    }

}
