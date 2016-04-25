//
//  NewFileDelegate.swift
//  Codinator
//
//  Created by Vladimir Danila on 21/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

protocol NewFilesDelegate {
    func reloadData()
}

class NewFiles: NSObject {
    class func availableName(name: String, nameWithoutExtension: String, Extension: String, items: [String]) -> String {
        let files = items.filter { $0 == name }
        
        // If there no file names that are the same continue else count up
        if files.isEmpty {
            return name
        }
        else {
            
            // Check if there's already a number at the end else return name2.extension
            guard let number = Int(String((nameWithoutExtension.characters.last! as Character))) else {
                return nameWithoutExtension + "2." + Extension
            }
            
            // Increase number and append extension
            return nameWithoutExtension + String(number + 1) + Extension
        }
        
    }
}