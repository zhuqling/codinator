//
//  PeekProtocol.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

protocol PeekProtocol {
    func print()
    func move()
    func rename()
    func share()
    func delete()
}


protocol PeekShortProtocol {
    func rename()
    func delete()
}