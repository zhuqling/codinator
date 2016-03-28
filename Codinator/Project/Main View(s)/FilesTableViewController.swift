//
//  FilesTableViewController.swift
//  Codinator
//
//  Created by Lennart Kerkvliet on 26-03-16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController {
    
    var items : NSMutableArray = []
    var projectManager : Polaris?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem())

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        projectManager = Polaris(projectPath: userDefaults.stringForKey("ProjectPath"), currentView: self.view, withWebServer: userDefaults.boolForKey("CnWebServer"), uploadServer: userDefaults.boolForKey("CnUploadServer"), andWebDavServer: userDefaults.boolForKey("CnWebDavServer"))
        if let items = projectManager?.contentsOfDirectoryAtPath(projectManager!.projectUserDirectoryPath()) {
            self.items = items
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...

        
        if let text = (items[indexPath.row] as? NSURL)?.lastPathComponent {
            cell.textLabel?.text = text
            
            if let path = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(text) {
                let manager = Thumbnail()
                cell.imageView?.image = manager.thumbnailForFileAtPath(path)
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
        
        popup.popoverPresentationController?.barButtonItem = sender
        self.presentViewController(popup, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedPath = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(items[indexPath.row].lastPathComponent!) {
            var isDirectory : ObjCBool = ObjCBool(false)
            
            if (NSFileManager.defaultManager().fileExistsAtPath(selectedPath, isDirectory: &isDirectory) && Bool(isDirectory) == true) {
                projectManager?.inspectorPath = projectManager!.selectedFilePath
                
                if let controller = storyboard?.instantiateViewControllerWithIdentifier("files") {
                    self.navigationController?.showViewController(controller, sender: self)
                }
            } else {
                self.performSegueWithIdentifier("editor", sender: self)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if let navigation = segue.destinationViewController as? UINavigationController {
            if let controller = navigation.viewControllers[0] as? EditorViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let selectedPath = (projectManager?.inspectorPath as NSString?)?.stringByAppendingPathComponent(items[indexPath.row].lastPathComponent!) {
                        projectManager?.selectedFilePath = selectedPath

                        if let splitViewController = self.splitViewController as? ProjectSplitViewController {
                            splitViewController.webView?.loadFileURL( NSURL(fileURLWithPath: selectedPath, isDirectory: false), allowingReadAccessToURL: NSURL(fileURLWithPath: projectManager!.inspectorPath, isDirectory: true))
                        }
                        
                        if let data = NSFileManager.defaultManager().contentsAtPath(selectedPath) {
                            let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
                            controller.text = contents as? String
                        }
                        
                        controller.documentTitle = items[indexPath.row].lastPathComponent!
                        controller.projectManager = self.projectManager
                    }
                }
            }
        }
    }
}
