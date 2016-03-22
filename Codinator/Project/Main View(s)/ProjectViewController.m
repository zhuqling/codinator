//
//  ProjectViewControlleriPad.m
//  VWAS-HTML
//
//  Created by Vladimir on 07/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@import QuartzCore;
@import SafariServices;

#import "Polaris.h"

#import "AppDelegate.h"


#import "ProjectViewController.h"
#import "KOKeyboardRow.h"
#import "VWASAccessoryView.h"
#import "CSNotificationView.h"
#import "HistoryViewController.h"
#import "NewFileViewController.h"
#import "NewSubpageViewController.h"
#import "NewDirViewController.h"
#import "ArchiveViewController.h"

#import "CLImageEditor.h"

//Splash screen
#import "CBZSplashView.h"


//Server
#import "PulseViewController.h"


//file mover
#import "FileMoverViewController.h"

#import "ProjectTableViewCell.h"

#import "YALSunnyRefreshControl.h"




@interface ProjectViewController () <CLImageEditorDelegate, CLImageEditorThemeDelegate, CLImageEditorTransitionDelegate>
{
    Polaris *projectManager;
}



@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property UIDocumentInteractionController *documentInteractionController;

@property BOOL dontMoveBack;
@property BOOL turnBack;


// Delegate
@property (strong, nonatomic) AppDelegate *appDelegate;

@property (nonatomic, strong) CBZSplashView *splashView;

@end

@implementation ProjectViewController
BOOL allowSaving;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Create codeView
    
    
    
    /* 
     CHECK FOR SIZE CLASSES AND THAN CALCULATE !!!!!!
     */
    
    
    CGRect textViewFrame;
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact | self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, self.view.frame.size.width - tableView.frame.size.width, self.view.frame.size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
    }
    else{
        textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, self.view.frame.size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, self.view.frame.size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
    }
    
    textview = [[QEDTextView alloc]initWithFrame:textViewFrame];
    textview.backgroundColor = [UIColor blackColor];
    textview.keyboardAppearance = UIKeyboardAppearanceDark;
    textview.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textview.delegate = self;
    textview.tintColor = [UIColor whiteColor];
    [self.view insertSubview:textview belowSubview:self.searchBar];
    textview.hidden = NO;

    textview.layer.drawsAsynchronously = YES;
    

    
    
    //create webview
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    webViewConfiguration.allowsInlineMediaPlayback = YES;
    webViewConfiguration.allowsAirPlayForMediaPlayback = YES;
    webViewConfiguration.requiresUserActionForMediaPlayback = NO;
    webViewConfiguration.applicationNameForUserAgent = @"Codinator";
    
    
    CGRect webViewFrame;
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact | self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, self.view.frame.size.width - tableView.frame.size.width, self.view.frame.size.height - textview.frame.size.height - textview.frame.origin.y);}
    else{
        webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, self.view.frame.size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, self.view.frame.size.height - textview.frame.size.height - textview.frame.origin.y);
    }
    
    
    webPreviewView = [[WKWebView alloc]initWithFrame:webViewFrame configuration:webViewConfiguration];
    webPreviewView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:webPreviewView];
    
    
    //round interface a bit
    closeButton.layer.cornerRadius = 5;

    
    runButton.layer.cornerRadius = 5;
    extrasPanel.layer.cornerRadius = 6;
    navigatorHidePanelView.layer.cornerRadius = 6;
    
    self.searchBar.layer.cornerRadius = 5;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;

    
    //save posiotion & frames
    mainTextViewFrame = textview.frame;
    utilitiesPanelViewFrame = utilitiesPanelView.frame;
    navigatorPanelViewFrame = navigatorPanelView.frame;
    webPreviewViewFrame = webPreviewView.frame;

    

    //interface stuff
    self.searchBar.alpha = .0f;
    
    tableView.backgroundColor = [UIColor colorWithRed:0.09 green:0.098 blue:0.106 alpha:1];
    tableView.separatorColor = [UIColor blackColor];

    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
        //set up Project
    projectManager = [[Polaris alloc] initWithProjectPath:[userDefaults stringForKey:@"ProjectPath"] currentView:self.view WithWebServer:[userDefaults boolForKey:@"CnWebServer"] UploadServer:[userDefaults boolForKey:@"CnUploadServer"] andWebDavServer:[userDefaults boolForKey:@"CnWebDavServer"]];
    items = [projectManager contentsOfDirectoryAtPath:[projectManager projectUserDirectoryPath]];
    
    
    
    //some other stuff
    NSOperation *backgroundOperation2 = [[NSOperation alloc] init];
    backgroundOperation2.queuePriority = NSOperationQueuePriorityVeryLow;
    backgroundOperation2.qualityOfService = NSOperationQualityOfServiceBackground;
    
    
    backgroundOperation2.completionBlock = ^{
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

        [center addObserver:self selector:@selector(loadIndexFile) name:@"history" object:nil];
        [center addObserver:self selector:@selector(copyNotification) name:@"copied" object:nil];
        [center addObserver:self selector:@selector(copyErrorNotification) name:@"copiedError" object:nil];
        [center addObserver:self selector:@selector(fileCreated) name:@"fileCreated" object:nil];
        [center addObserver:self selector:@selector(fileImported) name:@"fileImported" object:nil];
        [center addObserver:self selector:@selector(filesImported) name:@"filesImported" object:nil];
        [center addObserver:self selector:@selector(dirCreated) name:@"dirCreated" object:nil];

        [center addObserver:self selector:@selector(resetCloseBool) name:@"resetCloseBool" object:nil];
        
        [center addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
  
    };
    
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation2];

    
    
    
    UIImage *icon = [UIImage imageNamed:@"RocketForZoom"];
    
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:[UIColor blackColor] frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    splashView.animationDuration = 1.4;
    
    
    [self.view insertSubview:splashView aboveSubview:webPreviewView];
    self.splashView = splashView;
 
    //link to app delegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    
    
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, extrasView.frame.size.height, 0);
    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:tableView
                                                                   target:self
                                                            refreshAction:@selector(sunnyControlDidStartAnimation)];
    

    
    
    
    // Keyboard
    textview.inputAssistantItem.trailingBarButtonGroups = @[];
    textview.inputAssistantItem.leadingBarButtonGroups = @[];
    
    
    //Auto complete
    
    WUTextSuggestionDisplayController *suggestionDisplayController = [[WUTextSuggestionDisplayController alloc] init];
    suggestionDisplayController.dataSource = self;
    WUTextSuggestionController *suggestionController = [[WUTextSuggestionController alloc] initWithTextView:textview suggestionDisplayController:suggestionDisplayController];
    suggestionController.suggestionType = WUTextSuggestionTypeAt;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(range) name:@"range" object:nil];
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];

    //run the initialization
    
    [self utilitiesSetUp];
    [self loadIndexFile];

    
    if (self.turnBack) {
        [self recalcViews];
    }
    else{
        self.turnBack = YES;
    }
    
    
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact | self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact | UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        textview.inputAccessoryView = nil;
        textview.inputAccessoryView = [[VWASAccessoryView alloc] initWithTextView:textview];
    }
    else{
        textview.inputAccessoryView = nil;
        [KOKeyboardRow applyToTextView:textview];
    }
    
    /* wait a beat before animating in */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DISPATCH_TIME_NOW)), dispatch_get_main_queue(), ^{
        [self.splashView startAnimation];
        
        //check for quick start guide
        [self performSelector:@selector(checkIfQuickStartGuideShouldBeDisplayed) withObject:self afterDelay:1.4];
        
    });
    
    self.navigationController.navigationBar.hidden = true;
}



