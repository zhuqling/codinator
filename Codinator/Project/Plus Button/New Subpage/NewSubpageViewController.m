//
//  NewSubpageViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 21/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "NewSubpageViewController.h"

@implementation NewSubpageViewController{
}
@synthesize projectManager;



-(void)viewDidLoad{
    [super viewDidLoad];
  
    nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Subpage name..." attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];


    
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}




- (IBAction)createDidPush:(id)sender {
    
    NSError *error;
    
    NSString *dirPath = [projectManager.inspectorPath stringByAppendingPathComponent:nameTextField.text];
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];

    
    
    NSString *indexFile = @"index.html";
    NSString *indexBody;
    

    
    
    

        
    
            
            
        indexBody = [NSString stringWithFormat:@"<!DOCTYPE html> \n\
<html> \n\
        <head> \n\
            <title>%@</title> \n\
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n\
            %@\n\
        </head> \n\
        <body> \n\
        \n\
            <h1>%@</h1> \n\
            <p>Hello world</p>		\n\
            \n\
        </body> \n\
</html>",nameTextField.text,@"<link href=\"../style.css\" rel=\"stylesheet\" type=\"text/css\"> \n\
         <script src=\"../script.js\"></script>",nameTextField.text];

                
    
            

    
    
        NSError *newError;
        NSString *indexPath = [dirPath stringByAppendingPathComponent:indexFile];
        [indexBody writeToFile:indexPath atomically:YES encoding:NSUTF8StringEncoding error:&newError];




    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"history" object:self userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (IBAction)cancelDidPush:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetCloseBool" object:self userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
