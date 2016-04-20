//
//  AskQuestioniPad.h
//  VWAS-HTML
//
//  Created by Vladimir on 14/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@interface AskQuestioniPad : UIViewController<UITextFieldDelegate>{
    
    
    IBOutlet UIButton *usePHPButtonYes;
    IBOutlet UIButton *usePHPButtonNo;

    IBOutlet UIButton *useJsButtonYes;
    IBOutlet UIButton *useJsButtonNo;

    IBOutlet UIButton *useCssButtonYes;
    IBOutlet UIButton *useCssButtonNo;

    
    IBOutlet UIButton *useFtpButtonYes;
    IBOutlet UIButton *useFtpButtonNo;

    IBOutlet UIButton *useVersionControllButtonYes;
    IBOutlet UIButton *useVersionControllButtonNo;


    
    
    IBOutlet UIButton *nextButton;
    
    
    
    IBOutlet UIVisualEffectView *visualEffectView;
    
    
    
    
    IBOutlet UITextField *webPageNameTextField;
    IBOutlet UITextField *copyrightTextField;
    
    IBOutlet UIProgressView *progressView;
    
}



@end
