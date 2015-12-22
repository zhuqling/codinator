//
//  extension.swift
//  VWAS-HTML
//
//  Created by Vladimir on 05/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

import Foundation



extension NSObject {
    
    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
        return timer
    }
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
}


