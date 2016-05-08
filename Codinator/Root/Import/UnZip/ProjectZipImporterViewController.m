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

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ProjectZipImporterViewController
@synthesize filePathToZipFile;
@synthesize projectsPath;




- (void)viewDidAppear:(BOOL)animated {
    [self start];
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
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           self.statusLabel.text = @"Created Project";
                       });
                       
                       
                   } else {
                       NSLog(@"Not created");
                   }
               }];
    
    
    [codinatorDocument openWithCompletionHandler:^(BOOL success) {

        if (success) {
            
            
            
            self.projectManager = [[Polaris alloc] initWithCreatingProjectRequiredFilesAtPath:url.path];
            
            
            [self.projectManager saveValue:name.stringByDeletingPathExtension.capitalizedString forKey:@"ProjectName"];
            [self.projectManager saveValue:@"YES" forKey:@"UseVersionControll"];
            [self.projectManager saveValue:@"NO" forKey:@"UseFTP"];
            [self.projectManager saveValue:@"NO" forKey:@"UsePHP"];
            [self.projectManager saveValue:@"1" forKey:@"version"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.statusLabel.text = @"Configured Project";
            });
            
            
            
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathToZipFile];
            
            if (fileExists) {
                
                
                UZKArchive *archive = [UZKArchive zipArchiveAtPath:filePathToZipFile];
                NSError *error;
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.statusLabel.text = @"Started Exporting";
                });
                
                
                if (archive.isPasswordProtected) {
                    
                    NSLog(@"Password protected");
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password protected ZIPs aren't supported yet." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                            
                            [codinatorDocument closeWithCompletionHandler:^(BOOL success) {
                                
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self dismissViewControllerAnimated:true completion:nil];
                                });
                                
                            }];
                        
                        }];
                        [alert addAction:closeAlert];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        
                    });
                    
                }
                else{
                    
                    
                    NSLog(@"%@", [archive listFilenames:nil]);
                    
                    
                    BOOL extractedFilesSuccesful = [archive extractFilesTo:[[self.projectManager projectUserDirectoryURL] path] overwrite:YES progress:^(UZKFileInfo *currentFile, CGFloat percentArchiveDecompressed) {
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.statusLabel.text = [NSString stringWithFormat: @"Extracting: %@", currentFile.filename.lastPathComponent.stringByDeletingPathExtension];
                        });
                        
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
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self dismissViewControllerAnimated:true completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];
            
        }];
        
        
    });
    
   

}


- (IBAction)closeDidPush:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:true completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self userInfo:nil];
        }];
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