#pragma mark - Keyboard Shortcuts

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (NSArray *)keyCommands {
 
    return @[
    [UIKeyCommand keyCommandWithInput:@"C" modifierFlags:UIKeyModifierCommand action:@selector(copyKeyPressed) discoverabilityTitle:@"Copy"],
    [UIKeyCommand keyCommandWithInput:@"V" modifierFlags:UIKeyModifierCommand action:@selector(pasteKeyPressed) discoverabilityTitle:@"Paste"],
    [UIKeyCommand keyCommandWithInput:@"F" modifierFlags:UIKeyModifierCommand action:@selector(displaySearchBar:) discoverabilityTitle:@"Search"],
    [UIKeyCommand keyCommandWithInput:@"H" modifierFlags:UIKeyModifierCommand action:@selector(hideUtilitiesPreview:) discoverabilityTitle:@"Hide/Show Utilities"],
    [UIKeyCommand keyCommandWithInput:@"D" modifierFlags:UIKeyModifierShift action:@selector(dismissKeyboardForTextEditorCommand) discoverabilityTitle:@"Dismiss Keyboard"],
    [UIKeyCommand keyCommandWithInput:@"N" modifierFlags:UIKeyModifierCommand action:@selector(newFileCommand) discoverabilityTitle:@"New File"],
    [UIKeyCommand keyCommandWithInput:@"D" modifierFlags:UIKeyModifierCommand action:@selector(newDirCommand) discoverabilityTitle:@"New Dir"],
    [UIKeyCommand keyCommandWithInput:@"S" modifierFlags:UIKeyModifierCommand action:@selector(plusDidPush:) discoverabilityTitle:@"New Subpage"],
    [UIKeyCommand keyCommandWithInput:@"R" modifierFlags:UIKeyModifierCommand action:@selector(runDidPush:) discoverabilityTitle:@"Run"]
    ];
}

- (void)dismissKeyboardForTextEditorCommand{
    [textview resignFirstResponder];
}

- (void)newFileCommand{
    [self performSegueWithIdentifier:@"newFile" sender:nil];
}

- (void)newDirCommand{
    [self performSegueWithIdentifier:@"newDir" sender:nil];
}

- (void)newSubpageCommand{
    [self performSegueWithIdentifier:@"newSubpage" sender:nil];
}


- (void)copyKeyPressed{
    NSRange range = [textview selectedRange];
    [[UIPasteboard generalPasteboard] setString:[textview.text substringWithRange:range]];
}

- (void)pasteKeyPressed{
    [textview insertText:[[UIPasteboard generalPasteboard] string]];
}




- (void)resetCloseBool{
}


#pragma mark - (Database) Reloading



- (void)sunnyControlDidStartAnimation{
    
    // start loading something
    items = [projectManager contentsOfCurrentDirectory];
    [tableView reloadData];
    
    [self performSelector:@selector(endAnimationHandle) withObject:nil afterDelay:2.0];
}

- (void)endAnimationHandle{
    
    [self.sunnyRefreshControl endRefreshing];
}




#pragma mark - Splitscreen & View Calculations

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self recalcViews];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [textview resignFirstResponder];
    NSLog(@"%li",(long)self.view.traitCollection.verticalSizeClass);
    
    CGRect textViewFrame;
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
       
        textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, size.width /*- tableView.frame.size.width*/, size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
        
        textview.inputAccessoryView = nil;
        textview.inputAccessoryView = [[VWASAccessoryView alloc] initWithTextView:textview];
    
    }
    else{
        
        

        textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
            

        
        textview.inputAccessoryView = nil;
        [KOKeyboardRow applyToTextView:textview];

    }

    textview.frame = textViewFrame;
    
    
    CGRect webViewFrame;
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, size.width - tableView.frame.size.width, size.height - textview.frame.size.height - textview.frame.origin.y);}
    else{
        webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, size.height - textview.frame.size.height - textview.frame.origin.y);
    }
    
    webPreviewView.frame = webViewFrame;
    
}



