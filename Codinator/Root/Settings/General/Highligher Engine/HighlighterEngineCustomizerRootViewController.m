//
//  HighlighterEngineCustomizerRootViewController.m
//  Codinator
//
//  Created by Vladi Danila on 17/06/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//


#import "HighlighterEngineCustomizerRootViewController.h"
#import "Polaris.h"
#import "FontSettingsViewController.h"
#import "EngineViewController.h"
#import "SettingsEngine.h"



@interface HighlighterEngineCustomizerRootViewController (){
    
    NSInteger selectedType;
    
}

@property (weak, nonatomic) IBOutlet UIButton *closeButton;




@property (weak, nonatomic) IBOutlet UIButton *tagsButton;
@property (weak, nonatomic) IBOutlet UIButton *bracketsButton;
@property (weak, nonatomic) IBOutlet UIButton *attributesButton;
@property (weak, nonatomic) IBOutlet UIButton *stringsButton;

@property (weak, nonatomic) IBOutlet UIButton *customOneButton;
@property (weak, nonatomic) IBOutlet UIButton *customTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *customThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *customFourButton;








@end

@implementation HighlighterEngineCustomizerRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.closeButton.layer.cornerRadius = 5;
    self.closeButton.layer.masksToBounds = YES;

}




- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.tagsButton.tintColor = [defaults colorForKey:@"Color: 3"];
    self.bracketsButton.tintColor = [defaults colorForKey:@"Color: 4"];
    self.attributesButton.tintColor = [defaults colorForKey:@"Color: 5"];
    self.stringsButton.tintColor = [defaults colorForKey:@"Color: 6"];

    self.customOneButton.tintColor = [defaults colorForKey:@"Color: 7"];
    self.customTwoButton.tintColor = [defaults colorForKey:@"Color: 8"];
    self.customThreeButton.tintColor = [defaults colorForKey:@"Color: 9"];
    self.customFourButton.tintColor = [defaults colorForKey:@"Color: 10"];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeDidPush:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}



- (IBAction)restoreDidPush:(id)sender {
    [SettingsEngine restoreSyntaxSettings];
}




#pragma mark - Font

- (IBAction)defaultEditDidPush:(id)sender {
    selectedType = 0;
    [self performSegueWithIdentifier:@"fontEditor" sender:self];
}

- (IBAction)italicEditDidPush:(id)sender {
    selectedType = 1;
    [self performSegueWithIdentifier:@"fontEditor" sender:self];
}

- (IBAction)boldEditDidPush:(id)sender {
    selectedType = 2;
    [self performSegueWithIdentifier:@"fontEditor" sender:self];
}





#pragma mark - Engine Defaults


- (IBAction)tagsEditDidPush:(id)sender {
    selectedType = 3;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}

- (IBAction)bracketsEditDidPush:(id)sender {
    selectedType = 4;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}

- (IBAction)attributesEditDidPush:(id)sender {
    selectedType = 5;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}

- (IBAction)stringsEditDidPush:(id)sender {
    selectedType = 6;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}


#pragma mark - Engine Customs



- (IBAction)customOneDidPush:(id)sender {
    selectedType = 7;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}

- (IBAction)customTwoDidPush:(id)sender {
    selectedType = 8;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}

- (IBAction)customThreeDidPush:(id)sender {
    selectedType = 9;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}

- (IBAction)customFourDidPush:(id)sender {
    selectedType = 10;
    [self performSegueWithIdentifier:@"engineEditor" sender:self];
}






#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"fontEditor"]){

        FontSettingsViewController *destView = segue.destinationViewController;
        destView.selectedType = selectedType;
        
    }
    else if ([segue.identifier isEqualToString:@"engineEditor"]){
        
        //pass nsInteger;
        EngineViewController *destView = segue.destinationViewController;
        destView.selectedType = selectedType;
    }
}


@end
