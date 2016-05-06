//
//  WelcomeViewController.m
//  Codinator
//
//  Created by Vladimir on 29/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@import CoreSpotlight;
@import MobileCoreServices;

#import "AppDelegate.h"

#import "WelcomeViewController.h"
#import "SettingsEngine.h"

#import "ProjectCollectionViewCell.h"



///ZipImport
#import "ProjectZipImporterViewController.h"

///NSUserDefaults additions
#import "NSUserDefaults+Additions.h"

#import "Codinator-Swift.h"


@interface WelcomeViewController ()


//delegate
@property (strong, nonatomic) AppDelegate *appDelegate;

//UI
@property (weak, nonatomic) IBOutlet UIVisualEffectView *plusButtonSuperView;


//navigation
@property (strong, nonatomic) NSString *tmpPath;
@property (nonatomic) BOOL useTmpPath;


//Holding Objects
@property (strong, nonatomic) UIImage *rocketBlueprintImage;
@property (strong, nonatomic) NSMutableArray *oldProjectsArray;
@property (strong, nonatomic) NSMutableArray *oldPlaygroundsArray;
@property (weak, nonatomic) NSString *zipPath;


//documents
@property (nonatomic, nonnull) NSMetadataQuery *query;

@property (nonatomic) NSString *playgroundsPath;

@end

@implementation WelcomeViewController
@synthesize projectsArray, playgroundsArray;
@synthesize document;
@synthesize projectIsOpened;
@synthesize query = _query;




- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIEdgeInsets insets;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        insets = UIEdgeInsetsMake(10, 0, 0, 0);
        
        UIEdgeInsets scrollInsets = insets;
        scrollInsets.top = 0;
        
        self.collectionView.scrollIndicatorInsets = scrollInsets;
    }
    
    self.collectionView.contentInset = insets;
    

    

    //link to app delegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidReceiveNotification:) name:NSMetadataQueryDidUpdateNotification object:self.query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload" object:nil];
    
    [self performSelectorInBackground:@selector(setUp) withObject:nil];
    
    
    if ([self.traitCollection
         respondsToSelector:@selector(forceTouchCapability)] &&
        (self.traitCollection.forceTouchCapability ==
         UIForceTouchCapabilityAvailable))
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
    }


    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:true];
    
    //Root Path
    
    
    // delete old indexed files
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:nil];
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        
        if (document) {
            if (projectIsOpened) {
                [document closeWithCompletionHandler:^(BOOL success) {
                    if (success) {
                        projectIsOpened = NO;
                    }
                    else{
                        projectIsOpened = YES;
                    }
                }];
            }
        }
        
        
        NSString *rootPath = [AppDelegate storagePath];
        NSString *projectsDirPath = [rootPath stringByAppendingPathComponent:@"Projects"];
        NSString *playgroundsDirPath = [rootPath stringByAppendingPathComponent:@"Playground"];
        
        
        projectsArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:projectsDirPath isDirectory:YES] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
        playgroundsArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:playgroundsDirPath isDirectory:YES] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
        
        self.oldProjectsArray = projectsArray;
        self.oldPlaygroundsArray = playgroundsArray;
        
        
        [self indexProjects:projectsArray];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

    }];
    
    
    }



- (void)reload{
    NSString *rootPath = [AppDelegate storagePath];
    NSString *projectsDirPath = [rootPath stringByAppendingPathComponent:@"Projects"];
    NSString *playgroundsDirPath = [rootPath stringByAppendingPathComponent:@"Playground"];
    
    
    projectsArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:projectsDirPath isDirectory:YES] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
    playgroundsArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:playgroundsDirPath isDirectory:YES] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
    
    self.oldProjectsArray = projectsArray;
    self.oldPlaygroundsArray = playgroundsArray;
    
    
    
    [self.collectionView reloadData];
    [self indexProjects:projectsArray];
//    [self performSelector:@selector(indexProjects:) withObject:projectsArray afterDelay:1.0];
}