- (void)recalcViews{
    
    
    [textview resignFirstResponder];
    NSLog(@"%li",(long)self.view.traitCollection.verticalSizeClass);
    
    CGRect textViewFrame;
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, self.view.frame.size.width - tableView.frame.size.width, self.view.frame.size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
        
        textview.inputAccessoryView = nil;
        textview.inputAccessoryView = [[VWASAccessoryView alloc] initWithTextView:textview];
        
    }
    else{
        
        
        
        textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, self.view.frame.size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, self.view.frame.size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
        
        
        
        textview.inputAccessoryView = nil;
        [KOKeyboardRow applyToTextView:textview];
        
    }
    
    textview.frame = textViewFrame;
    
    
    CGRect webViewFrame;
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact || self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, self.view.frame.size.width - tableView.frame.size.width, self.view.frame.size.height - textview.frame.size.height - textview.frame.origin.y);}
    else{
        webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, self.view.frame.size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, self.view.frame.size.height - textview.frame.size.height - textview.frame.origin.y);
    }
    
    webPreviewView.frame = webViewFrame;
    
}



#pragma mark - qsg 

-(void)checkIfQuickStartGuideShouldBeDisplayed{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"qsgInit"]) {
        [self performSegueWithIdentifier:@"QSG" sender:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"qsgInit"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }

}




#pragma mark - interface & animation

//interface

- (IBAction)hideUtilitiesPreview:(id)sender {
   
    if (!UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
    
        if ((self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClassCompact && self.view.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) | [sender isKindOfClass:[UIButton class]]) {
            
            if ([sender isKindOfClass:[UIButton class]]) {
                self.dontMoveBack = YES;
            }
            
            if (!hiddenUtilities) {
                hiddenUtilities = YES;
                
                
                CGRect frame = utilitiesPanelView.frame;
                frame.origin.x = self.view.frame.size.width;
                
                
                
                CGRect textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, self.view.frame.size.width - tableView.frame.size.width, self.view.frame.size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
                textview.frame = textViewFrame;
                
                CGRect webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, self.view.frame.size.width - tableView.frame.size.width, self.view.frame.size.height - textview.frame.size.height - textview.frame.origin.y);
                
                
                [UIView animateWithDuration:.2 animations:^{
                    
                    utilitiesPanelView.frame = frame;
                    
                    textview.frame = textViewFrame;
                    webPreviewView.frame = webViewFrame;
                    
                }];
            }
            else{
                hiddenUtilities = NO;
                
                if ([sender isKindOfClass:[UIButton class]]) {
                    self.dontMoveBack = YES;
                }
                
                CGRect frame = utilitiesPanelView.frame;
                frame.origin.x = self.view.frame.size.width - utilitiesPanelView.frame.size.width;
                
                
                [UIView animateWithDuration:.2f animations:^{
                    
                    
                    utilitiesPanelView.frame = frame;
                    
                    
                    
                    CGRect textViewFrame = CGRectMake(tableView.frame.size.width, extrasPanel.frame.size.height + extrasPanel.frame.origin.y + 5, self.view.frame.size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, self.view.frame.size.height/2 - extrasPanel.frame.size.height - extrasPanel.frame.origin.y - 3);
                    textview.frame = textViewFrame;
                    
                    
                    
                    CGRect webViewFrame = CGRectMake(tableView.frame.size.width, textview.frame.size.height + textview.frame.origin.y, self.view.frame.size.width - tableView.frame.size.width - utilitiesPanelView.frame.size.width, self.view.frame.size.height - textview.frame.size.height - textview.frame.origin.y);
                    
                    
                    webPreviewView.frame = webViewFrame;
                    
                }];
            }
            
            
        }
        
        
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Not supported" message:@"The Utilities Panel is not available on iPhones yet." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}





#pragma mark - Search (Bar)



- (IBAction)displaySearchBar:(id)sender {
    
    if (self.searchBar.alpha == 1.0f) {
        
        [self hideSeachBar];
    
    }
    else{
    
        [self.view bringSubviewToFront:self.searchBar];
        self.searchBar.hidden = NO;
        
        
        [UIView animateWithDuration:0.3 delay:.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.searchBar.alpha = 1.0f;
            
        } completion:^(BOOL finished) {

            [self.searchBar becomeFirstResponder];
            
        }];
        

    }
    
    
}

- (void)hideSeachBar{
    
    [self.searchBar resignFirstResponder];
    
    
    [UIView animateWithDuration:.3 delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.searchBar.alpha = .0f;
        
    } completion:^(BOOL finished) {
        self.searchBar.hidden = YES;
    }];
    
}


- (void)searchBarTextDidBeginEditing:(nonnull UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}



- (void)searchBarTextDidEndEditing:(nonnull UISearchBar *)searchBar{
   
    searchBar.showsCancelButton = NO;
    
}


- (void)searchBarCancelButtonClicked:(nonnull UISearchBar *)searchBar{
    [self hideSeachBar];
}






- (void)searchBar:(nonnull UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText{
    
}


- (void)searchBarSearchButtonClicked:(nonnull UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self hideSeachBar];
    
    
    NSRange r = [textview.text rangeOfString:searchBar.text options: NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch];
    if (r.location == NSNotFound) {

        [self displayErrorNotificationWithMesssage:@"No occupancy found!"];
        
    }
    else{
        
        searchBar.text = @"";
        
        [textview becomeFirstResponder];
        textview.selectedRange = r;
    
    }
    
    

}












- (BOOL)searchBarShouldBeginEditing:(nonnull UISearchBar *)searchBar{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(nonnull UISearchBar *)searchBar{
    return YES;
}








#pragma mark - Tex View

-(void)loadIndexFile{
    //load file into textview
    [self updateTableView];
    
    NSString *usePHP = [projectManager getSettingsDataForKey:@"UsePHP"];
    
    if ([usePHP isEqualToString:@"YES"]) {
        projectManager.selectedFilePath = [[projectManager projectUserDirectoryPath]  stringByAppendingPathComponent:@"index.php"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:projectManager.selectedFilePath];
        NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        textview.text = fileContents;
        allowSaving = YES;
        
        [self utilitiesSetUp];
    }
    else if([usePHP isEqualToString:@"NO"]){
        projectManager.selectedFilePath = [[projectManager projectUserDirectoryPath] stringByAppendingPathComponent:@"index.html"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:projectManager.selectedFilePath];
        NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        textview.text = fileContents;
        allowSaving = YES;
        
        [self utilitiesSetUp];
        
    }
    else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Project is broken" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                    [projectManager close]; 
                    [self dismissViewControllerAnimated:true completion:nil];
                }];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    //select file in tableview


    
    //fix a bug regarding js debugging
    webPreviewView.hidden = NO;
    
}





