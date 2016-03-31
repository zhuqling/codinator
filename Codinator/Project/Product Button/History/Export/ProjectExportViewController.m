//
//  ProjectExportViewController.m
//  Codinator
//
//  Created by Vladimir on 30/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "ProjectExportViewController.h"
#import "GitHubViewController.h"
#import "SSZipArchive.h"

@interface ProjectExportViewController ()

@end

@implementation ProjectExportViewController
@synthesize projectManager;


- (void)viewDidLoad {
    [super viewDidLoad];


    closeButton.layer.cornerRadius = 5;
    closeButton.layer.masksToBounds = YES;


}





#pragma mark- Buttons



- (IBAction)iTunesDidPush:(id)sender {
    
    //Root Path
    NSString *homeDir = NSHomeDirectory();
    NSString *path = [homeDir stringByAppendingPathComponent:@"Documents"];
    
    //Custom Paths
    NSString *exportPath = [path stringByAppendingPathComponent:@"ExportProject"];

    //create dir
    [[NSFileManager defaultManager] createDirectoryAtPath:exportPath withIntermediateDirectories:true attributes:nil error:nil];
    
    //Copy files to export dir
    [[NSFileManager defaultManager] copyItemAtPath:projectManager.archivePath toPath:exportPath error:nil];
    
    
    //display new view
    [self performSegueWithIdentifier:@"iTunes" sender:self];
    
}



- (IBAction)ftpDidPush:(id)sender {
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In development" message:@"This feature is still in development. Please upload the files one by one in the share view." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    //[alert show];
}






- (IBAction)zipDidPush:(id)sender {
    
    //animate
    [UIView animateWithDuration:1.5 animations:^{
        visualEffectView.alpha = 1.0f;
    }];
    
    
    //Zip path
    NSString *zipTempFile = [NSString stringWithFormat:@"%@/Documents/Temp.zip",NSHomeDirectory()];
    
    //Create Zip
    [SSZipArchive createZipFileAtPath:zipTempFile withContentsOfDirectory:projectManager.archivePath delegate:self];
    
}


- (void)zipArchiveDidZippedArchiveToPath:(NSString *)path{
    
    if ([MFMailComposeViewController canSendMail]) {
    
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
        //design
        mc.navigationBar.tintColor = [UIColor blackColor];
        mc.view.tintColor = [UIColor blackColor];
    
    
        //mail
        mc.mailComposeDelegate = self;
        [mc setSubject:@"My Codinator project"];
    
        [mc setMessageBody:@"I created this project in Codinator. Check it out on the <a href=\"https://itunes.apple.com/app/apple-store/id912491721?pt=95911905&ct=exportZip&mt=8\">AppStore</a>" isHTML:YES];
        [mc addAttachmentData:[NSData dataWithContentsOfFile:path] mimeType:@"applicaton/zip"   fileName:@"Archive.zip"];
        
        //display view
        [self presentViewController:mc animated:YES completion:nil];
        
    }
    else{
        
        //show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You aren't logged in with an email account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
}





- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    //close mail view
    [self dismissViewControllerAnimated:YES completion:nil];

    
    //Zip path
    NSString *zipTempFile = [NSString stringWithFormat:@"%@/Documents/Temp.zip",NSHomeDirectory()];
    
    [[NSFileManager defaultManager] removeItemAtPath:zipTempFile error:nil];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        visualEffectView.alpha = .0f;
    }];
    
}





- (IBAction)cancelDidPush:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gitHub"]) {
        GitHubViewController *destViewControlller = segue.destinationViewController;
        destViewControlller.projectManager = projectManager;
    }

}


@end