#pragma mark - Keyboard Shortcuts

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (NSArray *)keyCommands {
    
    return @[
             [UIKeyCommand keyCommandWithInput:@"N" modifierFlags:UIKeyModifierCommand action:@selector(newProjCommand) discoverabilityTitle:@"New Project"],
             [UIKeyCommand keyCommandWithInput:@"P" modifierFlags:UIKeyModifierCommand action:@selector(newPlayCommand) discoverabilityTitle:@"New Playground"],
             [UIKeyCommand keyCommandWithInput:@"S" modifierFlags:UIKeyModifierShift action:@selector(settingsCommand) discoverabilityTitle:@"Settings"],
             [UIKeyCommand keyCommandWithInput:@"N" modifierFlags:UIKeyModifierShift action:@selector(newsCommand) discoverabilityTitle:@"News"],
             [UIKeyCommand keyCommandWithInput:@"N" modifierFlags:UIKeyModifierShift action:@selector(forumCommand) discoverabilityTitle:@"Forum"]
             ];
}


- (void)newProjCommand{
    [self performSegueWithIdentifier:@"newProj" sender:self];
}

- (void)newPlayCommand{
    [self performSegueWithIdentifier:@"newPlay" sender:self];
}


- (void)settingsCommand{
    [self performSegueWithIdentifier:@"settings" sender:nil];
}

- (void)newsCommand{
    //Display news feed
    
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/vwasstudios"];
    SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:url];
    webVC.view.tintColor = [UIColor purpleColor];
    webVC.delegate = self;
    
    [self presentViewController:webVC animated:YES completion:nil];
}

- (void)forumCommand{
    NSURL *url = [NSURL URLWithString:@"http://vwas.cf/solvinator/"];
    SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:url];
    webVC.view.tintColor = [UIColor purpleColor];
    webVC.delegate = self;
    
    [self presentViewController:webVC animated:YES completion:nil];
}




- (NSMetadataQuery *)query {
    if (!_query) {
        _query = [[NSMetadataQuery alloc]init];
        
        NSArray *scopes = @[NSMetadataQueryUbiquitousDocumentsScope];
        _query.searchScopes = scopes;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", NSMetadataItemFSNameKey, @"*"];
        _query.predicate = predicate;
    }
    return _query;
}



#pragma mark - set up

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]



- (void)setUp {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"CNFirstRunEver"]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"setUp" sender:nil];
        });
        
    }
    
    NSString *macroKey = @"MacroInitBOOL";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    BOOL macro = [userDefaults boolForKey:macroKey];

   
    if (!macro) {
        [userDefaults setBool:YES forKey:macroKey];
        
        
        [SettingsEngine restoreSyntaxSettings];
        [SettingsEngine restoreServerSettings];
    }
}



#pragma mark - Sportlight




- (void)indexProjects:(NSArray *)projects{
    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityNormal;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceUtility;
    
    backgroundOperation.completionBlock = ^{
        [projects enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
            
            
            
            CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeItem];
            
            NSString *title = [projects[idx] lastPathComponent];
            [attributeSet setTitle:title.stringByDeletingPathExtension];
            
            NSString *description;
            if ([title.pathExtension isEqualToString:@"cnProj"]) {
                description = @"The Codinator project you've recently worked on";
            }
            else if ([title.pathExtension isEqualToString:@"zip"]) {
                description = @"The project you recently imported into Codinator";
            }
            else {
                description = @"A file that you have imported into Codinator";
            }
            
            [attributeSet setContentDescription:description];
            
            NSString *creator = @"Codinator";
            [attributeSet setCreator:creator];
            
            
            NSString *identifier = [NSString stringWithFormat:@"com.vladidanila.codinator.%@", title];
            
            CSSearchableItem *item = [[CSSearchableItem alloc]
                                      initWithUniqueIdentifier:title domainIdentifier:identifier attributeSet:attributeSet];
            
            
            
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * __nullable error) {
                if (error) {
                    #ifdef DEBUG
                    NSLog(@"%@",[error localizedDescription]);
                    #endif
                } else {
#ifdef DEBUG
                    NSLog(@"Indexed: %@", item.uniqueIdentifier);
#endif
                }
            }];
            
            
        }];

    };
//    
//    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    
}

