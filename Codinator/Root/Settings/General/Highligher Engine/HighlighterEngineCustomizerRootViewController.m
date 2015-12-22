//
//  HighlighterEngineCustomizerRootViewController.m
//  Codinator
//
//  Created by Vladi Danila on 17/06/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//


#import "HighlighterEngineCustomizerRootViewController.h"
#import "Polaris.h"

//Font engine
#import "FontSettingsViewController.h"

//General Engine
#import "EngineViewController.h"



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

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]


- (IBAction)restoreDidPush:(id)sender {
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
    
    backgroundOperation.completionBlock = ^{
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        
        //save macros
        
        NSString *tagMacro = @"<.*?(>)";
        NSString *bracketsMacro = @"[\\[\\]]";
        NSString *keywordsMacro = @"(algin|width|height|color|text|border|bgcolor|description|name|content|href|src|charset|class|role|id|<!DOCTYPE html>|border)";
        NSString *stringMacro = @"\".*?(\"|$)";
        
        [userDefaults setObject:tagMacro forKey:@"Macro:3"];
        [userDefaults setObject:bracketsMacro forKey:@"Macro:4"];
        [userDefaults setObject:keywordsMacro forKey:@"Macro:5"];
        [userDefaults setObject:stringMacro forKey:@"Macro:6"];
        
        //save fonts
        
        UIFont *normalFont = [UIFont systemFontOfSize:14];
        UIFont *italicFont = [UIFont italicSystemFontOfSize:14];
        UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
        
        [userDefaults setFont:normalFont forKey:@"Font: 0"];
        [userDefaults setFont:italicFont forKey:@"Font: 1"];
        [userDefaults setFont:boldFont forKey:@"Font: 2"];
        
        
        //Save colors
        
        
        UIColor *tagColor = [UIColor redColor];
        UIColor *bracketsColor = [UIColor orangeColor];
        UIColor *keyworkdsColor = [UIColor grayColor];
        UIColor *stringColor = RGB(3, 128, 30);
        
        
        [userDefaults setColor:tagColor ForKey:@"Color: 3"];
        [userDefaults setColor:bracketsColor ForKey:@"Color: 4"];
        [userDefaults setColor:keyworkdsColor ForKey:@"Color: 5"];
        [userDefaults setColor:stringColor ForKey:@"Color: 6"];
        
        
        
        //Attributs Dictionary
        
        //  NSString *saveKey = [NSString stringWithFormat:@"Maccro:%li Attribute",(long)self.selectedType];
        //  NSString *fontKey = [NSString stringWithFormat:@"Font: %li",(long)self.fontSegment.selectedSegmentIndex];
        
        
        NSDictionary *tagDictionary = @{
                                        NSForegroundColorAttributeName : tagColor,
                                        NSFontAttributeName : normalFont
                                        };
        
        
        
        
        NSDictionary *bracketsDictionary = @{
                                             NSForegroundColorAttributeName : bracketsColor,
                                             NSFontAttributeName : boldFont
                                             };
        
        
        NSDictionary *keywordsDictionary = @{
                                             NSForegroundColorAttributeName : keyworkdsColor,
                                             NSFontAttributeName : boldFont
                                             };
        
        
        NSDictionary *stringDictionary = @{
                                           NSForegroundColorAttributeName : stringColor,
                                           NSFontAttributeName : normalFont
                                           };
        
        
        
        
        [userDefaults setDic:tagDictionary ForKey:@"Macro:3 Attribute"];
        [userDefaults setDic:bracketsDictionary ForKey:@"Macro:4 Attribute"];
        [userDefaults setDic:keywordsDictionary ForKey:@"Macro:5 Attribute"];
        [userDefaults setDic:stringDictionary ForKey:@"Macro:6 Attribute"];
        


        
    };
    
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];

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
