//
//  CLImageEditorTheme.m
//
//  Created by sho yakushiji on 2013/12/05.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageEditorTheme.h"

@implementation CLImageEditorTheme

#pragma mark - singleton pattern

static CLImageEditorTheme *_sharedInstance = nil;

+ (CLImageEditorTheme*)theme
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CLImageEditorTheme alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

- (id)init
{
    self = [super init];
    if (self) {
        self.bundleName                     = @"CLImageEditor";
        self.backgroundColor                = RGB(20, 20, 20);
        self.toolbarColor                   = [UIColor darkGrayColor];
		self.toolIconColor                  = @"white";
        self.toolbarTextColor               = [UIColor lightGrayColor];
        self.toolbarSelectedButtonColor     = [[UIColor purpleColor] colorWithAlphaComponent:0.5 ];
        self.toolbarTextFont                = [UIFont systemFontOfSize:10];
        
    }
    return self;
}

@end
