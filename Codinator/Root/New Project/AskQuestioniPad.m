//
//  AskQuestioniPad.m
//  VWAS-HTML
//
//  Created by Vladimir on 14/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@import Crashlytics;

#import "Polaris.h"
#import "CodinatorDocument.h"
#import "AppDelegate.h"
#import "AskQuestioniPad.h"


@interface AskQuestioniPad() {

    Polaris *projectManager;
    __weak IBOutlet UIButton *cancelButton;

}


@end


@implementation AskQuestioniPad

UIColor *violett;
BOOL usePhp;
BOOL useJs;
BOOL useCss;

BOOL useFtp;
BOOL useVersion;

BOOL usePhp2;
BOOL useJs2;
BOOL useCss2;

BOOL useFtp2;
BOOL useVersion2;

BOOL done;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    violett = nextButton.backgroundColor;
    //nextButton.backgroundColor = [UIColor grayColor];
    nextButton.enabled = NO;
    //cancelButton.layer.cornerRadius = 5;
    //cancelButton.layer.masksToBounds = YES;
    
    usePHPButtonNo.selected = YES;
    usePHPButtonYes.selected = NO;
    usePhp2 = YES;
    usePhp = NO;
    
    
    useCss2 = YES;
    useCss = YES;
    
    useJs2 = YES;
    useJs = YES;
    
    useVersion = YES;
    useVersion2 = YES;
    
    useFtp2 = YES;
    useFtp  = YES;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    copyrightTextField.text = yearString;
    
    [self checkNext];
    
    
}





#pragma mark - YN buttons



//first block

- (IBAction)usePhpY:(id)sender {
    usePHPButtonYes.selected = YES;
    usePHPButtonNo.selected = NO;
    
    usePhp2 = YES;
    usePhp = YES;
    [self checkNext];
}

- (IBAction)usePhpN:(id)sender {
    usePHPButtonNo.selected = YES;
    usePHPButtonYes.selected = NO;
    
    usePhp2 = YES;
    usePhp = NO;
}


- (IBAction)useJsY:(id)sender {
    useJsButtonYes.selected = YES;
    useJsButtonNo.selected = NO;
    
    useJs2 = YES;
    useJs = YES;
    [self checkNext];
}

- (IBAction)useJsN:(id)sender {
    useJsButtonNo.selected = YES;
    useJsButtonYes.selected = NO;
    
    useJs2 = YES;
    useJs = NO;
    [self checkNext];
}


- (IBAction)useCssY:(id)sender {
    useCssButtonYes.selected = YES;
    useCssButtonNo.selected = NO;
    
    useCss2 = YES;
    useCss = YES;
    [self checkNext];
}

- (IBAction)useCssNo:(id)sender {
    useCssButtonNo.selected = YES;
    useCssButtonYes.selected = NO;
    
    useCss2 = YES;
    useCss  = NO;
    [self checkNext];
}

//second block

- (IBAction)useFtpY:(id)sender {
    useFtpButtonYes.selected = YES;
    useFtpButtonNo.selected = NO;
    
    useFtp2 = YES;
    useFtp = YES;
    [self checkNext];
}

- (IBAction)useFtpN:(id)sender {
    useFtpButtonNo.selected = YES;
    useFtpButtonYes.selected = NO;
    
    useFtp2 = YES;
    useFtp = NO;
    [self checkNext];
}


- (IBAction)useVersionY:(id)sender {
    useVersionControllButtonYes.selected = YES;
    useVersionControllButtonNo.selected = NO;
    
    useVersion2 = YES;
    useVersion = YES;
    [self checkNext];
}

- (IBAction)useVersionN:(id)sender {
    useVersionControllButtonNo.selected = YES;
    useVersionControllButtonYes.selected = NO;
    
    useVersion2 = YES;
    useVersion = NO;
    [self checkNext];
}






