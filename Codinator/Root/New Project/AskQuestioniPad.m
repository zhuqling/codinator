//
//  AskQuestioniPad.m
//  VWAS-HTML
//
//  Created by Vladimir on 14/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


#import "Polaris.h"
#import "CodinatorDocument.h"
#import "AppDelegate.h"
#import "AskQuestioniPad.h"
#import "FileTemplates.h"
#import "Codinator-Swift.h"

@interface AskQuestioniPad() <UITextFieldDelegate>{

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
    nextButton.backgroundColor = [UIColor grayColor];
    nextButton.enabled = NO;

    
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
    
    
    [webPageNameTextField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
}





-(void)checkNext{
    if (usePhp2 && useJs2 && useCss2 && useFtp2 && useVersion2) {
        if (webPageNameTextField.text.length != 0) {
            webPageNameTextField.backgroundColor = [copyrightTextField backgroundColor];
            webPageNameTextField.textColor = copyrightTextField.textColor;
  
            [UIView animateWithDuration:0.1f animations:^{
                nextButton.backgroundColor = violett;
            }];

            webPageNameTextField.layer.cornerRadius = 5.0f;
            webPageNameTextField.layer.borderColor = [[UIColor blackColor] CGColor];
            webPageNameTextField.layer.borderWidth = 0;
            
            nextButton.enabled = YES;
            
            
        }
        else{
           
            
            
            
            webPageNameTextField.layer.borderColor = [violett CGColor];
            webPageNameTextField.layer.borderWidth = 1.0f;
            webPageNameTextField.layer.cornerRadius = 5.0f;

            nextButton.enabled = NO;
            
            [UIView animateWithDuration:0.1f animations:^{
                nextButton.backgroundColor = [UIColor grayColor];
                nextButton.titleLabel.textColor = [UIColor darkGrayColor];

            }];
            
            
            
            webPageNameTextField.textColor = [UIColor whiteColor];
            [self performSelector:@selector(checkNext) withObject:self afterDelay:0.1];

        }
    }
    else{
        [self performSelector:@selector(checkNext) withObject:self afterDelay:0.1];
    }
}



#pragma mark - generator


- (IBAction)nextDidPush:(id)sender {
    
    //Root Path
    NSString *root = [AppDelegate storagePath];
    
    //Final Path
    NSString *path = [root stringByAppendingPathComponent:@"Projects"];


    NSString *name = [NSString stringWithFormat:@"%@.cnProj", webPageNameTextField.text];
    NSURL *saveUrl = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:name]];

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:saveUrl.path]) {
        
        [[Notifications sharedInstance] alertWithMessage:@"Due to security reasons we don't allow overwriting existing projects. Choose a different name or rename the existing one." title:@"Warning" viewController:self];
        
    }
    else {
    
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
    
    NSURL *saveUrl = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:name]];
                      
    if ([[NSFileManager defaultManager] fileExistsAtPath:saveUrl.path]) {
        
        [[Notifications sharedInstance] alertWithMessage:@"Due to security reasons we don't allow overwriting existing projects. Choose a different name or rename the existing one." title:@"Warning" viewController:self];
        
    }
    else {
    
    [codinatorDocument saveToURL:saveUrl
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
                
                NSURL *fileURL = [[projectManager projectUserDirectoryURL] URLByAppendingPathComponent:fileName];
                [fileContents writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
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
                NSString *fileContents = [FileTemplates htmlTemplateFileForName:webPageNameTextField.text];
                
                
                NSURL *fileURL = [[projectManager projectUserDirectoryURL] URLByAppendingPathComponent:fileName];
                [fileContents writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
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
                NSString *fileContents = [FileTemplates cssTemplateFile];
                
                
                NSURL *fileURL = [[projectManager projectUserDirectoryURL] URLByAppendingPathComponent:fileName];
                [fileContents writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
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
                NSString *fileContents = [FileTemplates jsTemplateFile ];
                
                NSURL *fileURL = [[projectManager projectUserDirectoryURL] URLByAppendingPathComponent:fileName];
                [fileContents writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
                
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
}



#pragma mark - delegates

- (void)textFieldDidChange {
    [self checkNext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return NO;
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
