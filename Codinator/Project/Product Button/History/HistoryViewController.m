//
//  HistoryViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 19/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryWebViewController.h"

#import "Codinator-Swift.h"

@implementation HistoryViewController
@synthesize projectManager;


-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[[projectManager projectVersionURL] path]];
    if (fileExists){
        NSError *error;
        items = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[projectManager projectVersionURL] path] error:&error] mutableCopy];
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

    NSLog(@"The path is: %@", projectManager.inspectorURL);
    
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
        return @"Commit History";
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
    UIImage *selectionBackground = [UIImage imageNamed:@"black"];
    UIImageView *iview=[[UIImageView alloc] initWithImage:selectionBackground];
    cell.selectedBackgroundView=iview;
    

    
    if (indexPath.section == 0) {
        
            
        NSURL *halfURL = [[projectManager projectVersionURL] URLByAppendingPathComponent:@"Autobackup"];
        NSURL *path = [halfURL URLByAppendingPathComponent:@"data"];
        NSString *time = [[NSString alloc] initWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
        
        
        cell.versionLabel.text =  [NSString stringWithFormat:@"Auto Backup taken at %@", time];
        cell.descriptionTextView.text = @"Automatic snapshot taken every 10 min";
    
    }
    else{
        NSString *version = items[indexPath.row];
        NSURL *halfURL = [[projectManager projectVersionURL] URLByAppendingPathComponent:version];
        NSURL *url = [halfURL URLByAppendingPathComponent:@"data"];
    
        cell.versionLabel.text  = [NSString stringWithFormat:@"Version: %li",(long)indexPath.row+1];
        cell.descriptionTextView.text = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    
    return cell;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Version%li",(long)indexPath.row+1);
    
    previewButton.enabled = YES;
    exportButton.enabled = YES;
    restoreButton.enabled = YES;
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
    
    
    projectManager.archiveURL = [[projectManager projectVersionURL] URLByAppendingPathComponent:versionNumber];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:projectManager.archiveURL.path];
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
    projectManager.tmpFileURL = [[projectManager projectVersionURL] URLByAppendingPathComponent:versionNumber];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:projectManager.tmpFileURL.path];
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
    
    NSURL *dirToCopyURL = [[projectManager projectVersionURL] URLByAppendingPathComponent:versionNumber];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dirToCopyURL.path];
    if (fileExists) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager setDelegate:self];
        [fileManager removeItemAtURL:projectManager.inspectorURL error:nil];
        [fileManager copyItemAtURL:dirToCopyURL  toURL:projectManager.inspectorURL error:nil];
    
    
        NSURL *commentURL = [projectManager.inspectorURL URLByAppendingPathComponent:@"data"];
        [[NSFileManager defaultManager] removeItemAtURL:commentURL error:nil];
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Restored Successfully" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *closeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
                        [self dismissViewControllerAnimated:true completion:^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }];
        [alert addAction:closeAlert];
        [self presentViewController:alert animated:YES completion:nil];
    
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"relaodData" object:self userInfo:nil];
        
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
        destViewController.path = projectManager.tmpFileURL.path;
    }
    else if ([segue.identifier isEqualToString:@"export"]){
        ExportViewController *destViewController = segue.destinationViewController;
        destViewController.path = projectManager.projectURL.path;
    }
}

@end
