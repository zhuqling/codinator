//
//  ExportViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 22.12.14.
//  Copyright (c) 2014 Vladimir Danila. All rights reserved.
//

#import "FileMoverViewController.h"
#import "AppDelegate.h"

@interface FileMoverViewController (){
    
    NSString *filename;
    NSString *oldFilePath;
}

@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation FileMoverViewController
@synthesize path_, rootPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self update];
    
    
    oldFilePath = path_;
    filename  = path_.lastPathComponent;
    
    path_ = rootPath;
    
    
    items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path_ error:nil] mutableCopy];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [items_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewFunc cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableViewFunc dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor blackColor];
        cell.tintColor = [UIColor purpleColor];
    }
    
    // Configure the cell.
    

    
    NSString *fileName = items_[indexPath.row];
    cell.textLabel.text = fileName;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    
    NSString *path = [path_ stringByAppendingPathComponent:fileName];
    cell.imageView.image = [self.appDelegate.thumbnailManager thumbnailForFileAtPath:path];
    
    
    
    return cell;
    
    
}




- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *path = [path_ stringByAppendingPathComponent:items_[indexPath.row]];

    BOOL isDir;
    
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if (isDir) {
        
        backButton.enabled = YES;
        
        path_ = path;
        NSError *error;
        items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path_ error:&error] mutableCopy];
        [tableView reloadData];
    }


    
    
}


- (IBAction)importButton:(id)sender {

    NSString *newFilePath = [path_ stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] moveItemAtPath:oldFilePath toPath:newFilePath error:nil];
    
    
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"history" object:self userInfo:nil];
    }];
}




- (IBAction)backButton:(id)sender {
    NSError *error;
    NSString *newPath = [path_ stringByDeletingLastPathComponent];
    

    
    if ([rootPath isEqualToString:newPath]) {
        backButton.enabled = NO;
    }
    else{
    path_ = newPath;
    items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path_ error:&error] mutableCopy];
    [tableView reloadData];
    }
}

-(void)update{

    
    if ([path_ isEqualToString:rootPath]) {
        backButton.enabled = NO;
    }

    
    [self performSelector:@selector(update) withObject:nil afterDelay:0.08];
    
}

@end
