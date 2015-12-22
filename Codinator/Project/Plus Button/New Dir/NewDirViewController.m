//
//  NewDirViewController.m
//  VWAS-HTML
//
//  Created by Vladi Danila on 22/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "NewDirViewController.h"

@interface NewDirViewController ()

@end

@implementation NewDirViewController
@synthesize projectManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Dir name..." attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
 
   
    //round interface a bit
    closeButton.layer.cornerRadius = 5;
    closeButton.layer.masksToBounds = YES;
    
}


#pragma mark - Shortcuts

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSArray *)keyCommands {
    
    return @[
             [UIKeyCommand keyCommandWithInput:@"W" modifierFlags:UIKeyModifierCommand action:@selector(cancelDidPush:) discoverabilityTitle:@"Close Window"]
             ];
}




-(void)textFieldDidBeginEditing:(UITextField *)textField{
    nameTextField.backgroundColor = [UIColor blackColor];
    nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Dir name..." attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self dirDidPush:nil];
    return YES;
}


- (IBAction)dirDidPush:(id)sender {
    
    if (nameTextField.text.length == 0) {
        nameTextField.backgroundColor = [UIColor redColor];
        nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Dir name..." attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        [nameTextField becomeFirstResponder];

    }
    else{
        
        
        NSError *error;
        NSString *name = [NSString stringWithFormat:@"%@/",nameTextField.text];
        NSString *dirPath = [projectManager.inspectorPath stringByAppendingPathComponent:name];
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];

        if (!error) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"history" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dirCreated" object:self userInfo:nil];

        }
        else{
            NSString *message = [NSString stringWithFormat:@"There was an unexpected error: %@",[error localizedDescription]];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
                                [self dismissViewControllerAnimated:true completion:nil];
                            }];
            [alert addAction:closeAlert];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        

        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)cancelDidPush:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
