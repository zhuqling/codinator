//
//  EngineViewController.m
//  Codinator
//
//  Created by Vladimir Danila on 19/06/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import "EngineViewController.h"

#import "Polaris.h"
#import "HRColorPickerView.h"


@interface EngineViewController ()


//customize
@property (weak, nonatomic) IBOutlet UISegmentedControl *fontSegment;

//macros
@property (weak, nonatomic) IBOutlet UITextView *macroTextView;

//UI
@property (weak, nonatomic) IBOutlet UIButton *okButtonForPickerView;


@end

@implementation EngineViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self load];

    _macroTextView.layer.cornerRadius = 5;
    _macroTextView.layer.masksToBounds = true;
    
}








#pragma mark - Private API

- (IBAction)changeColorDidPush:(id)sender {
    [self performSegueWithIdentifier:@"colorPicker" sender:self];
  
    
}




- (void)load{
    
    switch (self.selectedType) {
            
        case 3:
            [self title:@"Tags Layer"];
            break;
        case 4:
            [self title:@"Brackets Layer"];
            break;
        case 5:
            [self title:@"Attributes Layer"];
            break;
        case 6:
            [self title:@"Strings Layer"];
            break;
        case 7:
            [self title:@"Custom Layer 1"];
            break;
        case 8:
            [self title:@"Custom Layer 2"];
            break;
        case 9:
            [self title:@"Custom Layer 3"];
            break;
        case 10:
            [self title:@"Custom Layer 4"];
            break;
            
            
            
        default:
            break;
    }
    
    
    
    self.macroTextView.text = [self macro];
    
    

    self.changeColorButton.tintColor = [[NSUserDefaults standardUserDefaults] colorForKey:[NSString stringWithFormat:@"Color: %li", (long)self.selectedType]];
    
}



- (void)title:(NSString *)string{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.navigationItem.title = string;
    }];
}


- (NSString *)macro{
    NSString *key = [NSString stringWithFormat:@"Macro:%li",(long)self.selectedType];
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}


- (void)saveMacro{
    NSString *key = [NSString stringWithFormat:@"Macro:%li",(long)self.selectedType];
    [[NSUserDefaults standardUserDefaults] setObject:self.macroTextView.text forKey:key];
}



- (void)saveAttributes{
    NSString *saveKey = [NSString stringWithFormat:@"Macro:%li Attribute",(long)self.selectedType];
    NSString *fontKey = [NSString stringWithFormat:@"Font: %li",(long)self.fontSegment.selectedSegmentIndex];
    
    NSDictionary *attributes = @{
                                NSForegroundColorAttributeName : self.changeColorButton.tintColor,
                                NSFontAttributeName : [[NSUserDefaults standardUserDefaults] fontForKey:fontKey]
                                };
    
    [[NSUserDefaults standardUserDefaults] setDic:attributes ForKey:saveKey];
}





#pragma mark - Essentials
- (void)viewDidDisappear:(BOOL)animated {
    [self saveMacro];
    [self saveAttributes];
}

- (IBAction)closeDidPush:(id)sender {
    [self saveMacro];
    [self saveAttributes];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
