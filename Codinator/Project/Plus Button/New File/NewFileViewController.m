//
//  NewFileViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 20/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "NewFileViewController.h"

@implementation NewFileViewController
@synthesize items,path;
NSInteger level;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIColor *color = [UIColor lightGrayColor];
    nameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName: color}];
    extensionTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"extension" attributes:@{NSForegroundColorAttributeName: color}];

    
    
    NSError *error;
    items = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error] mutableCopy];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        scrollView.contentSize = CGSizeMake(0, 466);
    }
    
    
    //round interface a bit
    closeButton.layer.cornerRadius = 5;


    
    extensionTextfield.layer.borderWidth = 1.0f;
    extensionTextfield.layer.cornerRadius = 3;
    extensionTextfield.layer.borderColor = [[UIColor colorWithRed:0.278107f green:0.166531f blue:0.463691f alpha:1.0f] CGColor];
    
    
    nameTextfield.layer.borderWidth = 1.0f;
    nameTextfield.layer.cornerRadius = 3;
    nameTextfield.layer.borderColor = [[UIColor colorWithRed:0.278107f green:0.166531f blue:0.463691f alpha:1.0f] CGColor];
    
    
    
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



- (IBAction)html:(id)sender {
    extensionTextfield.text = @"html";
    
    extensionTextfield.layer.borderWidth = 0;
    extensionTextfield.layer.cornerRadius = 3;
    
    [nameTextfield becomeFirstResponder];
    level = 0;
}
- (IBAction)css:(id)sender {
    extensionTextfield.text = @"css";
    
    extensionTextfield.layer.borderWidth = 0;
    extensionTextfield.layer.cornerRadius = 3;
    
    [nameTextfield becomeFirstResponder];
    level = 1;
}
- (IBAction)js:(id)sender {
    extensionTextfield.text = @"js";
    
    extensionTextfield.layer.masksToBounds = true;
    extensionTextfield.layer.borderWidth = 0;
    extensionTextfield.layer.cornerRadius = 3;
    
    [nameTextfield becomeFirstResponder];
    level = 2;
}

- (IBAction)txt:(id)sender {
    extensionTextfield.text = @"txt";
    
    extensionTextfield.layer.borderWidth = 0;
    extensionTextfield.layer.cornerRadius = 3;
    
    [nameTextfield becomeFirstResponder];
    level = 3;
}
- (IBAction)php:(id)sender {
    extensionTextfield.text = @"php";
    
    extensionTextfield.layer.borderWidth = 0;
    extensionTextfield.layer.cornerRadius = 3;
    
    [nameTextfield becomeFirstResponder];
    level = 4;
}
- (IBAction)generic:(id)sender {
    extensionTextfield.text = @"";
    
    extensionTextfield.layer.borderWidth = 0;
    extensionTextfield.layer.cornerRadius = 3;
    
    [extensionTextfield becomeFirstResponder];
    level = 5;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.text.length == 0) {
        //nameTextfield.backgroundColor = [UIColor redColor];
        
        textField.layer.borderWidth = 1.0f;
        textField.layer.cornerRadius = 3;
        textField.layer.borderColor = [[UIColor colorWithRed:0.278107f green:0.166531f blue:0.463691f alpha:1.0f] CGColor];
        
        
    }
    else if (extensionTextfield.text.length == 0){
        nameTextfield.backgroundColor = [UIColor blackColor];
        
        
        extensionTextfield.layer.borderWidth = 1.0f;
        extensionTextfield.layer.cornerRadius = 3;
        extensionTextfield.layer.borderColor = [[UIColor colorWithRed:0.278107f green:0.166531f blue:0.463691f alpha:1.0f] CGColor];
        
        
    }
    else{
        extensionTextfield.backgroundColor = [UIColor blackColor];
        
        extensionTextfield.layer.borderWidth = 0;
        extensionTextfield.layer.cornerRadius = 3;
        
        addButton.enabled = YES;
    }

    
    [textField resignFirstResponder];
    return NO;
    
}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        textField.layer.borderWidth = 1.0f;
        textField.layer.cornerRadius = 3;
        textField.layer.borderColor = [[UIColor colorWithRed:0.278107f green:0.166531f blue:0.463691f alpha:1.0f] CGColor];
    }
    else if (extensionTextfield.text.length == 0){
        textField.layer.masksToBounds = true;
        textField.layer.borderWidth = 0.0f;
        
         }
    else{
        extensionTextfield.backgroundColor = [UIColor blackColor];
        
        textField.layer.borderWidth = 0.f;
        
        addButton.enabled = YES;
    }
}



- (IBAction)createFile:(id)sender {
    
    NSString *fileName = [self nextFileName:nameTextfield.text withExtension:extensionTextfield.text];
    NSString *fileContent;
    switch (level) {
        case 0:
            fileContent = @"<!DOCTYPE html> \n <head> \n\n <title> \n  \n </title> \n <meta charset=\"utf-8\"> \n </head> \n <body> \n\n\n </body> \n </html>";
            break;
        case 1:
            fileContent = @"/* Normalize.css brings consistency to browsers. \n  https://github.com/necolas/normalize.css */ \n \n @import url(http://cdn.jsdelivr.net/normalize/2.1.3/normalize.min.css); \n \n /* A fresh start */ \n";
            break;
        case 2:
            fileContent = @"// © 2014 - 2015 NAME \n";
            break;
        case 3:
            fileContent = @"";
            break;
        case 4:
            fileContent =  @"<?php \n ?>";
            break;
        case 5:
            fileContent = @"";
            break;
            
        default:
            break;

                }
    
    NSError *error;
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error == nil)  NSLog(@"%@",[error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"history" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fileCreated" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createdProj" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil userInfo:nil];
    }
        
     ];

    
}






- (NSString *)nextFileName:fileName withExtension:(NSString *)extenstion {
    
    if ([items indexOfObject:[fileName stringByAppendingFormat:@".%@", extenstion]] != NSNotFound) {
        
        NSInteger i = 2;
        NSString *newFileName;
        
        while (i < 1024) {
            newFileName = [fileName stringByAppendingFormat:@"(%ld).%@", (long)i, extenstion];
            if([items indexOfObject:newFileName] == NSNotFound) {
                return newFileName;
            }
            i++;
        }
    }
    return [fileName stringByAppendingFormat:@".%@", extenstion];
}










- (IBAction)cancelDidPush:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createdProj" object:nil userInfo:nil];

    }];
}




@end