- (IBAction)runDidPush:(id)sender {
    
 
    
    if ([[projectManager.selectedFilePath pathExtension] isEqualToString:@"js"]) {
       
        //textview2 resignFirstResponder];
        
        [self executeJS:textview.text];

        
    }
    else{
        projectManager.selectedFilePath = [projectManager.inspectorPath stringByAppendingPathComponent:@"index.html"];
        [[NSUserDefaults standardUserDefaults]setObject:projectManager.selectedFilePath forKey:@"aspectPreviewPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self performSegueWithIdentifier:@"aspectRatioPreview" sender:self];
    }
}







-(void)productRun{
    
    

    NSString *usePHP = [projectManager getSettingsDataForKey:@"UsePHP"];
    
    if ([usePHP isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[projectManager.inspectorPath stringByAppendingPathComponent:@"index.php"] forKey:@"ImagePath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        projectManager.selectedFilePath = [projectManager.inspectorPath stringByAppendingPathComponent:@"index.html"];
        [[NSUserDefaults standardUserDefaults]setObject:projectManager.selectedFilePath forKey:@"aspectPreviewPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"aspectRatioPreview" sender:self];
    }
    else if([usePHP isEqualToString:@"NO"]){
       
        projectManager.selectedFilePath = [projectManager.inspectorPath stringByAppendingPathComponent:@"index.html"];
        [[NSUserDefaults standardUserDefaults]setObject:projectManager.selectedFilePath forKey:@"aspectPreviewPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"aspectRatioPreview" sender:self];    }
    
    
    
    
    
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Project is broken" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];

    }
    

    
}








//extra buttons
- (IBAction)undoDidPush:(id)sender {
    [textview.undoManager undo];
    //[textview2.undoManager undo];
}

- (IBAction)redoDidPush:(id)sender {
    [textview.undoManager redo];
    //[textview2.undoManager redo];
}

- (IBAction)leftDidPush:(id)sender {
    
    NSRange range = textview.selectedRange;
        textview.selectedRange = NSMakeRange(range.location - 1, range.length);
        [[textview undoManager] registerUndoWithTarget:self selector:@selector(rightDidPush:) object:nil];
    
}


- (IBAction)rightDidPush:(id)sender {

    NSRange range = textview.selectedRange;
    textview.selectedRange = NSMakeRange(range.location + 1, range.length);
    [[textview undoManager] registerUndoWithTarget:self selector:@selector(rightDidPush:) object:nil];
    
}


- (IBAction)shareDidPush:(id)sender {

    
    
    // Create an NSURL for the file you want to send to another app
    NSURL *fileURL = [NSURL fileURLWithPath:projectManager.selectedFilePath];
    
     // Create the interaction controller
     self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];

    // Figure out the CGRect of the button that was pressed
    UIButton *button = sender;
    CGRect buttonFrame = button.frame;
    
    // Present the app picker display
    [self.documentInteractionController presentOptionsMenuFromRect:buttonFrame inView:self.view animated:YES];
    
    
    
}



//save

- (void)textViewDidChange:(UITextView *)textView{
    

    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
    
    backgroundOperation.completionBlock = ^{
     
        
        
        NSURL *fileUrl = [NSURL fileURLWithPath:projectManager.selectedFilePath isDirectory:NO];
        NSURL *rootUrl = [NSURL fileURLWithPath:[projectManager.selectedFilePath stringByDeletingLastPathComponent] isDirectory:YES];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [webPreviewView loadFileURL:fileUrl allowingReadAccessToURL:rootUrl];
        });
        
        
        
        
        if (allowSaving) {
            NSError *error;
            [textView.text writeToFile:projectManager.selectedFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        }
    
    
    
    };
    
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    
    
    [projectManager generateATVPreview];

    
}



- (void)keyboardDidChange:(NSNotification *)notification{
    
    
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFame fromView:nil];
    
    

    
    CGFloat inset = self.view.frame.size.height - (textview.frame.size.height + 45 + keyboardFrame.size.height);
    
    
    if (inset <= 0) {
        textview.contentInset = UIEdgeInsetsMake(0, 0, fabs(inset), 0);
        textview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, inset, 0);
    }
    
}


- (void)keyboardDidHide:(NSNotification *)notification{
    
    textview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
}





#pragma mark - js stuff


- (void)executeJS:(NSString *)code {

    [self displayNeutralNotificationWithMessage:@"We're sorry, the JS-Debugger, is still in development"];
    
}



#pragma mark - navigation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!self.appDelegate.thumbnailManager) {
        self.appDelegate.thumbnailManager = [[Thumbnail alloc] init];
    }
    
    static NSString *CellIdentifier = @"cell";
    
    ProjectTableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];

    
    
    NSString *textL = [items[indexPath.row] lastPathComponent];
    cell.fileNameLabel.text = textL;
    
    NSString *path = [projectManager.inspectorPath stringByAppendingPathComponent:textL];
    
    cell.backgroundColor = tableView2.backgroundColor;
    cell.thumbnailImageView.opaque = YES;
    cell.thumbnailImageView.image = [self.appDelegate.thumbnailManager thumbnailForFileAtPath:path];
    
    

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewCellWasLongPressed:)];
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;


}

