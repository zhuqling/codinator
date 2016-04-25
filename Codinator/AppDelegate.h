//
//  AppDelegate.h
//  Codinator
//
//  Created by Vladimir Danila on 24/10/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thumbnail.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFileManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) Thumbnail *thumbnailManager;
@property (nonatomic, strong) NSString *storagePath;
+ (NSString *)storagePath;


@end

