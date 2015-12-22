//
//  ProjectExportViewController.h
//  Codinator
//
//  Created by Vladimir on 30/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

@import MessageUI;

#import "Polaris.h"

#import "SSZipArchive.h"

@interface ProjectExportViewController : UIViewController <SSZipArchiveDelegate,MFMailComposeViewControllerDelegate>{
    

    __weak IBOutlet UIButton *closeButton;
    __weak IBOutlet UIVisualEffectView *visualEffectView;
    
}

@property (nonatomic, strong) Polaris *projectManager;

@end