-(void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    allowSaving = NO;
    projectManager.selectedFilePath = [projectManager.inspectorPath stringByAppendingPathComponent:[items[indexPath.row] lastPathComponent]];
    
    
    
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:projectManager.selectedFilePath isDirectory:&isDir];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:projectManager.selectedFilePath isDirectory:&isDir] && isDir){
        
      //  NSString *placeholder = [selectedFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",]];
        projectManager.inspectorPath = projectManager.selectedFilePath;
        

        [self updateTableView];
        [self fixTheSandboxingBug];
    }
    else if ([[projectManager.selectedFilePath pathExtension] isEqualToString:@"png"] || [[projectManager.selectedFilePath pathExtension] isEqualToString:@"img"] || [[projectManager.selectedFilePath pathExtension] isEqualToString:@"jpg"] || [[projectManager.selectedFilePath pathExtension] isEqualToString:@"jpeg"]) {
        
        
        UIImage *image = [UIImage imageWithContentsOfFile:projectManager.selectedFilePath];
        projectManager.tmpFilePath = projectManager.selectedFilePath;
        
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
        editor.delegate = self;
        
        [self presentViewController:editor animated:YES completion:nil];
        
        
    }
    else if ([[projectManager.selectedFilePath pathExtension] containsString:@"zip"]){
        
        
        [[NSUserDefaults standardUserDefaults ] setObject:projectManager.selectedFilePath forKey:@"ImagePath"];
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"UnZip" bundle:nil];
        
        UINavigationController* navController = [secondStoryboard instantiateViewControllerWithIdentifier:@"unzip"];
        navController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [self presentViewController:navController animated:YES completion:nil];
        
    }
    else if ([[projectManager.selectedFilePath pathExtension] containsString:@"pdf"]){

    
        [[NSUserDefaults standardUserDefaults] setObject:projectManager.deletePath forKey:@"aspectPreviewPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        projectManager.selectedFilePath = [projectManager.inspectorPath stringByAppendingPathComponent:@"index.html"];
        [[NSUserDefaults standardUserDefaults]setObject:projectManager.selectedFilePath forKey:@"aspectPreviewPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"aspectRatioPreview" sender:self];
    
    }
    
    
    else{
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:projectManager.selectedFilePath];
        NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        textview.text = fileContents;
        allowSaving = YES;
        
        [self utilitiesSetUp];
        textview.hidden = NO;
        
        webPreviewView.hidden = NO;

    }

}



- (IBAction)tableViewCellWasLongPressed:(UILongPressGestureRecognizer *)sender {

        CGPoint p = [sender locationInView:tableView];
        CGRect position;
        position.origin.x = p.x;
        position.origin.y = p.y;
        position.size.height  = 0;
        position.size.width = 20;
        
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        if (sender.state == UIGestureRecognizerStateBegan && indexPath) {
            
                
                projectManager.deletePath = [projectManager.inspectorPath stringByAppendingPathComponent:[items[indexPath.row] lastPathComponent]];
                
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete ❌" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __nonnull action) {
                    
                    
                    
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:projectManager.deletePath];
                    NSError *error;
                    
                    if (fileExists) {
                        [[NSFileManager defaultManager]removeItemAtPath:projectManager.deletePath error:&error];
                    }
                    else{
                        [self displayErrorNotificationWithMesssage:@"There was an unexpected errror"];
                    }
                    
                    
                    if (error) {
                        NSString *message = [NSString stringWithFormat:@"There was an error deleting this file: %@",[error localizedDescription]];
                        [self displayErrorNotificationWithMesssage:message];
                        
                        
                    }
                    else{
                        [self displaySuccesNotificationWithMesssage:@"File was deleted"];
                        [self updateTableView];
                        
                    }
                    
                    
                    
                }];
                
                
                
                UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"Preview 🎬" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
                    
                    [[NSUserDefaults standardUserDefaults]setObject:projectManager.deletePath forKey:@"aspectPreviewPath"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSegueWithIdentifier:@"aspectRatioPreview" sender:self];
                    
                    
                }];
                
                
                UIAlertAction *printAction = [UIAlertAction actionWithTitle:@"Print 📠" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
                    
                    
                    //PRINT
                    UIPrintInfo *pi = [UIPrintInfo printInfo];
                    pi.outputType = UIPrintInfoOutputGeneral;
                    pi.jobName = @"Print File";
                    pi.orientation = UIPrintInfoOrientationPortrait;
                    pi.duplex = UIPrintInfoDuplexLongEdge;
                    
                    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
                    pic.printInfo = pi;
                    pic.showsPageRange = YES;
                    
                    
                    
                    if (![projectManager.deletePath.pathExtension isEqualToString:@"pdf"] && ![projectManager.deletePath.pathExtension isEqualToString:@"png"] && ![projectManager.deletePath.pathExtension isEqualToString:@"pdf"] && ![projectManager.deletePath.pathExtension isEqualToString:@"jpeg"]) {
                        
                        
                        UITextView *printTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                        printTextView.text = [NSString stringWithContentsOfFile:projectManager.deletePath encoding:NSUTF8StringEncoding error:nil];
                        pic.printFormatter = printTextView.viewPrintFormatter;
                        printTextView = nil;
                    }
                    else if ([projectManager.deletePath.pathExtension isEqualToString:@"png"] || [projectManager.deletePath.pathExtension isEqualToString:@"jpg"] || [projectManager.deletePath.pathExtension isEqualToString:@"jpeg"]){
                        UIImage *image = [UIImage imageWithContentsOfFile:projectManager.deletePath];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        
                        
                        pic.printFormatter = imageView.viewPrintFormatter;
                    }
                    else{
                        
                        // Show error
                        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Not supported File" message:@"This file format is not supported yet." preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                        [errorAlert addAction:cancel];
                        
                        [self presentViewController:errorAlert animated:YES completion:nil];
                        
                    }
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [pic presentAnimated:YES completionHandler:nil];
                    }];
                    
                }];
                
                
                
                
                UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"Move file 🚊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
                    
                    
                    //move file
                    [self performSegueWithIdentifier:@"moveFile" sender:self];
                    
                }];
                
            
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
                
                UIAlertController *popup = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                popup.view.tintColor = [UIColor blackColor];
            
            
                [popup addAction:previewAction];
                [popup addAction:printAction];
            
                // Add the renaming function
                if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact | self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            
                    UIAlertAction *rename = [UIAlertAction actionWithTitle:@"Rename 🎩" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        // Check if file isn't index.html
                        if ([[NSString stringWithFormat:@"%@",projectManager.deletePath.lastPathComponent.stringByDeletingPathExtension] isEqualToString:@"index"]) {
                            [self displayErrorNotificationWithMesssage:@"Index file can not be renamed"];
                        }
                        else{
                            
                            // Display renaming dialogue
                            
                            NSString *message = [NSString stringWithFormat:@"Rename \"%@\"", projectManager.deletePath.lastPathComponent];
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename" message:message preferredStyle:UIAlertControllerStyleAlert];
                            alert.view.tintColor = [UIColor blackColor];
                            
                            
                            [alert addTextFieldWithConfigurationHandler:^(UITextField * __nonnull textField) {
                                textField.placeholder = projectManager.deletePath.lastPathComponent;
                                textField.keyboardAppearance = UIKeyboardAppearanceDark;
                                textField.tintColor = [UIColor purpleColor];
                            }];
                            
                            UIAlertAction *processAction = [UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
                                
                                
                                NSString *newName = alert.textFields[0].text;
                                NSString *newPath = [[projectManager.deletePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
                                
                                NSLog(@"%@",newName);
                                
                                
                                NSError *error;
                                
                                
                                NSOperation *backgroundOperation = [[NSOperation alloc] init];
                                backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
                                backgroundOperation.qualityOfService = NSOperationQualityOfServiceUserInitiated;
                                
                                backgroundOperation.completionBlock = ^{
                                    [[NSFileManager defaultManager] moveItemAtPath:projectManager.deletePath toPath:newPath error:nil];
                                };
                                
                                
                                [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
                                
                                
                                
                                if (error) {
                                    [self displayErrorNotificationWithMesssage:[error localizedDescription]];
                                }
                                else{
                                    [self displaySuccesNotificationWithMesssage:@"File was renamed"];
                                    [self loadIndexFile];
                                }

                                
                                
                            }];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                            
                            [alert addAction:processAction];
                            [alert addAction:cancelAction];
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self presentViewController:alert animated:YES completion:nil];
                            }];
  
                            
                        }
                        
                    }];
                    
                    [popup addAction:rename];
                }            
            
            
                [popup addAction:moveAction];
                [popup addAction:deleteAction];
            
            


            
            
                [popup addAction:cancel];
            
                popup.popoverPresentationController.sourceView = tableView;
                popup.popoverPresentationController.sourceRect = position;
            
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                [self presentViewController:popup animated:YES completion:nil];
                }];
            
            }
    

}



