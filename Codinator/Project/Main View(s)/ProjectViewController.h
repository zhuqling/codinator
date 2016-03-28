//
//  ProjectViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 07/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@import WebKit;

#import "WUTextSuggestionDisplayController.h"
#import "JsTextView.h"
#import "HRColorPickerView.h"

@interface ProjectViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,WUTextSuggestionDisplayControllerDataSource,UITextFieldDelegate,UIPopoverControllerDelegate,UISearchBarDelegate, UITraitEnvironment>{
    

    
    //interface
    CGRect mainTextViewFrame;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *runButton;
    
    IBOutlet UITableView *tableView;
    
    IBOutlet UIView *navigatorHidePanelView;
    IBOutlet UIView *extrasPanel;
    
    IBOutlet UIView *utilitiesPanelView;        CGRect utilitiesPanelViewFrame;
    IBOutlet UIView *navigatorPanelView;        CGRect navigatorPanelViewFrame;
    WKWebView *webPreviewView;         CGRect webPreviewViewFrame;
    
    UITextView *textview;
    //JsTextView *textview2;
    
    
    IBOutlet UITextField *fileNameTextview;
    IBOutlet UITextField *typeTextview;
    
    IBOutlet UILabel *filePathLabel;
    
    
    
    IBOutlet UIView *extrasView;
    
    
    
    
    //checking variables
    BOOL assistandEnabled;
    BOOL hiddenUtilities;
    BOOL hiddenPreview;
    BOOL hiddenNavigator;
    

    
    //table view
    NSMutableArray *items;
    
    
    IBOutlet UILabel *versionLabel;
    IBOutlet UIButton *backButton;
    
    
    IBOutlet UILabel *fileSizeLabel;
    IBOutlet UILabel *createdDateLabel;
    IBOutlet UILabel *modifiedLabel;
    
    
    //utilitties segment;
    __weak IBOutlet UISegmentedControl *utitlitesSegment;
    __weak IBOutlet UIView *snippetsPanel;
    __weak IBOutlet UIView *colorPickerPanel;
    
    
    
}


-(void)displaySuccesNotificationWithMesssage:(NSString*)message;


@end