- (void)restoreUserActivityState:(NSUserActivity *)activity {
   
    
    if ([activity.activityType isEqualToString:@"com.apple.corespotlightitem"]) {
        NSDictionary *userInfo = activity.userInfo;
        
        if (userInfo) {
        
            
            NSString *root = [AppDelegate storagePath];
            NSString *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];

            NSString *projectName = userInfo[CSSearchableItemActivityIdentifier];

            NSString *documentPath = [projectsDirPath stringByAppendingPathComponent:projectName];
            
            
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir]) {
      
                // Import Zip
                if ([projectName containsString:@".zip"]) {
                    self.zipPath = [projectsDirPath stringByAppendingPathComponent:projectName];
                    [self performSegueWithIdentifier:@"importZip" sender:self];
                }
                
                // Open Project
                else if ([projectName containsString:@".cnProj"]){
                    NSString *path = [projectsDirPath stringByAppendingPathComponent:projectName];
                    
                    document = [[CodinatorDocument alloc] initWithFileURL:[NSURL fileURLWithPath:path]];
                    
                    [document openWithCompletionHandler:^(BOOL success) {
                        
                        if (success) {
                            
                            projectIsOpened = YES;
                            
                            self.projectsPath = path;
                            [self performSegueWithIdentifier:@"projectPop" sender:nil];
                            
                        }
                        else{
                            NSString *message = [NSString stringWithFormat:@"%@ can't be opened right now...", path.lastPathComponent];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                            [alert addAction:closeAlert];
                            [self presentViewController:alert animated:YES completion:nil];
                            
                        }
                        
                    }];
                    
                }
                else {
                    
                    // Failed Opening other file type
                    NSString *message = [NSString stringWithFormat:@"Failed opening %@", projectName];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:closeAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
                
            }
            
            else {
                
                // Failed Opening other file type
                NSString *message = [NSString stringWithFormat:@"Document wasn't found"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:closeAlert];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
        }
        
    }
}



#pragma mark - CollectionView Delegates

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [projectsArray count];
            break;
        case 1:
            return [playgroundsArray count];
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(166, 155)/*CGSizeMake(170, 155)*/;
}


- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{

    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Document" forIndexPath:indexPath];
    
    NSString const *root = [AppDelegate storagePath];
    
    
    //If 'projects' is selected
    if (indexPath.section == 0) {
        
        
        if ([[projectsArray[indexPath.row] lastPathComponent] containsString:@".zip"]) {
            
            cell.imageView.image = [UIImage imageNamed:@"zip"];
            cell.name.text = [projectsArray[indexPath.row] lastPathComponent];
            
        }
        else{
            
            NSString const *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];
            NSString *path = [projectsDirPath stringByAppendingPathComponent:[projectsArray[indexPath.row] lastPathComponent]];

            
            [self dealWithiCloudDownloadForCell:cell forIndexPath:indexPath andFilePath:path];
            
            
            
            cell.imageView.image = [self projectRocketBlueprintIconForProjectPath:[projectsDirPath stringByAppendingPathComponent:[projectsArray[indexPath.row] lastPathComponent]]];
            cell.name.text = [[projectsArray[indexPath.row] lastPathComponent] stringByDeletingPathExtension];

        }
        
        
        
    }
    else{ //If 'playgrounds' section
        
        
        if (!self.appDelegate.thumbnailManager) {
            self.appDelegate.thumbnailManager = [[Thumbnail alloc] init];
        }
        
        
        //Paths
        NSString const *playgroudPaths = [root stringByAppendingPathComponent:@"Playground"];
        NSString *path = [playgroudPaths stringByAppendingPathComponent:[playgroundsArray[indexPath.row] lastPathComponent]];
        
        
        cell.imageView.image = [self.appDelegate.thumbnailManager thumbnailForFileAtPath:path];
        
        if ([path.pathExtension isEqualToString:@"icloud"]) {
            cell.loadingIndicator.hidden = NO;
            cell.progressView.hidden = NO;
            [cell.progressView setProgress:0.5f animated:YES];
            [self dealWithiCloudDownloadForCell:cell forIndexPath:indexPath andFilePath:path];
            
            NSString *cellText = [[[playgroundsArray[indexPath.row] lastPathComponent] stringByDeletingPathExtension] stringByDeletingPathExtension];
            cell.name.text = cellText;
        }
        else{
            cell.loadingIndicator.hidden = YES;
            cell.progressView.hidden = YES;
            cell.progressView.progress = .0f;
            
            cell.name.text = [[[playgroundsArray[indexPath.row] lastPathComponent] stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"" withString:@""];

        }
        
    }
    
    
    
    // Create long press Gesture Recognizer
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewCellWasLongPressed:)];
    [cell addGestureRecognizer:longPressRecognizer];
    

    
    return cell;
}


