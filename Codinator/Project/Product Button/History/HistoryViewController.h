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
    
    IBOutlet UIBarButtonItem *previewButton;
    IBOutlet UIBarButtonItem *exportButton;
    IBOutlet UIBarButtonItem *restoreButton;

}


@property (nonatomic, strong) Polaris *projectManager;


@end
