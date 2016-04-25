//
//  PeekImageViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit


class PeekImageViewController: UIViewController {

    
    var delegate: PeekProtocol?
    
    var isDir = false
    
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        var items = [UIPreviewActionItem]()
        
        if isDir == false {
            let printAction = UIPreviewAction(title: "Print", style: .Default, handler: { _ in
            self.delegate?.print()
            })
            
            items.append(printAction)
        }
        
        
        let moveAction = UIPreviewAction(title: "Move file", style: .Default, handler: { _ in
            self.delegate?.move()
        })
        
        
        let renameAction = UIPreviewAction(title: "Rename", style: .Default, handler: { _ in
             self.delegate?.rename()
        })
        
        let shareAction = UIPreviewAction(title: "Share", style: .Default, handler: { _ in
            self.delegate?.share()
        })
        
        let deleteAction = UIPreviewAction(title: "Delete", style: .Destructive, handler: { _ in
            self.delegate?.delete()
        })
        
        [moveAction, renameAction, shareAction, deleteAction].forEach { items.append($0) }
        
        return items
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
