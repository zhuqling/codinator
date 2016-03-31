//
//  HighlighterToken.swift
//  Codinator
//
//  Created by Vladimir Danila on 28/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class HighlighterToken: NSObject {

    let name: String!
    let expression: String!
    let attributes: [String: UIColor]!

    init(name: String, expression: String, attributes: [String: UIColor]) {
        self.name = name
        self.expression = expression
        self.attributes = attributes
    }

}

