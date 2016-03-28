//
//  HighlighterExtention.swift
//  Codinator
//
//  Created by Vladimir Danila on 28/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

class HighlighterExtention {
    
    class func attributesForKey(key: HighlightingDictionaryKey) -> [NSObject:AnyObject] {
        guard let attriutes = NSUserDefaults.standardUserDefaults().dicForKey(key.rawValue) else {
            return [:]
        }
        
        return attriutes
    }
    
    class func macroForKey(key: HighlightingMacroKey) -> String {
        guard let macro = NSUserDefaults.standardUserDefaults().stringForKey(key.rawValue) else {
            return ""
        }
        
        return macro
    }
}