- (void)dealWithiCloudDownloadForCell:(nonnull ProjectCollectionViewCell *)cell forIndexPath:(nonnull NSIndexPath *)indexPath andFilePath:(nonnull NSString *)path{
 
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityNormal;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceUtility;
    
    backgroundOperation.completionBlock = ^{
        
        
        NSError *error;
        BOOL downloadDone = [[NSFileManager defaultManager]startDownloadingUbiquitousItemAtURL:[NSURL fileURLWithPath:path isDirectory:NO] error:&error];
        
        if (downloadDone) {
            cell.loadingIndicator.hidden = YES;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }
        
//        #ifdef DEBUG
//        if (error) {
//            NSLog(@"%@", error.localizedFailureReason);
//        }
//        #endif
        
    };
    
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    
}




- (UIImage *)projectRocketBlueprintIconForProjectPath:(NSString *)path{
    

    NSString *favIconPath = [path stringByAppendingPathComponent:@"Assets/favicon.png"];
    
    
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:favIconPath];

    if (fileExists) {
        return [UIImage imageWithContentsOfFile:favIconPath];
    }
    else{
        
        if (!self.rocketBlueprintImage) {
            self.rocketBlueprintImage = [UIImage imageNamed:@"cnProj"];
        }
       
        return self.rocketBlueprintImage;
       
    }
}



- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Root Path
    NSString *root = [AppDelegate storagePath];
    
    //Custom Paths
    NSString *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];
    NSString *playgroundsDirPath = [root stringByAppendingPathComponent:@"Playground"];
    
    
    if (indexPath.section == 0) { //If projects is selected
        
        if ([[projectsArray[indexPath.row] lastPathComponent] containsString:@".zip"]) {
            //Show project importer view
            
            self.zipPath = [projectsDirPath stringByAppendingPathComponent:[projectsArray[indexPath.row] lastPathComponent]];
            [self performSegueWithIdentifier:@"importZip" sender:self];
        }
        else{
            NSString *path = [projectsDirPath stringByAppendingPathComponent:[projectsArray[indexPath.row] lastPathComponent]];
            
            document = [[CodinatorDocument alloc] initWithFileURL:[NSURL fileURLWithPath:path]];
            
            [document openWithCompletionHandler:^(BOOL success) {
                
                if (success) {
                    
                    projectIsOpened = YES;
                    
                    self.projectsPath = path;
                    [self performSegueWithIdentifier:@"project" sender:nil];
                    
                }
                else{
                    NSString *message = [NSString stringWithFormat:@"%@ can't be opened right now...", path.lastPathComponent];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:closeAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
            }];
            
        }
        
        
    }
    else if (indexPath.section == 1){ // Playground selected
        
        
        NSString *fileName = [playgroundsArray[indexPath.row] lastPathComponent];
        NSString *path;
        
        if (self.useTmpPath) {
            path = [self.tmpPath stringByAppendingPathComponent:fileName];
        }
        else{
            path = [playgroundsDirPath stringByAppendingPathComponent:fileName];
        }
        
        
        if ([fileName.pathExtension isEqualToString:@"cnPlay"]) {
            
            self.playgroundsPath = path;
            
            [self performSegueWithIdentifier:@"playground" sender:self];
            
        }
        else{
            
            ///Some stuff missing
            if ([[self.appDelegate thumbnailManager] isFileAtPathDir:path]){
                
                
                
            }
            else{
                
                
                
                
            }
        }
    }

}





