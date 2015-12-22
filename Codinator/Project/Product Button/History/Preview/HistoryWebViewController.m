//
//  HistoryWebViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 20/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "HistoryWebViewController.h"

@implementation HistoryWebViewController
@synthesize path;

-(void)viewDidLoad{
    [super viewDidLoad];
    

    
    //round interface a bit
    closeButton.layer.cornerRadius = 5;
    closeButton.layer.masksToBounds = YES;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}



- (IBAction)doneDidPush:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
