/*
 Copyright (c) 2015, Vladimir Danila
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.

 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "Polaris.h"

//Web server
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
//Web Upload
#import "GCDWebUploader.h"
//WebDav
#import "GCDWebDAVServer.h"


//Encryption
#import "RNEncryptor.h"
#import "RNDecryptor.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))

@interface Polaris () {
    
    NSString *projectPath;

    GCDWebServer *_webServer;
    GCDWebUploader *_webUploader;
    GCDWebDAVServer *_davServer;
    
    
    WKWebView *webPreviewView;
    
    
    NSTimer *autoBackup;
    
    BOOL initWithProjectCreator;
    BOOL needClose;
    BOOL failed;
    
}

@end


@implementation Polaris
@synthesize inspectorPath,selectedFilePath,deletePath;



+(id)alloc{
    #ifdef DEBUG
    NSLog(@"[Polaris] Version 1.2 || © 2015 VWAS-Studios & Vladimir Danila\nFollow us on Twitter: @VWASStudios || @DanilaVladi and stay up to date!");
    #endif
    return [super alloc];
}
+(id)init{
    #ifdef DEBUG
    NSLog(@"Wrong initializer. <Use initWithProjectPath or initWithNewProject instead>");
    #endif
    return [super init];
}



- (instancetype)initWithProjectCreatorAtPath:(NSString *)path withName:(NSString *)name andExtension:(NSString *)extension{
    self = [super init];
    //create project structure
    
    if (self) {
    
        initWithProjectCreator = true;
        

        NSString *projectName = [NSString stringWithFormat:@"%@.%@",name,extension];
        NSString *creationPath = [path stringByAppendingPathComponent:projectName];

        projectPath = creationPath;

        
        NSError *error;
        NSFileManager *fm = [NSFileManager defaultManager];
        
        [fm createDirectoryAtPath:creationPath withIntermediateDirectories:NO attributes:nil error:&error];
        [fm createDirectoryAtPath:[self projectVersionsPath] withIntermediateDirectories:NO attributes:nil error:&error];
        [fm createDirectoryAtPath:[self projectUserDirectoryPath] withIntermediateDirectories:NO attributes:nil error:&error];
        [fm createDirectoryAtPath:[self projectTempPath] withIntermediateDirectories:NO attributes:nil error:&error];
        [fm createDirectoryAtPath:[self projectSettingsPath] withIntermediateDirectories:NO attributes:nil error:&error];
        [fm createDirectoryAtPath:[self appleTVPreviewPath] withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSString *atvIndex = @"<NEURON>/nNEURON() __PH \n()Neuron";
        [atvIndex writeToFile:[[self appleTVPreviewPath] stringByAppendingPathComponent:@"index.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            #ifdef DEBUG
            NSLog(@"[Polaris] ERROR: Faild to create a new Project. Please double check if the path exists.\nDescription: %@",[error localizedDescription]);
            #endif
        }
        
    }
    
    return self;
}


- (instancetype)initWithCreatingProjectRequiredFilesAtPath:(NSString *)path{
    self = [super init];
    //create project structure
    
    if (self) {
        
        initWithProjectCreator = true;
        
        projectPath = path;
        
        
        NSError *error;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[self projectVersionsPath] withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self projectUserDirectoryPath] withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self projectTempPath] withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self projectSettingsPath] withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createDirectoryAtPath:[self appleTVPreviewPath] withIntermediateDirectories:NO attributes:nil error:&error];

        NSString *atvIndex = @"<NEURON>/nNEURON() __PH \n()Neuron";
        [atvIndex writeToFile:[[self appleTVPreviewPath] stringByAppendingPathComponent:@"index.html"] atomically:YES encoding:NSUTF8StringEncoding error:&error];

        
        if (error) {
            #ifdef DEBUG
            NSLog(@"[Polaris] ERROR: Faild to create a new Project. Please double check if the path exists.\nDescription: %@",[error localizedDescription]);
            #endif
        }
        
    }
    
    return self;
}



- (instancetype)initWithProjectPath:(NSString *)path andWithWebServer:(BOOL)useWebServer UploadServer:(BOOL)useUploadServer andWebDavServer:(BOOL)useWebDavServer{
    self = [super init];
    
    
    if (self) {
    
        projectPath = path;
        inspectorPath = [self projectUserDirectoryPath];

        if (useWebServer || useUploadServer || useWebDavServer) {
            [self startServerForWeb:useWebServer forUploading:useUploadServer forWebDav:useWebDavServer];
        }
      
        [self autoBackup];
        autoBackup = [NSTimer scheduledTimerWithTimeInterval: 520.0 target: self selector:@selector(autoBackup) userInfo: nil repeats:YES];
    }
    
    return self;
}



- (instancetype)initWithProjectPath:(NSString *)path currentView:(UIView *)view WithWebServer:(BOOL)useWebServer UploadServer:(BOOL)useUploadServer andWebDavServer:(BOOL)useWebDavServer{
    self = [super init];
    
    
    if (self) {
        
        projectPath = path;
        inspectorPath = [self projectUserDirectoryPath];
        
        if (useWebServer || useUploadServer || useWebDavServer) {
            [self startServerForWeb:useWebServer forUploading:useUploadServer forWebDav:useWebDavServer];
            
            
            //tvOS thing
            WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
            webViewConfiguration.allowsInlineMediaPlayback = NO;
            webViewConfiguration.allowsAirPlayForMediaPlayback = NO;
            webViewConfiguration.requiresUserActionForMediaPlayback = YES;
            webViewConfiguration.applicationNameForUserAgent = @"Codinator";
            webViewConfiguration.allowsPictureInPictureMediaPlayback = NO;
            
            
            CGRect frame;
            
            if (IS_RETINA) {
                frame = CGRectMake(view.frame.size.width+1000, 0, 960, 540);
            }
            else{
                frame = CGRectMake(view.frame.size.width+1000, 0, 1920, 1080);
            }
            
            
            webPreviewView = [[WKWebView alloc]initWithFrame:frame configuration:webViewConfiguration];
            webPreviewView.navigationDelegate = self;
            [view insertSubview:webPreviewView atIndex:0];
            
        }
        
        [self autoBackup];
        autoBackup = [NSTimer scheduledTimerWithTimeInterval: 520.0 target: self selector:@selector(autoBackup) userInfo: nil repeats:YES];
    }
    
    return self;
}







- (void)close{
    
    [autoBackup invalidate];
    [self deleteBackup];
    
        if (_webServer.isRunning) {
            [_webServer stop];
        }
        
        if (_webUploader.isRunning) {
            [_webUploader stop];
        }
        
        if (_davServer.isRunning) {
            [_davServer stop];
        }
}






#pragma mark - functions



- (void)generateATVPreview{

    NSURL *fileUrl = [NSURL fileURLWithPath:self.selectedFilePath isDirectory:NO];
    NSURL *rootUrl = [NSURL fileURLWithPath:[self.selectedFilePath stringByDeletingLastPathComponent] isDirectory:YES];
        

    [webPreviewView loadFileURL:fileUrl allowingReadAccessToURL:rootUrl];

            
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t renderQueue = dispatch_queue_create("com.throttling.queue", NULL);
    
    
    if (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) == 0) {
        dispatch_async(renderQueue, ^{
            // capture
            
            
            
            NSOperation *backgroundOperation = [[NSOperation alloc] init];
            backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
            backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
            
            backgroundOperation.completionBlock = ^{
                
                
                // Capture
                
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(webPreviewView.frame.size.width, webPreviewView.frame.size.height),
                                                       YES, 0.0);
                [webPreviewView drawViewHierarchyInRect:webPreviewView.bounds afterScreenUpdates:NO];
                
                
                
                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                // Save image to path
                NSData *tvImage = UIImageJPEGRepresentation(newImage, 0.80);
                
                NSString *path = [[self projectUserDirectoryPath] stringByAppendingPathComponent:@".atvImage_CN.jpg"];
                [tvImage writeToFile:path atomically:YES];
                
                
            };
            
            
            [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
            
            
            
            
            
            
            dispatch_semaphore_signal(semaphore);
        });
    }

    
}



- (UIImage *)captureScreen:(WKWebView *) viewToCapture{
   
    // Create a new view with Full HD dimensions
    WKWebView *tmpView = viewToCapture;
    
    CGRect frame = tmpView.frame;
    
    if (IS_RETINA) {
        frame.size.height = 540;
        frame.size.width = 960;
    }
    else{
        frame.size.height = 1080;
        frame.size.width = 1920;
    }
    
    tmpView.frame = frame;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1920, 1080),
                                           YES, 0.0);
    [tmpView drawViewHierarchyInRect:tmpView.bounds afterScreenUpdates:YES];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}






- (NSString *)fakePathForFile:(NSString *)selectedFile{

    if (!initWithProjectCreator) {
        return [selectedFile stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[self projectUserDirectoryPath]] withString:@""];

    }
    else{
        NSLog(@"[Polaris] ERROR: Wrong initializer.");
        return nil;
    }
}

- (NSString *)fakePathForFileSelectedFile{
    if (!initWithProjectCreator) {
        
        return [selectedFilePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[self projectUserDirectoryPath]] withString:@""];
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] ERROR: Wrong initializer.");
        #endif
        return nil;
    }
}

- (NSMutableArray *)contentsOfCurrentDirectory{
    if (!initWithProjectCreator) {
        
        NSURL *url = [NSURL fileURLWithPath:inspectorPath isDirectory:YES];
        NSMutableArray *items = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];
        
        return items;
            
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] ERROR: Wrong initializer.");
        #endif
        return nil;
    }
}


- (NSMutableArray *)contentsOfDirectoryAtPath:(NSString *)path{
    if (!initWithProjectCreator) {
        
        NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
        NSMutableArray *items = [[[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil] mutableCopy];

        
    return items;
    
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] ERROR: Wrong initializer.");
        #endif
        return nil;
    }
}



- (void)archiveWorkingCopyWithCommitMessge:(NSString *)message{
    

    [self archiveWorkingCopyWithCommitMessge:message andTitle:nil];
    
}




- (void)deleteBackup{
    
    if ([self checkIfBackupExists]) {

            
        NSString *pathToDelete = [[self projectVersionsPath] stringByAppendingPathComponent:@"Autobackup"];
        NSURL *url = [NSURL fileURLWithPath:pathToDelete isDirectory:YES];
    
        NSError *error;
        [[NSFileManager alloc] removeItemAtURL:url error:&error];
    
        if (error) {
            #ifdef DEBUG
            NSLog(@"[Polaris] Error deleting backup");
            #endif
        }
    
    }
}

- (BOOL)checkIfBackupExists{

    NSString *backupPath = [[self projectVersionsPath] stringByAppendingPathComponent:@"Autobackup"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:backupPath];
    return fileExists;
}



#pragma mark - Server Stuff

- (NSString *)webServerURL{
    if (!initWithProjectCreator) {
        return [_webServer.serverURL absoluteString];
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
        return nil;
    }
}

- (NSString *)webUploaderServerURL{
    if (!initWithProjectCreator) {
        return [_webUploader.serverURL absoluteString];

    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
        return nil;
    }
}

- (NSString *)webDavServerURL{
    if (!initWithProjectCreator) {
        return [_davServer.serverURL absoluteString];
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
        return nil;
    }
}

#pragma mark - Paths

-(NSString *)projectPath{
    return projectPath;

}



- (NSString *)projectUserDirectoryPath{
    return [projectPath stringByAppendingPathComponent:@"Assets"];
}

- (NSString *)projectVersionsPath{
    return [projectPath stringByAppendingPathComponent:@"Versions"];
}

- (NSString *)projectTempPath{
    return [projectPath stringByAppendingPathComponent:@"Temp"];
}

- (NSString *)projectSettingsPath{
    return [projectPath stringByAppendingPathComponent:@"Config"];
}

- (NSString *)appleTVPreviewPath{
    return [projectPath stringByAppendingPathComponent:@"ATV4"];
}

#pragma mark - Values


- (NSString *)projectCurrentVersion{
    if (!initWithProjectCreator) {
        NSString *version = [NSString stringWithFormat:@"%@.0", [self getSettingsDataForKey:@"version"]];
        
        #ifdef DEBUG
        if (version.length == 0) {
            NSLog(@"[Polaris] Warning: There's no version saved. Save a version for key:'Version'");
        }
        #endif
        
        return version;
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
        return nil;
    }

}

- (NSString *)projectCopyright{
    
    if (!initWithProjectCreator) {
       return [self getSettingsDataForKey:@"Copyright"];

    }
    else{
        NSLog(@"[Polaris] Warning: Wrong initializer");
        return nil;
    }

}

- (NSString *)projectGistID{
    
    if (!initWithProjectCreator) {
        NSString *gistID = [self getSettingsDataForKey:@"gistID"];
        if (gistID.length == 0) {
            NSLog(@"[Polaris] Warning: Thre's no saved gistValue");
            return nil;
        }
        else{
            return [self getSettingsDataForKey:@"gistID"];
        }
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
        return nil;
    }

}



#pragma mark - Settings




- (void)updateGistID:(NSString*)gistID{
    if (!initWithProjectCreator) {
        [self updateSettingsValueForKey:@"gistID" withValue:gistID];
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
    }
}



- (void)updateVersionNumberToVersion:(int)versionNumber{
    if (!initWithProjectCreator) {
        [self updateSettingsValueForKey:@"version" withValue:[NSString stringWithFormat:@"%i",versionNumber]];
    }
    else{
        #ifdef DEBUG
        NSLog(@"[Polaris] Warning: Wrong initializer");
        #endif
    }
}



- (void)updateSettingsValueForKey:(NSString *)key withValue:(id)anObject{
    NSDictionary *dict = [self getProjectSettingsDictionary];
    [dict setValue:[self encryptData:anObject forKey:key] forKey:key];
    
    [self saveDictionary:dict];
    
    
}

- (void)saveValue:(id)anObject forKey:(NSString *)key{
    NSMutableDictionary *dict = [self getProjectSettingsDictionary];
    [dict setValue:[self encryptData:anObject forKey:key] forKey:key];
    [self saveDictionary:dict];
}




- (NSString *)getSettingsDataForKey:(NSString *)key{
    
    NSDictionary *dict = [self getProjectSettingsDictionary];
    NSString *string = [self decryptedData:[dict valueForKey:key] forKey:key];
    
    #ifdef DEBUG
    if (!string) {
        NSLog(@"[Polaris] Warning: Warning: Value for key:%@ is empty or value doesn't exist.",key);
    }
    #endif
    
    return string;
}



#pragma mark - Private Methods



- (void)autoBackup{
    
    if (!self.pauseAutobackup) {
    
    NSOperation *backgroundOperation = [[NSOperation alloc] init];
    backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
    backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
    
    backgroundOperation.completionBlock = ^{
      
        

        // get current date/time
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *currentTime = [dateFormatter stringFromDate:today];
        #ifdef DEBUG
        NSLog(@"User's current time in their preference format:%@",currentTime);
        #endif
        
        [self archiveWorkingCopyWithCommitMessge:currentTime andTitle:@"Autobackup"];
        
        
    };
    
    
        [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
    }
}






#pragma mark - Shortcuts





- (void)archiveWorkingCopyWithCommitMessge:(NSString *)message andTitle:(NSString *)title{
    
    if (!initWithProjectCreator) {
        
        
        if ([message isEqualToString:@"Enter commit message here"]) {
            message = @"";
        }
        
//        NSOperation *backgroundOperation = [[NSOperation alloc] init];
//        backgroundOperation.queuePriority = NSOperationQueuePriorityLow;
//        backgroundOperation.qualityOfService = NSOperationQualityOfServiceBackground;
//        
//        backgroundOperation.completionBlock = ^{
        
            
            NSString *destination;
            
            if (title.length == 0) {
                NSString *version = [self privateProjectVersion];
                int newVersion = version.intValue + 1;
                [self updateVersionNumberToVersion:newVersion];
                
                destination = [NSString stringWithFormat:@"%@/Version%@",[self projectVersionsPath], version];
            }
            else{
                destination = [[self projectVersionsPath] stringByAppendingPathComponent:title];
                if ([self checkIfBackupExists]) {
                
                    [self deleteBackup];
                    
                }
            }
            
            
            NSError *error;
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm copyItemAtPath:[self projectUserDirectoryPath] toPath:destination error:&error];
            
            if (error) {
                #ifdef DEBUG
                NSLog(@"[Polaris] ERROR: Failed to archive project. Details: %@",[error localizedDescription]);
                #endif
            }
            else{
                
                NSError *error2;
                NSString *dataPath = [destination stringByAppendingPathComponent:@"data"];
                
                if (!message.length == 0) {
                    
                    [message writeToFile:dataPath atomically:true encoding:NSUTF8StringEncoding error:&error2];
                    
                    if (error) {
                        #ifdef DEBUG
                        NSLog(@"[Polaris] ERROR: Failed to save the comment to the archive. Details: %@",[error2 localizedDescription]);
                        #endif
                    }
                    else{
                        #ifdef DEBUG
                        NSLog(@"[Polaris] Message: Project was archived.");
                        #endif
                    }
                }
                else{
                    #ifdef DEBUG
                    NSLog(@"[Polaris] Message: Project was archived without a note.");
                    #endif
                }
            }
            
        };
        
        
//        [[NSOperationQueue mainQueue] addOperation:backgroundOperation];
//        
//        
//    }
    
    
}





- (void)saveWithoutEncryptionValue:(id)anObject forKey:(NSString *)key{
    NSMutableDictionary *dict = [self getProjectSettingsDictionary];
    [dict setValue:anObject forKey:key];
    [self saveDictionary:dict];
}


- (NSString *)getSettingsDataForKeyWithoutEncrytion:(NSString *)key{
    
    NSDictionary *dict = [self getProjectSettingsDictionary];
    NSString *string = [dict valueForKey:key];
    
    #ifdef DEBUG
    if (!string) {
        NSLog(@"[Polaris] Warning: Warning: Value for key:%@ is empty or value doesn't exist.",key);
    }
    #endif
    return string;
    
}



- (void)startServerForWeb:(BOOL)web forUploading:(BOOL)uploading forWebDav:(BOOL)webDav{
    NSString *path = [self projectUserDirectoryPath];

    if (web) {
        
        _webServer = [[GCDWebServer alloc] init];
        [_webServer addGETHandlerForBasePath:@"/" directoryPath:path indexFilename:@"index.html" cacheAge:3600 allowRangeRequests:YES];
        [_webServer startWithPort:8080 bonjourName:nil];

    }
    
    if (uploading) {
        
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:path];
        [_webUploader startWithPort:80 bonjourName:nil];
    }
    
    if (webDav) {
        _davServer = [[GCDWebDAVServer alloc] initWithUploadDirectory:path];
        [_davServer startWithPort:443 bonjourName:nil];
    }

}


- (void)saveDictionary:(NSDictionary *)dict{
    [dict writeToFile:[self projectSettingsDictionaryPath] atomically:true];
}


- (NSMutableDictionary *)getProjectSettingsDictionary{
    
    NSString *settingsFilePath = [self projectSettingsDictionaryPath];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:settingsFilePath];
    
    if (fileExists) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:settingsFilePath];
        return dict;
    }
    else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [self saveDictionary:dict];
        return dict;
    }
    
}


- (NSString *)projectSettingsDictionaryPath{
    return [[self projectSettingsPath] stringByAppendingPathComponent:@"settings.cnSettings"];
}




#pragma mark - Private - Encryption

- (NSData *)encryptData:(NSString *)string forKey:(NSString *)key{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:key
                                               error:&error];
    
    #ifdef DEBUG
    if (error) {
        NSLog(@"[Polaris] ERROR: An unexpected error happened: %@",[error localizedDescription]);
    }
    #endif
    
    
    return encryptedData;
}

- (NSString *)decryptedData:(NSData *)data forKey:(NSString *)key{
    
    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:data
                                        withPassword:key
                                               error:&error];
    
    if (error) {
        #ifdef DEBUG
        NSLog(@"[Polaris] ERROR: An unexpected error happened: %@",[error localizedDescription]);
        #endif
        return nil;
    }
    else{
        NSString *string = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
        return string;
    }
    
}


- (NSString *)privateProjectVersion{
    if (!initWithProjectCreator) {
        NSString *version = [NSString stringWithFormat:@"%@.0", [self getSettingsDataForKey:@"version"]];
        
        #ifdef DEBUG
        if (version.length == 0) {
            NSLog(@"[Polaris] Warning: There's no version saved. Save a version for key:'Version'");
        }
        #endif
        
        return version;
    }
    else{
        return nil;
    }
    
}

@end

