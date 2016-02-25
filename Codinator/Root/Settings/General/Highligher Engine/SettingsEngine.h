//
//  SyntaxEngine.h
//  Codinator
//
//  Created by Vladimir Danila on 2/25/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsEngine : NSObject

+ (void)restoreSyntaxSettings;
+ (void)reloadSyntaxLayers;
+ (void)restoreServerSettings;

@end
