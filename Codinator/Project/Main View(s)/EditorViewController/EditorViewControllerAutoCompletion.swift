//
//  EditorViewControllerAutoCompletion.swift
//  Codinator
//
//  Created by Vladimir Danila on 24/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension EditorViewController: WUTextSuggestionDisplayControllerDataSource {
    
    
    func textSuggestionDisplayController(textSuggestionDisplayController: WUTextSuggestionDisplayController!, suggestionDisplayItemsForSuggestionType suggestionType: WUTextSuggestionType, query suggestionQuery: String!) -> [AnyObject]! {
        if suggestionType == WUTextSuggestionType.At {
            var suggestionDisplayItems : [WUTextSuggestionDisplayItem] = []
            for name in self.filteredNamesUsingQuery(suggestionQuery) {
                let item = WUTextSuggestionDisplayItem(title: name)
                suggestionDisplayItems.append(item)
            }
            return suggestionDisplayItems
        }
        
        return nil;
    }
    
    func filteredNamesUsingQuery(query : String) -> [String] {
        if let filteredNames = self.names().filteredArrayUsingPredicate(NSPredicate(block: { (evaluatedObject : AnyObject, bindings: [String : AnyObject]?) -> Bool in
            if let evaluatedObject = evaluatedObject as? String {
                if evaluatedObject.lowercaseString.hasPrefix(query.lowercaseString) {
                    return true
                }
            }
            
            return false
        })) as? [String] {
            return filteredNames
        }
        
        return []
    }
    
    func names() -> NSArray {
        return ["h1>","/h1>","h2>","/h2>","h3>","/h3>","h4>","h5>","h6>","head>","body>","/body>","!Doctype html>","center>","img src=","a href=","font ","meta","table border=","tr>","td>","div>","div class=","style>","title>","li>","em>","p>","section class=","header>","footer>","ul>","del>","em>","sub>","sup>","var>","cite>","dfn>","big>","small>","strong>","code>","frameset","blackquote>","br>"]
    }
    
    func range() {
        
        guard let rangeString = NSUserDefaults.standardUserDefaults().stringForKey("range") else {
            return
        }
        
        
        
        // Get string nearby the typing area
        let stringFromRange = (htmlTextView.text as NSString).substringWithRange( NSRange(location: htmlTextView.selectedRange.location - 10, length: 10))
        
        // Find where the tag starts
        let findTag = stringFromRange.characters.enumerate().filter { $0.element == "<"}.last?.index
        
        // Try to find the distance between the cursor and the beginning of the tag. Since we don't want to delete the tag we do +1
        let itemsToDeleteTillTag = stringFromRange.characters.count - findTag! - 1
        
        // Delete the charachters that are after the tag
        for _ in 1...itemsToDeleteTillTag {
            htmlTextView.deleteBackward()
        }
        
        
        
        // Complete the tag
        
        
        
        var checkString : String {
            if rangeString.characters.last == " " {
                return rangeString.substringToIndex(rangeString.endIndex.predecessor())
            }
            else {
                return rangeString
            }
        }
        
        
        // Check if tag needs closing tag or not and insert the tag
        switch checkString {
        case "h1>", "h2>", "h3>",  "h4>", "h5>", "h6>", "head>", "body>", "!Documentype html>", "center>", "tr>", "title>", "li>", "section>", "header>", "footer>", "ul>", "del>", "em>", "sub>", "sup>", "var>", "small>", "strong>", "code>", "blackquote>", "p>","h1> ", "h2> ", "h3> ",  "h4>", "h5> ", "h6> ", "head> ", "body> ", "!Documentype html> ", "center> ", "tr> ", "title> ", "li> ", "section> ", "header> ", "footer> ", "ul> ", "del> ", "em> ", "sub> ", "sup> ", "var> ", "small> ", "strong> ", "code> ", "blackquote> ", "p> ":
            
            let br = "</\(checkString)"
            
            htmlTextView.insertText(checkString + br)
            
            // Move cursor back +1 since count starts with 0
            self.moveCursorBy(br.characters.count, diretion: .Back)
            
            
        default:
            let br = checkString
            htmlTextView.insertText(br)
            
        }
        
        
        
    }
    
    enum MoveCursorDirection {
        case Back
        case Forward
    }
    
    func moveCursorBy(number: Int, diretion: MoveCursorDirection) {
        let range = htmlTextView.selectedRange
        
        switch diretion {
        case .Back:
            htmlTextView.selectedRange = NSMakeRange(range.location - number, 0)
            
        case .Forward:
            htmlTextView.selectedRange = NSMakeRange(range.location + number, 0)
        }
    }
    
    
}