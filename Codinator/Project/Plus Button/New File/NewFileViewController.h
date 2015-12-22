//
//  NewFileViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 20/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@interface NewFileViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>{
    
    IBOutlet UIScrollView *scrollView;
    
    
    IBOutlet UITextField *nameTextfield;
    IBOutlet UITextField *extensionTextfield;
    IBOutlet UIButton *addButton;
    
    __weak IBOutlet UIButton *closeButton;
}


@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *path;

@end
