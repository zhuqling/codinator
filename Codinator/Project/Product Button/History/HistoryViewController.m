//
//  HistoryViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 19/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryWebViewController.h"
#import "ProjectExportViewController.h"


#define rgb(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0]
@implementation HistoryViewController
@synthesize projectManager;


-(void)viewDidLoad{
    [super viewDidLoad];
    
    tableView.backgroundColor = self.view.backgroundColor;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[projectManager projectVersionsPath]];
    if (fileExists){
        NSError *error;
        items = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[projectManager projectVersionsPath] error:&error] mutableCopy];
        [items removeObject:@"Autobackup"];
        
        
    }
    else{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This Project seems to be broken 😞" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
    [alert addAction:closeAlert];
    [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    
    //round interface a bit
    closeButton.layer.cornerRadius = 5;
    closeButton.layer.masksToBounds = YES;
}


#pragma mark - tableView



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return @"Auto Backup";
    }
    else{
        return @"Snapshots";
    }

}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    else{
        return items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    
    HistoryRow *cell = [tableView2 dequeueReusableCellWithIdentifier:@"historyRow"];
    cell.backgroundColor = rgb(31, 33, 36);
    cell.textLabel.textColor = [UIColor whiteColor];;
    UIImage *selectionBackground = [UIImage imageNamed:@"black"];
    UIImageView *iview=[[UIImageView alloc] initWithImage:selectionBackground];
    cell.selectedBackgroundView=iview;
    

    
    if (indexPath.section == 0) {
        
            
        NSString *halfPath = [[projectManager projectVersionsPath] stringByAppendingPathComponent:@"Autobackup"];
        NSString *path = [halfPath stringByAppendingPathComponent:@"data"];
        NSString *time = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        
        cell.versionLabel.text =  [NSString stringWithFormat:@"Auto Backup@<%@>", time];
        cell.versionLabel.font = [UIFont systemFontOfSize:35.0f];
        cell.descriptionTextView.text = @"Automatic snapshot taken every 10 min";
    
    }
    else{
        NSString *version = items[indexPath.row];
        NSString *halfPath = [[projectManager projectVersionsPath] stringByAppendingPathComponent:version];
        NSString *path = [halfPath stringByAppendingPathComponent:@"data"];
    
        cell.versionLabel.text  = [NSString stringWithFormat:@"Version: %li",(long)indexPath.row+1];
        cell.descriptionTextView.text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    
    
    
    
    
    return cell;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Version%li",(long)indexPath.row+1);
    
    previewButton.enabled = YES;
    uploadButton.enabled = YES;
    resetButton.enabled = YES;
}






#pragma mark - buttons
- (IBAction)cancelDidPush:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (IBAction)uploadDidPush:(id)sender {
   
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    NSString *versionNumber;
  
    if (indexPath.section == 0) {
        versionNumber = @"Autobackup";
    }
    else{
        versionNumber = [NSString stringWithFormat:@"Version%li.0",(long)indexPath.row+1];
    }
    
    
    projectManager.archivePath = [[projectManager projectVersionsPath] stringByAppendingPathComponent:versionNumber];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:projectManager.archivePath];
    if (fileExists) {
        [self performSegueWithIdentifier:@"export" sender:self];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong..." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}





- (IBAction)previewDidPush:(id)sender {
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    NSString *versionNumber;
    
    if (indexPath.section == 0) {
        versionNumber = @"Autobackup/index.html";
    }
    else{
        versionNumber = [NSString stringWithFormat:@"Version%li.0/index.html",(long)indexPath.row+1];
    }
    projectManager.tmpFilePath = [[projectManager projectVersionsPath] stringByAppendingPathComponent:versionNumber];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:projectManager.tmpFilePath];
    if (fileExists) {
        [self performSegueWithIdentifier:@"preview" sender:self];
    }
    else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"We will ship the preview for PHP-projects later 🌀" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    

}



- (IBAction)restoreDidPush:(id)sender {
    
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    NSString *versionNumber;
    
    if (indexPath.section == 0) {
        versionNumber = @"Autobackup";
    }
    else{
        versionNumber = [NSString stringWithFormat:@"Version%li.0",(long)indexPath.row+1];
    }
    
    NSString *dirToCopyPath = [[projectManager projectVersionsPath] stringByAppendingPathComponent:versionNumber];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dirToCopyPath];
    if (fileExists) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager setDelegate:self];
        [fileManager removeItemAtPath:projectManager.inspectorPath error:nil];
        [fileManager copyItemAtPath:dirToCopyPath  toPath:projectManager.inspectorPath error:nil];
    
    
        NSString *commentPath = [projectManager.inspectorPath stringByAppendingPathComponent:@"data"];
        [[NSFileManager defaultManager] removeItemAtPath:commentPath error:nil];
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Restored Successfully ♻️" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];
    
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"history" object:self userInfo:nil];
        
        return;

    }
    else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == NSFileWriteFileExistsError) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}


#pragma mark - storyboard segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"preview"]) {
        HistoryWebViewController *destViewController = segue.destinationViewController;
        destViewController.path = projectManager.tmpFilePath;
    }
    else if ([segue.identifier isEqualToString:@"export"]){
        ProjectExportViewController *destViewController = segue.destinationViewController;
        destViewController.projectManager = projectManager;
    }
}

@end
