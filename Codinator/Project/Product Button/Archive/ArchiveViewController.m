//
//  ArchiveViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 25/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

@import Crashlytics;
#import "ArchiveViewController.h"

@interface ArchiveViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextView *commitTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@end


@implementation ArchiveViewController
@synthesize projectManager,commitTextView,closeButton,commitButton;


- (void)viewDidLoad {
    [super viewDidLoad];

    closeButton.layer.cornerRadius = 5;
    
    commitTextView.layer.cornerRadius = 10;
    commitTextView.layer.masksToBounds = YES;
    
    commitTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)archiveDidPush:(id)sender {
    
    [commitTextView resignFirstResponder];
    
    [projectManager archiveWorkingCopyWithCommitMessge:commitTextView.text];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Project is 📦 now." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                    [self dismissViewControllerAnimated:true completion:^{
                        
                        [Answers logCustomEventWithName:@"Archived Version"
                                       customAttributes:@{
                                                          @"Commit text" : commitTextView.text}];
                        
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                }];
    
    
    
    [alert addAction:closeAlert];
    [self presentViewController:alert animated:YES completion:nil];
        
}




- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}



- (IBAction)closeButtonDidPush:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}




@end
