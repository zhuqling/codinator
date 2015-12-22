//
//  ImportFromGitHubViewController.m
//  Codinator
//
//  Created by Vladimir on 31/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

@import Crashlytics;

#import "ImportFromGitHubViewController.h"
#import "CSNotificationView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface ImportFromGitHubViewController (){
    
    bool isGitHub;
    
}

//close Button
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

//delegate
@property (strong, nonatomic) AppDelegate *appDelegate;


//Github
@property (weak, nonatomic) IBOutlet UIView *gitHubView;


//Path for Zip Textfield
@property (weak, nonatomic) IBOutlet UITextField *pathTextField;



//progress
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end



@implementation ImportFromGitHubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = 5;
    self.gitHubView.layer.cornerRadius = 5;

    self.gitHubView.alpha = .0f;

    
    //link to app delegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
}





#pragma mark - buttons

- (IBAction)closeDidPush:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


- (IBAction)gitHubDidPush:(id)sender {
    
    self.pathTextField.text = @"(user)/(proj)/zip/master";
    self.pathTextField.placeholder = @"(user)/(proj)/zip/master";
    self.pathTextField.keyboardType = UIKeyboardTypeAlphabet;
    
    
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.gitHubView.alpha = 1.0f;
        
    }completion:nil];
    
    isGitHub = YES;
}




- (IBAction)otherDidPush:(id)sender {
    
    self.pathTextField.text = @"http://";
    self.pathTextField.placeholder = @"http://";
    self.pathTextField.keyboardType = UIKeyboardTypeURL;

    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.gitHubView.alpha = 1.0f;
        
    }completion:nil];
    

}





- (IBAction)goDidPush:(id)sender {

    
    [self.pathTextField resignFirstResponder];
    
    self.progressView.hidden = NO;
    self.progressView.progress = 0.0;
    
    
    NSString *currentURL = [NSString stringWithFormat:@"https://codeload.github.com/%@",self.pathTextField.text];
    if (!isGitHub) {
        currentURL = self.pathTextField.text;
    }
    
    
    [Answers logCustomEventWithName:@"Import from Web"
                   customAttributes:@{
                                      @"Imported from" : currentURL
                                      }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    //Root Path
    NSString const *root = [AppDelegate storagePath];
    
    //Custom Paths
    NSString const *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];
    
    
    
    
    NSString *filePath;
    
    if (isGitHub) {
        NSString *firstPart = [currentURL stringByDeletingLastPathComponent];
        NSString *seccondPart = [firstPart stringByDeletingLastPathComponent];
        
        
        filePath = [projectsDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",[seccondPart lastPathComponent]]];
        

        
        
        
        
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            self.progressView.progress = totalBytesRead / totalBytesExpectedToRead;
            
        }];
        
        [operation setCompletionBlock:^{
            #ifdef DEBUG
            NSLog(@"downloadComplete!");
            #endif
            
            [self dismissViewControllerAnimated:true completion:nil];
            
        }];
        
        
        
        [operation start];

        
        
    }
    else{ //GitHub was NOT selected
        
        filePath = [projectsDirPath stringByAppendingPathComponent:[self.pathTextField.text lastPathComponent]];
        
        
        
        
        //Check if downloadable project is a zip
        if ([filePath containsString:@".zip"]) {
            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
            
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                
                self.progressView.progress = totalBytesRead / totalBytesExpectedToRead;
                
            }];
            
            [operation setCompletionBlock:^{
                #ifdef DEBUG
                NSLog(@"downloadComplete!");
                #endif
                
                [self dismissViewControllerAnimated:true completion:nil];
                
            }];
            
            
            
            [operation start];

        }
        else{
            
            //Show error;

            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"You can only download zipped projects right now."];
            
            self.progressView.hidden = YES;
            
        }
        
        
    }
    
    
    
    
    
    

}



#pragma mark - UX


- (IBAction)hideView:(id)sender {
    
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.gitHubView.alpha = .0f;
        
    }completion:nil];
    
}



#pragma mark - delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
