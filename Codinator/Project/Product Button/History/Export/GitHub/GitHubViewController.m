//
//  GitHubViewController.m
//  VWAS-HTML
//
//  Created by Vladimir on 29/04/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "GitHubViewController.h"

#define LOG(fmt, ...)		NSLog(@"%s:%d：%s\n%@", (strrchr(__FILE__, '/') + 1), __LINE__, __func__, [NSString stringWithFormat:fmt,## __VA_ARGS__])



@interface GitHubViewController ()
@end

@implementation GitHubViewController
@synthesize projectManager;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
    //Min and max values
    CGFloat leftRightMin = -100.0f;
    CGFloat leftRightMax = 100.0f;
    
    
    //Motion effect
    UIInterpolatingMotionEffect *leftRight = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    leftRight.minimumRelativeValue = @(leftRightMin);
    leftRight.maximumRelativeValue = @(leftRightMax);
    

    
    
    //Create motion effect group
    UIMotionEffectGroup *meGroup = [[UIMotionEffectGroup alloc]init];
    meGroup.motionEffects = @[leftRight];
    
    //Add the motion effect to myLocationMapView
    [bgImageView addMotionEffect:meGroup];
    
    NSString *username = [projectManager getSettingsDataForKey:@"gitUsername"];
    NSString *password = [projectManager getSettingsDataForKey:@"gitPassword"];
    
    if (username.length != 0 && password.length != 0){
        usernameTextField.text = username;
        passwordTextField.text = password;
    }
    
    

}










#pragma mark - GIST || GitHub





- (IBAction)loginDidPush:(id)sender {
//    
//    
//    [projectManager saveValue:usernameTextField.text forKey:@"gitUsername"];
//    [projectManager saveValue:passwordTextField.text forKey:@"gitPassword"];
//    
//    
//    NSString *username = usernameTextField.text;
//    NSString *password = passwordTextField.text;
//        
//        
//    if (username.length <=  0 || password.length <= 0) {
//        [self showError:@"Please set github account."];
//        return;
//    }
//    
//    
//        
//    //LOADING INDICATOR START (*Needs to be implemented*)
//    
//    
//    
//    
//    
//    
//    //Set project name
//    NSString *projectName = [projectManager getSettingsDataForKey:@"ProjectName"];
//    
//    //Set if exits project gist id
//    NSString *projectGist;
//    projectGist = [projectManager projectGistID];
//    
//        
//        
//    //Set files
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                    projectName, @"description",
//                                    [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSDictionary dictionaryWithObject:@"hello world html" forKey:@"content"], @"index.html",
//                                    [NSDictionary dictionaryWithObject:@"hello world css" forKey:@"content"], @"style.css",
//                                    [NSDictionary dictionaryWithObject:@"hello world js" forKey:@"content"], @"script.js",
//                                    nil], @"files",
//                                    nil];
//    
//    if (projectGist.length ==  0) {
//        [params setValue:(true ? @"true" : @"false") forKey:@"public"];
//    }
//    NSData *data = [[params JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableString *urlString = [NSMutableString stringWithString:@"https://api.github.com/gists"];
//    if (projectGist.length != 0) {
//        [urlString appendFormat:@"/%@", projectGist];
//    }
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    if (projectGist != 0) {
//        [request setHTTPMethod:@"PATCH"];
//    } else {
//        [request setHTTPMethod:@"POST"];
//    }
//    
//    NSString *credential = [self base64:[NSString stringWithFormat:@"%@:%@", username, password]];
//    [request setValue:[NSString stringWithFormat:@"Basic %@", credential] forHTTPHeaderField:@"Authorization"];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:data];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSError *error = nil;
//        NSURLResponse *respo;
//        //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respo error:&error];
//        
//        
//        if (!error) {
//            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSDictionary *response = [content JSONValue];
//                NSString *gistId = [response objectForKey:@"id"];
//                LOG(@"response: %@", gistId);
//                
//                if (projectGist.length == 0) {
//                    
//                    //Save gistID
//                    [projectManager updateGistID:gistId];
//                }
//                
//    //            [[[UIAlertView alloc] initWithTitle:@"Succeeded" message:[NSString stringWithFormat:@"Gist id is \"%@\"", gistId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                
//                
//            });
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showError:[error localizedDescription]];
//                return;
//            });
//        }
//        
//    });
//        
//    //LOADING INDICATOR STOP (*Needs to be implemented*)
//    
}
    






#pragma mark - Private



- (void)showError:(NSString *)message {
 
    
    
}





-(void)up{
    [self performSegueWithIdentifier:@"upload" sender:self];
    [self performSelector:@selector(crash) withObject:self afterDelay:50.0];
}


-(void)crash{
    @throw NSInternalInconsistencyException;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeDidPush:(id)sender {
 
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