-(void)fixTheSandboxingBug{
    NSString *assets = [projectManager.inspectorPath lastPathComponent];
    if ([assets isEqualToString:@"Assets"]) {
        backButton.enabled = NO;
    }
    else{
        backButton.enabled = YES;
    }
}




- (IBAction)navigateBackDidPush:(id)sender {
    NSString *coverInspectorPath = [projectManager.inspectorPath stringByDeletingLastPathComponent];
    projectManager.inspectorPath = coverInspectorPath;
    
    items = [projectManager contentsOfCurrentDirectory];
    [tableView reloadData];
    
    backButton.selected = YES;
    
    
    [self fixTheSandboxingBug];
    [self performSelector:@selector(navigateBackDidPushReverseSelected) withObject:self afterDelay:.1f];
}

- (void)navigateBackDidPushReverseSelected {
    backButton.selected = NO;
}


- (IBAction)navigateBackSwiped:(id)sender {
    if (backButton.enabled) {
        [self navigateBackDidPush:nil];
        [self performSelector:@selector(navigateBackDidPushReverseSelected) withObject:self afterDelay:.1f];

    }
    else{
        [self displayNeutralNotificationWithMessage:@"You're already in root"];
    }
}




- (IBAction)plusDidPush:(id)sender {

        //actions
    UIAlertAction *newFile = [UIAlertAction actionWithTitle:@"New File ✏️" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self performSegueWithIdentifier:@"newFile" sender:nil];
    }];
    
    UIAlertAction *newSubpage = [UIAlertAction actionWithTitle:@"New Subpage📝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self performSegueWithIdentifier:@"newSubpage" sender:nil];
    }];
    
    UIAlertAction *newDir = [UIAlertAction actionWithTitle:@"New Dir 📂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self performSegueWithIdentifier:@"newDir" sender:nil];
    }];
    
    UIAlertAction *import = [UIAlertAction actionWithTitle:@"Import 🚚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:projectManager.inspectorPath forKey:@"inspectorPath"];
        [[NSUserDefaults standardUserDefaults]setObject:projectManager.webUploaderServerURL forKey:@"webUploaderServerURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        if (![[[NSUserDefaults standardUserDefaults]stringForKey:@"inspectorPath"] isEqualToString:projectManager.inspectorPath]){
            [[NSUserDefaults standardUserDefaults]setObject:projectManager.inspectorPath forKey:@"inspectorPath"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [self performSegueWithIdentifier:@"import" sender:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    //create alert view
    UIAlertController *popup = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [popup addAction:newFile];
    [popup addAction:newSubpage];
    [popup addAction:newDir];
    [popup addAction:import];
    [popup addAction:cancel];
    popup.view.tintColor = [UIColor blackColor];
    
    popup.popoverPresentationController.sourceView = extrasView;
    popup.popoverPresentationController.sourceRect = [(UIButton *)sender frame];
    
    //display alert view
    [self presentViewController:popup animated:YES completion:nil];
    
}


- (IBAction)productDidPush:(id)sender {

    
        //actions
    UIAlertAction *run = [UIAlertAction actionWithTitle:@"Run 🚀" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self productRun];
    }];
    
    UIAlertAction *archive = [UIAlertAction actionWithTitle:@"Archive 📦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self performSegueWithIdentifier:@"archive" sender:nil];
    }];
    
    UIAlertAction *history = [UIAlertAction actionWithTitle:@"History 🚧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self performSegueWithIdentifier:@"history" sender:nil];
    }];
    
    
    UIAlertAction *export = [UIAlertAction actionWithTitle:@"Export ✈️" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self alertWithMessage:@"Archive the Project first.\nAfterwards open up the History window and use the export manager." title:@"✈️"];
    }];
    
    UIAlertAction *localServer = [UIAlertAction actionWithTitle:@"Local Server 💻" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self performSegueWithIdentifier:@"Pulse" sender:self];
    }];
    
    UIAlertAction *devForum = [UIAlertAction actionWithTitle:@"Dev Forum 📖" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:@"http://vwas.cf/solvinator/"];
        SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:url];
        webVC.view.tintColor = [UIColor purpleColor];
        
        [self presentViewController:webVC animated:YES completion:nil];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    //create alert view
    UIAlertController *popup = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [popup addAction:run];
    [popup addAction:archive];
    [popup addAction:history];
    [popup addAction:export];
    [popup addAction:localServer];
    [popup addAction:devForum];
    [popup addAction:cancel];
    
    popup.view.tintColor = [UIColor blackColor];
    
    popup.popoverPresentationController.sourceView = extrasView;
    popup.popoverPresentationController.sourceRect = [(UIButton *)sender frame];
    
    //display alert view
    [self presentViewController:popup animated:YES completion:nil];
    
}






