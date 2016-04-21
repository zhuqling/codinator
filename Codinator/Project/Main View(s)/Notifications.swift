//
//  Notifications.swift
//  Codinator
//
//  Created by Vladimir Danila on 20/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import Foundation

class Notifications: NSObject {
    static let sharedInstance = Notifications()
    
    var viewController: UIViewController!
    
    func displaySuccessMessage(message: String) {
        CSNotificationView.showInViewController(viewController, style: .Success, message: message)
    }
    
    func displayErrorMessage(message: String) {
        CSNotificationView.showInViewController(viewController, style: .Error, message: message)
    }
    
    func displayNeutralMessage(message: String) {
        CSNotificationView.showInViewController(viewController, tintColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(18), textAlignment: .Center, image: nil, message: message, duration: 3.0)
    }
    
    
    func alertWithMessage(message: String?, title: String?, viewController: UIViewController) {
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(cancelAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func alertWithMessage(message: String, title: String) {
        let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(cancelAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
//    -(void)displaySuccesNotificationWithMesssage:(NSString*)message{
//    [CSNotificationView showInViewController:self
//    style:CSNotificationViewStyleSuccess
//    message:message];
//    }
//    
//    -(void)displayErrorNotificationWithMesssage:(NSString*)message{
//    [CSNotificationView showInViewController:self
//    style:CSNotificationViewStyleError
//    message:message];
//    }
//    
//    -(void)displayNeutralNotificationWithMessage:(NSString*)message{
//    [CSNotificationView showInViewController:self tintColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentCenter image:nil message:message duration:3.0];
//    }
}