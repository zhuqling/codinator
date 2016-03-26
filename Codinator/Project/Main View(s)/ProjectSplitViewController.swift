//
//  ProjectSplitViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class ProjectSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maximumPrimaryColumnWidth = 2000
        self.preferredPrimaryColumnWidthFraction = 0.25
    }
}
