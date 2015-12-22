//
//  NewSubpageViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 21/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "Polaris.h"

@interface NewSubpageViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UIButton *createButton;
    
    IBOutlet UITextField *nameTextField;
    

    __weak IBOutlet UIButton *closeButton;
    
    
    
}

@property (nonatomic, strong) Polaris *projectManager;


@end
