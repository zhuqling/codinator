//
//  HistoryViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 19/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


#import "Polaris.h"

#import "HistoryRow.h"

@interface HistoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFileManagerDelegate>{
    
    
    IBOutlet UITableView *tableView;
    
    NSMutableArray *items;
    
    IBOutlet UIButton *previewButton;
    IBOutlet UIButton *uploadButton;
    IBOutlet UIButton *resetButton;

    __weak IBOutlet UIButton *closeButton;
}


@property (nonatomic, strong) Polaris *projectManager;


@end
