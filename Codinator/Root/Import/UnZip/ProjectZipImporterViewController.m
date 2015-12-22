//
//  ProjectZipImporterViewController.m
//  Codinator
//
//  Created by Vladimir on 03/06/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "ProjectZipImporterViewController.h"

#import "CodinatorDocument.h"
#import "Polaris.h"

#import "UZKFileInfo.h"
#import "UZKArchive.h"

@interface ProjectZipImporterViewController ()

@property float total;
@property float index;
@property (nonatomic, strong) Polaris *projectManager;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@end

@implementation ProjectZipImporterViewController
@synthesize filePathToZipFile;
@synthesize projectsPath;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.closeButton.layer.cornerRadius = 5.0f;
    self.closeButton.layer.masksToBounds = YES;
    
    [self performSelector:@selector(start) withObject:self afterDelay:1.0];
}

   







#pragma mark - UnZip to tmp folder


-(void)start{
    [self performSelectorInBackground:@selector(unZip) withObject:self];
}


-(void)unZip{
    
    
    
    
    //name
    NSString *name = [[[filePathToZipFile lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"cnProj"];
    NSURL *url = [NSURL fileURLWithPath:[projectsPath stringByAppendingPathComponent:name]];
    
    CodinatorDocument *codinatorDocument = [[CodinatorDocument alloc] initWithFileURL:url];
    
    [codinatorDocument saveToURL:url
                forSaveOperation: UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success){
                       NSLog(@"Created");
                   } else {
                       NSLog(@"Not created");
                   }
               }];
    
    
    [codinatorDocument openWithCompletionHandler:^(BOOL success) {

        if (success) {
            
            
            
            self.projectManager = [[Polaris alloc] initWithCreatingProjectRequiredFilesAtPath:url.path];
            
            
            [self.projectManager saveValue:name forKey:@"ProjectName"];
            [self.projectManager saveValue:@"YES" forKey:@"UseVersionControll"];
            [self.projectManager saveValue:@"NO" forKey:@"UseFTP"];
            [self.projectManager saveValue:@"NO" forKey:@"UsePHP"];
            [self.projectManager saveValue:@"1" forKey:@"version"];
            
            
            
            
            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathToZipFile];
            
            if (fileExists) {
                
                
                UZKArchive *archive = [UZKArchive zipArchiveAtPath:filePathToZipFile];
                NSError *error;
                
                
                if (archive.isPasswordProtected) {
                    
                    NSLog(@"Password protected");
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password protected ZIPs aren't supported yet." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                            
                            [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
                                [self dismissViewControllerAnimated:true completion:nil];
                            }];
                        
                        }];
                        [alert addAction:closeAlert];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        
                    });
                    
                }
                else{
                    
                    
                    NSLog(@"%@", [archive listFilenames:nil]);
                    
                    BOOL extractedFilesSuccesful = [archive extractFilesTo:[self.projectManager projectUserDirectoryPath] overwrite:YES progress:^(UZKFileInfo *currentFile, CGFloat percentArchiveDecompressed) {
                        
                        [progressView setProgress:percentArchiveDecompressed animated:YES];
                        
                    } error:&error];
                    
                    if (extractedFilesSuccesful) {
                        [self close];
                    }
                    else{
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedRecoverySuggestion] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                                
                                [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
                                    if (success) {
                                        [self dismissViewControllerAnimated:true completion:nil];
                                    }
                                }];
                            
                            
                            }];
                            [alert addAction:closeAlert];
                            [self presentViewController:alert animated:YES completion:nil];
                        });
                        
                        
                    }
                    
                }
                
            }
            else{
                NSLog(@"Error");
            }
            
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An unknown error occured" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                
                [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
                    [self dismissViewControllerAnimated:true completion:nil];
                }];

            }];
            [alert addAction:closeAlert];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }];
    
}








- (void)close{
    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityNormal;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceUtility;
    
    backgroundOperation.completionBlock = ^{
        [[NSFileManager defaultManager] removeItemAtPath:filePathToZipFile error:nil];
        
    };
    
    [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    
    
    
    NSString *name = [[[filePathToZipFile lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"cnProj"];
    NSURL *url = [NSURL fileURLWithPath:[projectsPath stringByAppendingPathComponent:name]];

    CodinatorDocument *codinatorDocument = [[CodinatorDocument alloc] initWithFileURL:url];

    [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
       
        if (success) {
            [self dismissViewControllerAnimated:true completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];
            }];
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An unknown error occured" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                [self dismissViewControllerAnimated:true completion:nil];
                
            }];
            [alert addAction:closeAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    

}


- (IBAction)closeDidPush:(id)sender {

    NSString *name = [[[filePathToZipFile lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"cnProj"];
    NSURL *url = [NSURL fileURLWithPath:[projectsPath stringByAppendingPathComponent:name]];
    
    CodinatorDocument *codinatorDocument = [[CodinatorDocument alloc] initWithFileURL:url];

    

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cancel" message:@"Do you want to cancel this action?" preferredStyle:UIAlertControllerStyleAlert];
    
    
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __nonnull action) {

            [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
                
                [self dismissViewControllerAnimated:true completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];
                }];
            
            }];
            

        
        }];
    
            UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alert addAction:cancelAlert];
    [alert addAction:closeAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
