//
//  WelcomeViewController.h
//  Codinator
//
//  Created by Vladimir on 29/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

@import SafariServices;


@interface WelcomeViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *projectsArray;
@property (strong, nonatomic) NSMutableArray *playgroundsArray;


- (void)indexProjects:(NSArray *)projects;
- (void)restoreUserActivityState:(NSUserActivity *)activity;

@end
