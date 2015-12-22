//
//  UnArchivingViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 26/04/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "UnArchivingViewController.h"

@interface UnArchivingViewController ()

@property float total;
@property float index;

@end


@implementation UnArchivingViewController
@synthesize filePathToZipFile;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filePathToZipFile = [[NSUserDefaults standardUserDefaults] stringForKey:@"ImagePath"];
    [self performSelector:@selector(start) withObject:self afterDelay:1.0];
}

-(void)start{
        [self performSelectorInBackground:@selector(unZip) withObject:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)unZip{
    NSString *destination = [NSString stringWithFormat:@"%@",[filePathToZipFile stringByDeletingLastPathComponent]];
    

    [SSZipArchive unzipFileAtPath:filePathToZipFile toDestination:destination delegate:self];
}


-(void)close{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fileReload" object:nil]; //Old root view
    [[NSNotificationCenter defaultCenter]postNotificationName:@"history" object:nil]; //projects
    [self performSelector:@selector(close2) withObject:nil afterDelay:1.0];
}

-(void)close2{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fileReload" object:nil]; //projects
    [[NSNotificationCenter defaultCenter]postNotificationName:@"history" object:nil]; //projectsfileReload

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - delegates

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath{
  //  [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    [self performSelectorOnMainThread:@selector(close) withObject:nil waitUntilDone:NO];
}


- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo{
    
    NSLog(@"file:%li Total:%li",(long)fileIndex,(long)totalFiles);
    self.total = totalFiles;
    self.index = fileIndex;
    
    [self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:YES];
}


-(void)updateProgress{
    [progressView setProgress:(double)self.index/(double)self.total animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
