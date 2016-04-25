//
//  FileMoverViewController.swift
//  Codinator
//
//  Created by Vladimir Danila on 25/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class FileMoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var fileUrl: NSURL?
    
    var items: [NSURL]?
    
    let fileManager = NSFileManager.defaultManager()
    
    
    var delegate: NewFilesDelegate?
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    var backButtonEnabled: Bool {
        get {
            print(inspectorUrl?.path)
            return !(inspectorUrl!.path!.hasSuffix(".cnProj/Assets") || inspectorUrl!.path!.hasSuffix(".cnProj/Assets/"))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            inspectorUrl = fileUrl!.URLByDeletingLastPathComponent!
            items = try fileManager.contentsOfDirectoryAtURL(inspectorUrl!, includingPropertiesForKeys: [], options: .SkipsHiddenFiles)
            tableView.reloadData()
            
        } catch let error as NSError {
            Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Error", viewController: self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        backButton.enabled = backButtonEnabled
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Buttons
    
    @IBAction func cancelDidPush() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func moveFile() {
        
        let destinationUrl = inspectorUrl?.URLByAppendingPathComponent(fileUrl!.lastPathComponent!)
        if fileUrl?.absoluteString != destinationUrl?.absoluteString {
            
            do {
                try fileManager.moveItemAtURL(fileUrl!, toURL: destinationUrl!)
                self.dismissViewControllerAnimated(true, completion: {
                    self.delegate?.reloadData()
                })
            } catch let error as NSError {
                Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Error", viewController: self)
            }
        
        }
        else {
            Notifications.sharedInstance.alertWithMessage(nil, title: "Locations are the same", viewController: self)
        }
    
    }
    
    @IBAction func backDidPush(sender: UIBarButtonItem) {
        inspectorUrl = inspectorUrl?.URLByDeletingLastPathComponent
        
        do {
            items = try fileManager.contentsOfDirectoryAtURL(inspectorUrl!, includingPropertiesForKeys: [], options: .SkipsHiddenFiles)
            tableView.reloadData()
            
        } catch let error as NSError {
            Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Error", viewController: self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        backButton.enabled = backButtonEnabled
    }
    

    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    
    var inspectorUrl: NSURL?
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.blackColor()
        cell.selectedBackgroundView = bgColorView
        cell.backgroundColor = tableView.backgroundColor
        
        
        if let text = items![indexPath.row].lastPathComponent {
            cell.textLabel?.text = text
            cell.textLabel?.textColor = UIColor.whiteColor()
            
            if let path = inspectorUrl?.URLByAppendingPathComponent(text) {
                let manager = Thumbnail()
                cell.imageView?.image = manager.thumbnailForFileAtPath(path.path)
            }
        }
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedUrl = inspectorUrl?.URLByAppendingPathComponent(items![indexPath.row].lastPathComponent!, isDirectory: true)
        
        
        var isDirectory : ObjCBool = ObjCBool(false)
        
        if (NSFileManager.defaultManager().fileExistsAtPath(selectedUrl!.path!, isDirectory: &isDirectory) && Bool(isDirectory) == true) {
            
            do {
                inspectorUrl = selectedUrl
                items = try fileManager.contentsOfDirectoryAtURL(inspectorUrl!, includingPropertiesForKeys: [], options: .SkipsHiddenFiles)
                tableView.reloadData()
                
            } catch let error as NSError {
                Notifications.sharedInstance.alertWithMessage(error.localizedDescription, title: "Error", viewController: self)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            backButton.enabled = backButtonEnabled
            
        }
        
    }
    
}
