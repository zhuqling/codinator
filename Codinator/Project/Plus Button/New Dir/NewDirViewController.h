//
//  NewDirViewController.h
//  VWAS-HTML
//
//  Created by Vladi Danila on 22/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "Polaris.h"

@interface NewDirViewController : UIViewController<UITextFieldDelegate>{
    
     IBOutlet UITextField *nameTextField;
}

@property (nonatomic ,strong)Polaris *projectManager;

@end
