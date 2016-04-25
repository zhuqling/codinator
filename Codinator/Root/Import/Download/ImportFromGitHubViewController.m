//
//  ImportFromGitHubViewController.m
//  Codinator
//
//  Created by Vladimir on 31/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "ImportFromGitHubViewController.h"
#import "CSNotificationView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface ImportFromGitHubViewController (){
    
    bool isGitHub;
    
}

//delegate
@property (strong, nonatomic) AppDelegate *appDelegate;


//Github
@property (weak, nonatomic) IBOutlet UIView *gitHubView;


//Path for Zip Textfield
@property (weak, nonatomic) IBOutlet UITextField *pathTextField;



//progress
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;
@property (weak, nonatomic) IBOutlet UISwitch *uiSwitch;


@end



@implementation ImportFromGitHubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gitHubView.layer.cornerRadius = 5;

    self.gitHubView.alpha = .0f;

    
    //link to app delegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
}





#pragma mark - buttons

- (IBAction)closeDidPush:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)gitHubSwitch:(id)sender {
    
    if (_uiSwitch.on == true) {
        self.pathTextField.text = @"(user)/(proj)/zip/master";
        self.pathTextField.placeholder = @"(user)/(proj)/zip/master";
        self.pathTextField.keyboardType = UIKeyboardTypeAlphabet;
        
        isGitHub = YES;
    }
    else {
        self.pathTextField.text = @"https://";
        self.pathTextField.placeholder = @"https://";
        self.pathTextField.keyboardType = UIKeyboardTypeURL;
        
        isGitHub = false;
    }
    
}






- (IBAction)goDidPush:(id)sender {

    
    [self.pathTextField resignFirstResponder];
    
    
    self.uiSwitch.enabled = false;
    self.pathTextField.enabled = false;
    self.cancelButton.enabled = false;
    self.downloadButton.enabled = false;
    self.progressView.hidden = NO;
    self.progressView.progress = 0.0;
    
    
    
    NSString *currentURL = [NSString stringWithFormat:@"https://codeload.github.com/%@",self.pathTextField.text];
    if (!isGitHub) {
        currentURL = self.pathTextField.text;
    }
    
    
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
            
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];
                
            }];
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
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];

                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];

                }];
                
            }];
            
            
            
            [operation start];

        }
        else{
            
            //Show error;
            
            self.uiSwitch.enabled = YES;
            self.pathTextField.enabled = YES;
            self.cancelButton.enabled = YES;
            self.downloadButton.enabled = YES;
            self.progressView.hidden = YES;
            self.progressView.progress = 0.0;
            
            
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
