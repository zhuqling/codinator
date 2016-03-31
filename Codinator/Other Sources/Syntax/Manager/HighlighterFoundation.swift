//
//  HighlighterFoundation.swift
//  Codinator
//
//  Created by Vladimir Danila on 3/30/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class HighlighterFoundation: UITextView {

    
    var tokens: [CYRToken]? {
        get {
            
            guard let textStorage: CYRTextStorage = self.textStorage as? CYRTextStorage else {
                return []
            }
            
            guard let tokens = textStorage.tokens as? [CYRToken] else {
                return []
            }
            
            return tokens
        }
        
        set {
            if let storage = self.syntaxTextStorage {
                storage.tokens = newValue
            }
        }
        
    }
    
    var singleFingerPanRecognizer: UIPanGestureRecognizer?
    var doubleFingerPanRecognizer: UIPanGestureRecognizer?
    
    let cursorVelocity: CGFloat = 1/8
    
    let lineColor: UIColor = UIColor.blackColor()
    let bgColor: UIColor = UIColor(white: 0, alpha: 1)
    
    var lineCursorEnabled = true
    
    var startRange: NSRange?
    
    var displayLineNumber = NSUserDefaults.standardUserDefaults().boolForKey("CnLineNumber")
    var lineNumberLayoutManager: CYRLayoutManager?
    
    
    // WARNING: - This is incomplete
    var syntaxLayoutManager: CYRLayoutManager?
    var syntaxTextStorage: CYRTextStorage?
    

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

     convenience init(frame: CGRect) {
        let textStorage = CYRTextStorage()
        let layoutManager = CYRLayoutManager()
        
        
        let textContainer = NSTextContainer(size: CGSizeMake(CGFloat.max, CGFloat.max))
        
        //  Wrap text to the text view's frame
        textContainer.widthTracksTextView = true
        
        layoutManager.addTextContainer(textContainer)
        textStorage.removeLayoutManager(textStorage.layoutManagers.first!)
        textStorage.addLayoutManager(layoutManager)
        
        self.init(frame: frame, textContainer: textContainer)

        
        self.syntaxTextStorage = textStorage
        lineNumberLayoutManager = layoutManager

        
        self.contentMode = .Redraw
        self.setUp()
        
    }
    

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        scrollEnabled = false
        editable = false
    }
    
    
    
    
    func setUp() {
        
        //WARNING: - Observers arre missing 
        
        // Setup defaults 
        self.font = UIFont.systemFontOfSize(16.0)
        self.textColor = UIColor.whiteColor()
        
        self.autocapitalizationType = .None
        self.autocorrectionType = .No
        self.lineCursorEnabled = true
        
        if displayLineNumber {
            self.textContainerInset = UIEdgeInsetsMake(8, self.lineNumberLayoutManager!.gutterWidth, 8, 0)
        }
        else {
            self.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0)
        }
        
        
        // Gesture recognizer
        singleFingerPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(singleFingerPanHappened))
        singleFingerPanRecognizer?.maximumNumberOfTouches = 1
        self.addGestureRecognizer(singleFingerPanRecognizer!)
        
        
        doubleFingerPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(doubleFingerPanHappened))
        doubleFingerPanRecognizer?.maximumNumberOfTouches = 2
        self.addGestureRecognizer(doubleFingerPanRecognizer!)
        
        
    }

    
    // MARK: - Notifications

    

    
    // MARK: - Line drawing

    override func drawRect(rect: CGRect) {

        if self.displayLineNumber {
            
            //  Drag the line number gutter background.  The line numbers them selves are drawn by LineNumberLayoutManager.
            let context = UIGraphicsGetCurrentContext()
            
            let bounds = self.bounds
            let height = max(CGRectGetHeight(bounds), self.contentSize.height) + 200
            
            // Set the regular fill
            CGContextSetFillColorWithColor(context, bgColor.CGColor)
            CGContextFillRect(context, CGRectMake(bounds.origin.x, bounds.origin.y, self.lineNumberLayoutManager!.gutterWidth, height))
            
            // Draw line
            CGContextSetFillColorWithColor(context, self.lineColor.CGColor)
            CGContextFillRect(context, CGRectMake(self.lineNumberLayoutManager!.gutterWidth, bounds.origin.y, 0.5, height))
            
            if lineCursorEnabled {
                self.lineNumberLayoutManager!.selectedRange = self.selectedRange
                
                let string: NSString = (self.lineNumberLayoutManager?.textStorage?.string)!
                let tmpGlyphRange = string.paragraphRangeForRange(self.selectedRange)
                
                let glyphRange = self.lineNumberLayoutManager?.glyphRangeForCharacterRange(tmpGlyphRange, actualCharacterRange: nil)
                
                self.lineNumberLayoutManager?.selectedRange = glyphRange!
                self.lineNumberLayoutManager?.invalidateDisplayForGlyphRange(glyphRange!)
                
            }
            
            
        }
    
        super.drawRect(rect)
    }
    
    
    
    
    // MARK: - Gestures
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
     
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer  {
            
            // Only accept horizontal pans for the code navigation to preserve correct scrolling behaviour.
            if panGestureRecognizer == singleFingerPanRecognizer || panGestureRecognizer == doubleFingerPanRecognizer {
                let translation = panGestureRecognizer.translationInView(self)
                return fabs(translation.x) > fabs(translation.y)
            }
            
        }
        
        return true
    }
    
    
    func singleFingerPanHappened(sender: UIPanGestureRecognizer) {
        if sender.state == .Began  {
            startRange = self.selectedRange
        }
        
        let cursorLocation = max(CGFloat(startRange!.location) + sender.translationInView(self).x * cursorVelocity, 0)
        
        self.selectedRange = NSMakeRange(Int(cursorLocation), 0)
    }
    
    func doubleFingerPanHappened(sender: UIPanGestureRecognizer) {
        if sender.state == .Began  {
            startRange = self.selectedRange
        }
        
        let cursorLocation = Int(max(CGFloat(startRange!.location) + sender.translationInView(self).x * cursorVelocity, 0))
        
        
        if cursorLocation > startRange?.location {
            self.selectedRange = NSMakeRange(startRange!.location, Int(fabs(Double(startRange!.location - cursorLocation))))
        }
        else {
            self.selectedRange = NSMakeRange(cursorLocation, Int(fabs(Double(startRange!.location - cursorLocation))))
        }
        
    }
        
    
    

}
