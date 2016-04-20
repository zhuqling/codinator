//
//  FilesTableViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class FilesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!

    
    var items: [NSURL] = []
    
    var projectManager : Polaris! {
        
        get {
            return getSplitView.projectManager
        }
        
    }
    
    var getSplitView: ProjectSplitViewController! {
        
        get {
            return self.splitViewController as! ProjectSplitViewController
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = projectManager!.contentsOfDirectoryAtPath(projectManager!.projectUserDirectoryPath()) {
            self.items = items.map { $0 as! NSURL }
        }
        
        self.toolbarItems = [UIBarButtonItem(title: "test", style: .Plain, target: self, action: nil)]
        
    
        let insets = UIEdgeInsetsMake(0, 0, toolBar.frame.height, 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }

    
    var hasntOpenIndexFileYet = true
    override func viewDidAppear(animated: Bool) {
        
        
        // Keyboard show/hide notifications
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        if hasntOpenIndexFileYet {
            // Find 'index.html' and save index of it in the array itself
            let items = self.items.enumerate().filter { $0.element.absoluteString.hasSuffix("index.html")}
            
            // if 'items' isn't empty sellect the corresponding cell
            if items.isEmpty != true {
                let indexPath = NSIndexPath(forRow: items.first!.index, inSection: 0)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Top)
                tableView(tableView, didSelectRowAtIndexPath: indexPath)
                
                // Load WebView
                guard let webView = getSplitView.webView else {
                    return
                }
                
                guard let path = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(items.first!.element.lastPathComponent!) else {
                    return
                }
                
                webView.loadFileURL( NSURL(fileURLWithPath: path, isDirectory: false), allowingReadAccessToURL: NSURL(fileURLWithPath: path, isDirectory: true))
              
                
                hasntOpenIndexFileYet = false
            }
        }

    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...

        
        if let text = items[indexPath.row].lastPathComponent {
            cell.textLabel?.text = text
            
            if let path = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(text) {
                let manager = Thumbnail()
                cell.imageView?.image = manager.thumbnailForFileAtPath(path)
            }
        }

        return cell
    }


    @IBAction func add(sender: UIBarButtonItem) {
        let newFile = UIAlertAction(title: "New File", style: .Default) { (action : UIAlertAction) in
            self.performSegueWithIdentifier("newFile", sender: self)
        }
        
        let newSubpage = UIAlertAction(title: "New Subpage", style: .Default) { (action : UIAlertAction) in
            self.performSegueWithIdentifier("newSubpage", sender: self)
        }
        
        let newDir = UIAlertAction(title: "New Directory", style: .Default) { (action : UIAlertAction) in
            self.performSegueWithIdentifier("newDir", sender: self)
        }
        
        let Import = UIAlertAction(title: "Import", style: .Default) { (action : UIAlertAction) in
            
            
            self.performSegueWithIdentifier("import", sender: self)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        let popup = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        popup.addAction(newFile)
        popup.addAction(newSubpage)
        popup.addAction(newDir)
        popup.addAction(Import)
        popup.addAction(cancel)
        
        popup.view.tintColor = UIColor.purpleColor()
        
        popup.popoverPresentationController?.barButtonItem = sender
        self.presentViewController(popup, animated: true, completion: {
            popup.view.tintColor = UIColor.purpleColor()
        })
    }
    
    
    // MARK: - Keyboard show/hide
    
    let grabberViewHeight = CGFloat(10)
    var keyboardHeight: CGFloat = 0
    
    func keyboardWillShow(notification: NSNotification) {
//        let userInfo = notification.userInfo!
//        keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        

    }
    
    func keyboardWillHide(notification: NSNotification) {
//        keyboardHeight = 0
//        
//        var insets = tableView.contentInset
//        insets.bottom = 0
//        
//        tableView.contentInset = insets
//        tableView.scrollIndicatorInsets = insets
        
    }

    
    // MARK: - Navigation

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedPath = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(items[indexPath.row].lastPathComponent!) {
            var isDirectory : ObjCBool = ObjCBool(false)
            
            if (NSFileManager.defaultManager().fileExistsAtPath(selectedPath, isDirectory: &isDirectory) && Bool(isDirectory) == true) {
                projectManager.inspectorPath = projectManager.selectedFilePath
                
                if let controller = storyboard?.instantiateViewControllerWithIdentifier("files") {
                    self.navigationController?.showViewController(controller, sender: self)
                }
            } else {
               
               // getSplitView?.editorView!.text = "Hi there!"
                
                if let selectedPath = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(items[indexPath.row].lastPathComponent!) {
                    projectManager?.selectedFilePath = selectedPath
                    
                    if let splitViewController = self.splitViewController as? ProjectSplitViewController {
                       
                        guard let webView = splitViewController.webView else {
                            return
                        }
                        
                        webView.loadFileURL( NSURL(fileURLWithPath: selectedPath, isDirectory: false), allowingReadAccessToURL: NSURL(fileURLWithPath: projectManager!.selectedFilePath, isDirectory: true))
                        //}
                        //else {
                            // Repeat this till webView is initialized
                            //self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
                        //}
                        
                    }
                    
                    if let data = NSFileManager.defaultManager().contentsAtPath(selectedPath) {
                        let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                        
                        getSplitView.editorView!.text = contents as? String
                        
                    }
                    
                }
  
                
                
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//    }
}
