//
//  PulseViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 14/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "PulseViewController.h"
#import "PulsingHaloLayer.h"

@interface PulseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
@property (weak, nonatomic) IBOutlet UILabel *atvLabel;

@end

@implementation PulseViewController
@synthesize projectManager;


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return UIInterfaceOrientationMaskLandscape;
    }
    else{
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.closeButton.layer.cornerRadius = 5;
    self.closeButton.layer.masksToBounds = true;

    
    NSString * overwork = [[projectManager webServerURL] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    

    
    if (!overwork) {
        self.ipLabel.text = @"Please connect to a Wi-Fi network.";
        self.segmentControll.enabled = false;
        self.atvLabel.hidden = YES;
    }
    else{
        self.ipLabel.text = overwork;
        NSString * overworkATV = [[[projectManager webUploaderServerURL] stringByReplacingOccurrencesOfString:@"http://" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        self.atvLabel.text = [NSString stringWithFormat:@"Codinator Reflector IP: %@",overworkATV];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    layer.position = self.view.center;
    [self.view.layer addSublayer:layer];

    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeDidPush:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}






- (IBAction)segmentDidChanged:(id)sender {
    
    NSString * overwork = [[projectManager webServerURL] stringByReplacingOccurrencesOfString:@"http://" withString:@""];

    if (overwork) {

    switch (self.segmentControll.selectedSegmentIndex) {
    
        case 0:
            self.ipLabel.text = [[projectManager webServerURL] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            break;
        case 1:
            self.ipLabel.text = [[projectManager webDavServerURL] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            break;
        case 2:
            self.ipLabel.text = [[projectManager webUploaderServerURL] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            break;
        default:
            break;
    }
    }
    else{
        self.ipLabel.text = @"Please connect to a Wi-Fi network.";
    }
    
}







@end
