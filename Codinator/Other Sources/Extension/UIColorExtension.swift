//
//  UIColorExtension.swift
//  Codinator
//
//  Created by Vladimir Danila on 01/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

extension UIColor {
    class func rgb(r r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}