-(void)alertWithMessage:(NSString*)message title:(NSString*)title{
    
    //Create alert snippet
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - Photonator


- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{

    NSData *binaryImageData = UIImagePNGRepresentation(image);
    [binaryImageData writeToFile:projectManager.tmpFilePath atomically:YES];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - utilities


-(void)utilitiesSetUp{
    
    
    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityHigh;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceUserInitiated;
    
    backgroundOperation.completionBlock = ^{
        
        NSString* filePathFakeString = [projectManager fakePathForFileSelectedFile];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            filePathLabel.text = filePathFakeString;
        });
    
        NSString *name = [projectManager.selectedFilePath lastPathComponent];
        NSString *fileName = [name stringByDeletingPathExtension];
        NSString *fileExtension = [name pathExtension];
    

        dispatch_sync(dispatch_get_main_queue(), ^{
            fileNameTextview.text = fileName;
            typeTextview.text = fileExtension;
            
            [fileNameTextview resignFirstResponder];
            [typeTextview resignFirstResponder];
            
            versionLabel.text = [projectManager projectCurrentVersion];
        });
    
        //File attributes
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:projectManager.selectedFilePath error:nil];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            fileSizeLabel.text = [NSString stringWithFormat:@"Size:  %@ bytes", attributes[NSFileSize]];
        });
        
    
        [dateFormatter setDateFormat:@"MM dd Y"];
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            createdDateLabel.text = [NSString stringWithFormat:@"Created:  %@", [dateFormatter stringFromDate:attributes[NSFileCreationDate]]];
        });
        
        [dateFormatter setDateFormat:@"MM:dd:Y HH:mm"];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            modifiedLabel.text = [NSString stringWithFormat:@"Modified:  %@", [dateFormatter stringFromDate:attributes[NSFileModificationDate]]];
        });
        
    };
    
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    
    
}



- (IBAction)copyDidPush:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = filePathLabel.text;
    
    
    [self displayNeutralNotificationWithMessage:@"Path copied to clipboard"];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([[NSString stringWithFormat:@"%@",fileNameTextview.text] isEqualToString:@"index"]) {
        [self displayErrorNotificationWithMesssage:@"Index file can not be renamed"];
        [textField resignFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (![[NSString stringWithFormat:@"%@",fileNameTextview.text] isEqualToString:@"index"]) {

        NSError *error;
        NSString *dstPath = [[projectManager.selectedFilePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileNameTextview.text,typeTextview.text]];
        [[NSFileManager defaultManager] moveItemAtPath:projectManager.selectedFilePath toPath:dstPath error:&error];
    
        if (error) {
            [self displayErrorNotificationWithMesssage:[error localizedDescription]];
        }
        else{
            [self displaySuccesNotificationWithMesssage:@"File was renamed"];
            [self loadIndexFile];
        }
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    return NO;
    
}





    //code snippets;
    
- (IBAction)segmentWasChanged:(id)sender {
    
    switch (utitlitesSegment.selectedSegmentIndex) {
        case 0:
            [snippetsPanel setHidden:NO];
            [colorPickerPanel setHidden:YES];
            break;
        case 1:
            [snippetsPanel setHidden:YES];
            [colorPickerPanel setHidden:NO];
            break;
        default:
            break;
    }
}


-(void)copyNotification{
    [self displayNeutralNotificationWithMessage:@"Snippet was coppied to clippboard. Paste it into the desired place now."];
}

-(void)copyErrorNotification{
    [self displayErrorNotificationWithMesssage:@"You've to fill in the gaps."];
}



#pragma mark - WUTextSuggestionDisplayControllerDataSource

- (NSArray *)textSuggestionDisplayController:(WUTextSuggestionDisplayController *)textSuggestionDisplayController suggestionDisplayItemsForSuggestionType:(WUTextSuggestionType)suggestionType query:(NSString *)suggestionQuery
{
    if (suggestionType == WUTextSuggestionTypeAt) {
        NSMutableArray *suggestionDisplayItems = [NSMutableArray array];
        for (NSString *name in [self filteredNamesUsingQuery:suggestionQuery]) {
            WUTextSuggestionDisplayItem *item = [[WUTextSuggestionDisplayItem alloc] initWithTitle:name];
            [suggestionDisplayItems addObject:item];
        }
        return [suggestionDisplayItems copy];
    }
    
    return nil;
}


//tags

- (NSArray *)filteredNamesUsingQuery:(NSString *)query {
    NSArray *filteredNames = [self.names filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[evaluatedObject lowercaseString] hasPrefix:[query lowercaseString]]) {
            return YES;
        } else {
            return NO;
        }
    }]];
    return filteredNames;
}