- (IBAction)tableViewCellWasLongPressed:(UILongPressGestureRecognizer *)sender {
    
    
    CGPoint p = [sender locationInView:self.collectionView];
    CGRect position;
    position.origin.x = p.x;
    position.origin.y = p.y;
    position.size.height  = 0;
    position.size.width = 20;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];

    if (sender.state == UIGestureRecognizerStateBegan && indexPath) {
        
        NSString *deletePath;

        
        NSString *root = [AppDelegate storagePath];
  
        
        
        if (indexPath.section == 0) {
            NSString *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];
            deletePath = [projectsDirPath stringByAppendingPathComponent:[projectsArray[indexPath.row] lastPathComponent]];
        }
        else{
            NSString *playgroundsDirPath = [root stringByAppendingPathComponent:@"Playground"];
            deletePath = [playgroundsDirPath stringByAppendingPathComponent:[playgroundsArray[indexPath.row] lastPathComponent]];
        }
        
        
        
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __nonnull action) {
                
                
                NSError *error;
                [[NSFileManager defaultManager]removeItemAtPath:deletePath error:&error];

                
                
                if (!error) {
                    
                    [self reloadData];
                
                }
                
                
            }];
            
            
            
            UIAlertAction *renameAction = [UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            
                // RENAME FILE DIALOGE
                NSString *message = [NSString stringWithFormat:@"Rename \"%@\"", deletePath.lastPathComponent.stringByDeletingPathExtension];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename" message:message preferredStyle:UIAlertControllerStyleAlert];
                alert.view.tintColor = [UIColor blackColor];
                
                
                [alert addTextFieldWithConfigurationHandler:^(UITextField * __nonnull textField) {
                    textField.placeholder = @"Projects new name";
                    textField.keyboardAppearance = UIKeyboardAppearanceDark;
                    textField.tintColor = [UIColor purpleColor];
                }];
                
                UIAlertAction *processAction = [UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
              
                    NSString *extension = @"";
                    if (indexPath.section == 0) {
                        extension = @"cnProj";
                    }
                    else {
                        extension = @"cnPlay";
                    }
                    
                    NSString *newName = [alert.textFields[0].text stringByAppendingPathExtension:extension];
                    NSString *newPath = [[deletePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
                    
                    Polaris *polaris = [[Polaris alloc] initWithProjectPath:deletePath currentView:nil WithWebServer:false UploadServer:false andWebDavServer:false];
                    [polaris updateSettingsValueForKey:@"ProjectName" withValue:newName.stringByDeletingPathExtension];
                    
                    [[NSFileManager defaultManager] moveItemAtPath:deletePath toPath:newPath error:nil];
                    [self reloadData];
                    
                    
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:processAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
                
                
            }];
            
//            UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"Move file into a project" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
//            
//                ///move FILE DIALOGE
//                
//            
//            }];
//        
        
            NSOperation *backgroundOperation = [[NSOperation alloc] init];
            backgroundOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
            backgroundOperation.qualityOfService = NSOperationQualityOfServiceUserInteractive;
    
            backgroundOperation.completionBlock = ^{
        
                UIAlertController *popup = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                popup.view.tintColor = [UIColor blackColor];
                
                [popup addAction:renameAction];
                [popup addAction:deleteAction];

//                if (indexPath.section == 1) {
//                    [popup addAction:moveAction];
//                }
                
                
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                    [popup dismissViewControllerAnimated:true completion:nil];
                }];
                
                [popup addAction:cancel];
                
                
                popup.popoverPresentationController.sourceView = self.collectionView;
                popup.popoverPresentationController.sourceRect = position;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self presentViewController:popup animated:YES completion:nil];
                });
                
                
            };
    
    
            [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
        
    
    
    }
        
        
        
        
}






#pragma mark - iCloud Data management & Tableview Reloading



- (void)queryDidReceiveNotification:(NSNotification *)notification {
    NSArray *results = [self.query results];
    
    for(NSMetadataItem *item in results) {
    
        NSOperation *backgroundOperation = [[NSOperation alloc] init];
        backgroundOperation.queuePriority = NSOperationQueuePriorityNormal;
        backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
        
        backgroundOperation.completionBlock = ^{
            
            
            NSString *downloaded = [item valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusNotDownloaded];
            
            if (!downloaded) {

                
                NSURL *fileURL = [item valueForAttribute:NSMetadataItemURLKey];
                
                NSError *error;
                [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:fileURL error:&error];
                
                #ifdef DEBUG
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
                #endif
                
            }
            
            
            
        };
        
        
        [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    }
    

    [self reloadData];
}



- (void)reloadData{
    [super viewDidAppear:true];
    
    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityNormal;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceUtility;
    
    backgroundOperation.completionBlock = ^{
        //Root Path
        NSString *root = [AppDelegate storagePath];
        
        //Custom Paths
        NSString *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];
        NSString *playgroundsDirPath = [root stringByAppendingPathComponent:@"Playground"];
        
        
        projectsArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:projectsDirPath isDirectory:YES] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
        playgroundsArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:playgroundsDirPath isDirectory:YES] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];

        
        if (![projectsArray isEqualToArray:self.oldProjectsArray] | ![playgroundsArray isEqualToArray:self.oldPlaygroundsArray]) {
            
            self.oldProjectsArray = projectsArray;
            self.oldPlaygroundsArray = playgroundsArray;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        
        }

    };
    
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    

    
}





