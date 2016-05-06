//
//  WelcomeViewController.h
//  Codinator
//
//  Created by Vladimir on 29/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

@import SafariServices;
#import "CodinatorDocument.h"


@interface WelcomeViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *projectsArray;
@property (strong, nonatomic) NSMutableArray *playgroundsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSString *forceTouchPath;
@property (nonatomic) CodinatorDocument *document;

@property (nonatomic) BOOL projectIsOpened;
@property (nonatomic) NSString *projectsPath;


- (void)indexProjects:(NSArray *)projects;
- (void)restoreUserActivityState:(NSUserActivity *)activity;
- (void)reloadData;
@end
