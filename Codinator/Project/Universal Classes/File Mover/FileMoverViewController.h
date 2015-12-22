//
//  ExportViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 22.12.14.
//  Copyright (c) 2014 Vladimir Danila. All rights reserved.
//


@interface FileMoverViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *items_;
    
    
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIButton *backButton;
}


@property (nonatomic, strong) NSString *path_;
@property (nonatomic, strong) NSString *rootPath;


@end