- (IBAction)versionDidPush:(id)sender {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    
    NSString *versionString = [NSString stringWithFormat:@"Version: %@", version];
    NSString *buildString = [NSString stringWithFormat:@"Build (%@)", build];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:versionString message:buildString preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:close];

    
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {

        [self performSegueWithIdentifier:@"settings" sender:nil];
        
    }];

    [alert addAction:settings];

    
    UIAlertAction *newsFeed = [UIAlertAction actionWithTitle:@"News" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        
        //Display news feed
        
        NSURL *url = [NSURL URLWithString:@"https://twitter.com/vwasstudios"];
        SFSafariViewController *webVC = [[SFSafariViewController alloc] initWithURL:url];
        webVC.view.tintColor = [UIColor purpleColor];
        webVC.delegate = self;
        webVC.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:webVC animated:YES completion:nil];
        
    }];
    
    [alert addAction:newsFeed];
    
    
    alert.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = sender;
    
    UIBarButtonItem *senderButton = sender;
    popPresenter.barButtonItem = senderButton;
    
    alert.view.tintColor = [UIColor purpleColor];

    
    [self presentViewController:alert animated:true completion:^{
        alert.view.tintColor = [UIColor purpleColor];
    }];
    
}

- (IBAction)plusDidPush:(id)sender {
    
    UIBarButtonItem *plusButton = sender;

    
    
    UIAlertController *newDoc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *projectAction = [UIAlertAction actionWithTitle:@"Project" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        
        
        UIAlertController *projectAlert = [UIAlertController alertControllerWithTitle:nil message:@"Do you want to create a new project or import an existing one?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        projectAlert.popoverPresentationController.sourceView = self.plusButtonSuperView;
        projectAlert.popoverPresentationController.barButtonItem = plusButton;
        
        UIAlertAction *createProjectAction = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
               [self performSegueWithIdentifier:@"newProj" sender:self];
        }];
        
        
        UIAlertAction *cancelProjectCreationAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
            [projectAlert dismissViewControllerAnimated:true completion:nil];
        }];
        
        UIAlertAction *importProjectAction = [UIAlertAction actionWithTitle:@"Import" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            
            [self performSegueWithIdentifier:@"import" sender:self];
            
        }];
        
        
        [projectAlert addAction:createProjectAction];
        [projectAlert addAction:importProjectAction];
        [projectAlert addAction:cancelProjectCreationAction];
        
        [self presentViewController:projectAlert animated:true completion:^{
            //projectAlert.view.tintColor = [UIColor purpleColor];
        }];
        
    }];
    
    UIAlertAction *playgroundAction = [UIAlertAction actionWithTitle:@"Playground" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        
        [self performSegueWithIdentifier:@"newPlay" sender:self];
        
    }];
    

    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [newDoc addAction:projectAction];
    [newDoc addAction:playgroundAction];
    [newDoc addAction:cancelAction];
    //newDoc.view.tintColor = [UIColor purpleColor];

    
    newDoc.popoverPresentationController.sourceView = self.plusButtonSuperView;
    newDoc.popoverPresentationController.barButtonItem = plusButton;
    
    
    [self presentViewController:newDoc animated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)safariViewControllerDidFinish:(nonnull SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"importZip"]){
        
        ProjectZipImporterViewController *destViewController = segue.destinationViewController;
    
        
        NSString *root = [AppDelegate storagePath];
        NSString *projectsDirPath = [root stringByAppendingPathComponent:@"Projects"];

        
        destViewController.filePathToZipFile = self.zipPath;
        destViewController.projectsPath = projectsDirPath;
        
    }
    else if ([segue.identifier isEqualToString:@"playground"]) {
        
        PlaygroundViewController *destViewController = segue.destinationViewController;
        destViewController.filePath = self.playgroundsPath;
        
    }
    else if ([segue.identifier isEqualToString:@"project"] || [segue.identifier isEqualToString:@"projectPop"]) {
        ProjectMainViewController *destViewController = segue.destinationViewController;
        destViewController.path = self.projectsPath;
    }else if ([segue.identifier isEqualToString:@"settings"]){
        
    }
}









@end
