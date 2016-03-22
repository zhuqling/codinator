//
//  PlaygroundFileCreator.h
//  Codinator
//
//  Created by Vladimir Danila on 22/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaygroundDocument.h"


@interface PlaygroundFileCreator : NSObject


+ (NSURL *)fileUrlForPlaygroundWithName:(NSString *)fileName;
+ (PlaygroundDocument *)generatePlaygroundFileWithName:(NSString *)fileName;

@end