-(void)checkNext{
    if (usePhp2 && useJs2 && useCss2 && useFtp2 && useVersion2) {
        if (webPageNameTextField.text.length == 0) {
            /*webPageNameTextField.backgroundColor = [UIColor blackColor];
            webPageNameTextField.textColor = copyrightTextField.textColor;
  
            nextButton.backgroundColor = violett;

            webPageNameTextField.layer.cornerRadius = 5.0f;
            webPageNameTextField.layer.borderColor = [[UIColor blackColor] CGColor];
            webPageNameTextField.layer.borderWidth = 1.0f;*/
            
            nextButton.enabled = true;
            
            
            
        }
        else{
           
            
            
            
            //webPageNameTextField.backgroundColor = [UIColor redColor];
            
            /*webPageNameTextField.layer.borderColor = [violett CGColor];
            webPageNameTextField.layer.borderWidth = 1.0f;
            webPageNameTextField.layer.cornerRadius = 5.0f;

            
            
            
            webPageNameTextField.textColor = [UIColor whiteColor];*/
            nextButton.enabled = true;
            [self performSelector:@selector(checkNext) withObject:self afterDelay:0.1];

        }
    }
    else{
        [self performSelector:@selector(checkNext) withObject:self afterDelay:0.1];
    }
}



#pragma mark - generator


- (IBAction)nextDidPush:(id)sender {
    visualEffectView.hidden = NO;
    [UIView animateWithDuration:1.0f animations:^{
        visualEffectView.alpha = 1.0f;
    }];
    
    
    
    
    [self createProject];
    [self performSelector:@selector(animateProgressView) withObject:self afterDelay:0.5];
    [self performSelector:@selector(animateProgressView) withObject:self afterDelay:0.6];
    [self performSelector:@selector(animateProgressView) withObject:self afterDelay:0.7];
    [self performSelector:@selector(animateProgressView) withObject:self afterDelay:0.8];
    [self performSelector:@selector(animateProgressView) withObject:self afterDelay:0.9];

    

}

- (void)animateProgressView{
    [progressView setProgress:progressView.progress + 0.2 animated:YES];
    NSLog(@"%f",progressView.progress);
    
    if (progressView.progress == 1.0) {
        [self performSelector:@selector(cancelDidPush:) withObject:nil afterDelay:1.0];
    }
}

