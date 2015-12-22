//
//  GitHubViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 29/04/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "Polaris.h"

@interface GitHubViewController : UIViewController{
    
    
    IBOutlet UIImageView *bgImageView;
    
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;


}


@property  (nonatomic, strong) Polaris *projectManager;


@end
