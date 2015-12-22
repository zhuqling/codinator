//
//  NewPlaygroundViewController.m
//  Codinator
//
//  Created by Vladimir on 06/06/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "NewPlaygroundViewController.h"
#import "AppDelegate.h"
#import "Polaris.h"
#import "PlaygroundDocument.h"

@interface NewPlaygroundViewController (){
    UIColor *violett;
    __weak IBOutlet UIButton *nextButton;
}


@property (weak, nonatomic) IBOutlet UITextField *fileName;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@end

@implementation NewPlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    violett = nextButton.backgroundColor;
    nextButton.backgroundColor = [UIColor grayColor];
    nextButton.enabled = NO;

    
    self.fileName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Playground name" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];


    self.fileName.layer.masksToBounds = true;
    self.fileName.layer.borderColor = [violett CGColor];
    self.fileName.layer.borderWidth = 1.0f;
    self.fileName.layer.cornerRadius = 5.0f;

    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.cornerRadius = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
 
    self.fileName.layer.borderWidth = .0f;

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        self.fileName.layer.masksToBounds = true;
        self.fileName.layer.borderColor = [violett CGColor];
        self.fileName.layer.borderWidth = 1.0f;
        self.fileName.layer.cornerRadius = 5.0f;
        
        nextButton.backgroundColor = [UIColor grayColor];
        nextButton.enabled = NO;

    }
    else{
        
        nextButton.enabled = YES;
        nextButton.backgroundColor = violett;
        
    }
    
}


#pragma mark - Generate


- (IBAction)playDidPush:(id)sender {
    
    //Root Path
    NSString *root = [AppDelegate storagePath];
    
    //Paths
    NSString *playgroudPaths = [root stringByAppendingPathComponent:@"Playground"];
    NSURL *fileUrl = [NSURL fileURLWithPath:[playgroudPaths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cnPlay", self.fileName.text]]];
    
    PlaygroundDocument *document = [[PlaygroundDocument alloc] initWithFileURL:fileUrl];
    [document saveToURL:fileUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:nil];
    
    
    
    NSString *html = [NSString stringWithFormat:
@"START \n\
    HEAD() \n\
        TITLE(\"%@\")TITLE \n\
        VIEWPORT(content: \"width=device-width\", initialScale: 1) \n\
        DESCRIPTION(\"A simple webpage written in Neuron\")         \n\
        AUTHOR(\"YOUR NAME\")    \n\
        IMPORT(CSS)   \n\
        IMPORT(JS)    \n\
    ()HEAD \n\
    BODY() \n\
    \n\
    H1(\"%@\")H1 \n\
    P(\"Hello world\")P   \n\
    \n\
    ()BODY \n\
END" ,self.fileName.text,self.fileName.text];
    
    [document.contents addObject:html];
    
    
    
    NSString *css = [NSString stringWithFormat:
                              @"/* Normalize.css brings consistency to browsers. \n\
                                 https://github.com/necolas/normalize.css */ \n\
                              \n\
                              @import url(http://cdn.jsdelivr.net/normalize/2.1.3/normalize.min.css); \n\
                              \n\
                              /* A fresh start */"];
 
    
    [document.contents addObject:css];
    

    
    NSString *js = [NSString stringWithFormat:
@"//JS file \n\
                        "];
    
    [document.contents addObject:js];


    
    
    [document saveToURL:fileUrl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:true completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createdProj" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil userInfo:nil];
                
            }];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to create Playground" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
            
            [alert addAction:closeAlert];
            [self presentViewController:alert animated:YES completion:nil];
            

            
        }
    }];
}


#pragma mark - extra buttons


- (IBAction)playgroundButtondPressed:(id)sender {
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Playground - noun:" message:@"A place where people can play and prototype stuff...." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:closeAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (IBAction)closeDidPush:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