-(void)createProject{

    //Root Path
    NSString *root = [AppDelegate storagePath];
    
    //Final Path
    NSString *path = [root stringByAppendingPathComponent:@"Projects"];
    

    NSString *name = [NSString stringWithFormat:@"%@.cnProj", webPageNameTextField.text];
    CodinatorDocument *codinatorDocument = [[CodinatorDocument alloc] initWithFileURL:[NSURL fileURLWithPath:[path stringByAppendingPathComponent:name]]];
    
    [codinatorDocument saveToURL:[NSURL fileURLWithPath:[path stringByAppendingPathComponent:name]]
                forSaveOperation: UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success){
                       NSLog(@"Created");
                   } else {
                       NSLog(@"Not created");
                   }
               }];
    
    
    [codinatorDocument openWithCompletionHandler:^(BOOL success) {
       
        if (success) {
            
            projectManager = [[Polaris alloc] initWithCreatingProjectRequiredFilesAtPath:[path stringByAppendingPathComponent:name]];
            
            if (usePhp) {
                NSError *error;
                NSString *fileName = @"index.php";
                NSString *fileContents = [NSString stringWithFormat:
                                          @"<?php \n\
                                          // %@ %@\n\
                                          \n\
                                          ?>",copyrightTextField.text, webPageNameTextField.text];
                
                NSString *filePath = [[projectManager projectUserDirectoryPath] stringByAppendingPathComponent:fileName];
                [fileContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                    [self cancelDidPush:nil];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                    [alert addAction:closeAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            else{
                NSString *script;
                NSString *stylsheet;
                NSString *finalString;
                if (useCss) {
                    stylsheet = @"<link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\">";
                    finalString = [NSString stringWithFormat:@"%@",stylsheet];
                    
                }
                if (useJs) {
                    script = @"<script src=\"script.js\"></script>";
                    finalString = [NSString stringWithFormat:@"%@",script];
                    
                }
                if (useCss && useJs) {
                    finalString = [NSString stringWithFormat:@"%@\n                %@",stylsheet,script];
                }
                
                
                
                
                
                NSError *error;
                NSString *fileName = @"index.html";
            	NSString *fileContents = [NSString stringWithFormat:
@"<!DOCTYPE html> \n\
<html> \n\
           <head> \n\
                <title>%@</title> \n\
                <meta charset=\"utf-8\"> \n\
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n\
                %@\n\
           </head> \n\
           <body> \n\
           \n\
                <h1>%@</h1> \n\
                <p>Hello world</p>		\n\
              \n\
           </body> \n\
</html>" ,webPageNameTextField.text,finalString,webPageNameTextField.text];
                
                
                NSString *filePath = [[projectManager projectUserDirectoryPath] stringByAppendingPathComponent:fileName];
                [fileContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                    [self cancelDidPush:nil];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                    [alert addAction:closeAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }
            
            
            if (useCss) {
                NSError *error;
                NSString *fileName = @"style.css";
                NSString *fileContents = [NSString stringWithFormat:
                                          @"/* Normalize.css brings consistency to browsers. \n\
                                             https://github.com/necolas/normalize.css */ \n\
                                          \n\
                                          @import url(http://cdn.jsdelivr.net/normalize/2.1.3/normalize.min.css); \n\
                                          \n\
                                          /* A fresh start */"];
                
                
                NSString *filePath = [[projectManager projectUserDirectoryPath] stringByAppendingPathComponent:fileName];
                [fileContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                    [self cancelDidPush:nil];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                    [alert addAction:closeAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
            }
            
            
            
            if (useJs) {
                NSError *error;
                NSString *fileName = @"script.js";
                NSString *fileContents = [NSString stringWithFormat:
                                          @""];
                
                NSString *filePath = [[projectManager projectUserDirectoryPath] stringByAppendingPathComponent:fileName];
                [fileContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                    [self cancelDidPush:nil];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                    [alert addAction:closeAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            NSString *useVersion;
            if (useVersion) {
                useVersion = @"YES";
            }
            else{
                useVersion = @"NO";
            }
            
            
            NSString *useFTP;
            if (useFtp) {
                useFTP = @"YES";
            }
            else{
                useFTP = @"NO";
            }
            
            NSString *usePHP;
            if (usePhp) {
                usePHP = @"YES";
            }
            else{
                usePHP = @"NO";
            }
            
            
            
            [projectManager saveValue:webPageNameTextField.text forKey:@"ProjectName"];
            [projectManager saveValue:copyrightTextField.text forKey:@"Copyright"];
            [projectManager saveValue:useVersion forKey:@"UseVersionControll"];
            [projectManager saveValue:useFTP forKey:@"UseFTP"];
            [projectManager saveValue:usePHP forKey:@"UsePHP"];
            [projectManager saveValue:@"1" forKey:@"version"];
            
            
            
            
            [Answers logCustomEventWithName:@"Created Project"
                           customAttributes:@{
                                              @"ProjectName" : webPageNameTextField.text,
                                              @"Copyright" : copyrightTextField.text,
                                              @"UseVersionControll" : useVersion,
                                              @"UsePHP" : usePHP,
                                              @"UseFTP" : useFTP
                                              }];

            
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:closeAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
    
    [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
        done = YES;
    }];
    
}



#pragma mark - delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}



#pragma mark - basic



- (IBAction)cancelDidPush:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];

    
    [self dismissViewControllerAnimated:YES completion:^{
        if (!done) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error creating project" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:closeAlert];
            [self presentViewController:alert animated:YES completion:nil];
        
        }
    }];
    
    usePhp2 = NO;
    useJs2 = NO;
    useCss2 = NO;
    useFtp2 = NO;
    useVersion2 = NO;
    
}






@end