- (NSArray *)names {
    return @[@"h1>",@"/h1>",@"h2>",@"/h2>",@"h3>",@"/h3>",@"h4>",@"h5>",@"h6>",@"head>",@"body>",@"/body>",@"!Doctype html>",@"center>",@"img src=",@"a href=",@"font ",@"meta",@"table border=",@"tr>",@"td>",@"div>",@"div class=",@"style>",@"title>",@"li>",@"em>",@"p>",@"li>",@"section class=",@"header>",@"footer>",@"ul>",@"del>",@"em>",@"sub>",@"sup>",@"var>",@"cite>",@"dfn>",@"big>",@"small>",@"strong>",@"code>",@"frameset",@"blackquote>",@"br>"];
}





-(void)range{
    
    
    
    NSString *R = [[NSUserDefaults standardUserDefaults] stringForKey:@"range"];
    
    
    [[textview undoManager] undo];
    [textview insertText:R];
   
   // [[textview2 undoManager] undo];
   // [textview2 insertText:R];
    
    
    
    NSString *br = [NSString stringWithFormat:@"</%@",R];
    

     if ([R isEqualToString:@"h1>"] || [R isEqualToString:@"h2>"] || [R isEqualToString:@"h3>"] || [R isEqualToString:@"h4>"] || [R isEqualToString:@"h5>"] || [R isEqualToString:@"h6>"] || [R isEqualToString:@"head>"] || [R isEqualToString:@"body>"] || [R isEqualToString:@"!Doctype html>"] || [R isEqualToString:@"center>"] || [R isEqualToString:@"tr>"] || [R isEqualToString:@"td>"] || [R isEqualToString:@"div>"] || [R isEqualToString:@"style>"] || [R isEqualToString:@"title>"] || [R isEqualToString:@"li>"] || [R isEqualToString:@"section>"] || [R isEqualToString:@"header>"] || [R isEqualToString:@"footer>"] || [R isEqualToString:@"ul>"] || [R isEqualToString:@"del>"] || [R isEqualToString:@"em>"] || [R isEqualToString:@"sub>"] || [R isEqualToString:@"sup>"] || [R isEqualToString:@"var>"] || [R isEqualToString:@"cite>"] || [R isEqualToString:@"dfn>"] || [R isEqualToString:@"big>"] || [R isEqualToString:@"small>"] || [R isEqualToString:@"strong>"] || [R isEqualToString:@"code>"] || [R isEqualToString:@"blackquote>"] || [R isEqualToString:@"p>"] || [R isEqualToString:@"del>"]) {
        [textview insertText:br];
        [self moveCursor:[br length]];
       // [textview2 insertText:br];
    }
     else{
         [textview deleteBackward];
         [textview insertText:br];
   //      [textview2 deleteBackward];
   //      [textview2 insertText:br];
         [self moveCursor:[br length]];
         
     }
    
    
    
    
    
}



-(void)moveCursor:(NSUInteger)number{
    
    if (!number == 0) {
        
        [self leftDidPush:nil];
        [self moveCursor:number-1];
    }
    
    
}











#pragma mark - basic stuff like close window // Open full screen oreview etc. // Project Setting up....

-(void)displaySuccesNotificationWithMesssage:(NSString*)message{
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleSuccess
                                     message:message];
}

-(void)displayErrorNotificationWithMesssage:(NSString*)message{
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleError
                                     message:message];
}

-(void)displayNeutralNotificationWithMessage:(NSString*)message{
    [CSNotificationView showInViewController:self tintColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentCenter image:nil message:message duration:3.0];
}

-(void)updateTableView{
    items = [projectManager contentsOfCurrentDirectory];
    [tableView reloadData];
    
}

-(void)setUpFTP{
    [self performSegueWithIdentifier:@"missing" sender:nil];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    hiddenUtilities = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self hideUtilitiesPreview:nil];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    hiddenUtilities = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self hideUtilitiesPreview:nil];
    }
}



-(void)fileCreated{
    [self displayNeutralNotificationWithMessage:@"✏️ was created"];
}
-(void)fileImported{
    [self displayNeutralNotificationWithMessage:@"File was 🚚"];
}
-(void)filesImported{
    [self displayNeutralNotificationWithMessage:@"Files are 🚚 now"];
}
-(void)dirCreated{
    [self displayNeutralNotificationWithMessage:@"📂 was created"];
}
-(void)subpageCreated{
    [self displayNeutralNotificationWithMessage:@"📝 was created"];
}

#pragma mark - storyboard segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"history"]) {
        HistoryViewController *destViewController = segue.destinationViewController;
        destViewController.projectManager = projectManager;
    }
    if ([segue.identifier isEqualToString:@"archive"]) {
        ArchiveViewController *destViewController = segue.destinationViewController;
        destViewController.projectManager = projectManager;
    }
    else if ([segue.identifier isEqualToString:@"newFile"]){
        NewFileViewController *destViewController = segue.destinationViewController;
        destViewController.items = items;
        destViewController.path = projectManager.inspectorPath;
    }
    else if ([segue.identifier isEqualToString:@"newSubpage"]){
        NewSubpageViewController *destViewController = segue.destinationViewController;
        destViewController.projectManager = projectManager;
    }
    else if ([segue.identifier isEqualToString:@"newDir"]){
        NewDirViewController *destViewController = segue.destinationViewController;
        destViewController.projectManager = projectManager;
    }
    else if ([segue.identifier isEqualToString:@"Pulse"]){
        PulseViewController *destViewController = segue.destinationViewController;
        destViewController.projectManager = projectManager;

    }
    else if ([segue.identifier isEqualToString:@"moveFile"]){
        FileMoverViewController *fileMover = segue.destinationViewController;
        fileMover.path_ = projectManager.deletePath;
        fileMover.rootPath = [projectManager projectUserDirectoryPath];
    }
}








- (IBAction)closeDidPush:(id)sender {
    [projectManager close];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = false;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
