//
//  ContributeController.m
//  Codinator
//
//  Created by Vladimir Danila on 10/08/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

@import SafariServices;
@import Crashlytics;

#import "ContributeController.h"


@implementation ContributeController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.donateButton.layer.borderWidth = 2.0f;
    self.donateButton.layer.cornerRadius = 5.0f;
    self.donateButton.layer.borderColor = [self.donateButton.tintColor CGColor];
    
}




- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        NSDate* enteredDate = [df dateFromString:@"12/24/2015"];
        NSDate * today = [NSDate date];
        NSComparisonResult result = [today compare:enteredDate];
        switch (result)
        {
            case NSOrderedAscending:
                NSLog(@"Future Date");
                self.contributeOnGithubButton.enabled = false;
                self.comingSoonLabel.hidden = NO;
                break;
            case NSOrderedDescending:
                NSLog(@"Earlier Date");
                self.contributeOnGithubButton.enabled = true;
                self.comingSoonLabel.hidden = YES;
                break;
            case NSOrderedSame:
                NSLog(@"Today/Null Date Passed"); //Not sure why This is case when null/wrong date is passed
                self.contributeOnGithubButton.enabled = true;
                self.comingSoonLabel.hidden = YES;
                break;
            default: 
                NSLog(@"Error Comparing Dates");
                break;
        }
}





- (IBAction)contributeDidPush:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/VWAS/Codinator"]];
}

- (IBAction)joinUsOnSlack:(id)sender {
    
    [Answers logCustomEventWithName:@"joinUsOnSlack"
                   customAttributes:@{}];
    
    SFSafariViewController *sfController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://vwas-slack.herokuapp.com"]];
    
    [self presentViewController:sfController animated:true completion:nil];
}




# pragma mark - private API

- (void)applyBorder:(UIButton *)button{

    //Add border
    self.donateButton.layer.borderWidth = 2.0f;
    self.donateButton.layer.cornerRadius = 5.0f;
    self.donateButton.layer.borderColor = [self.donateButton.tintColor CGColor];
    
}



@end
