//
//  PlaygroundDocument.m
//  Codinator
//
//  Created by Vladimir Danila on 22/07/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import "PlaygroundDocument.h"

@implementation PlaygroundDocument
@synthesize contents = _contents;



- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if (!self.contents) {
        self.contents = [[NSMutableArray alloc] init];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contents];
    return data;
}


- (id)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        self.contents = [[NSMutableArray alloc] init];
    }
    return self;
}


- (BOOL)loadFromContents:(id)fileContents ofType:(NSString *)typeName error:(NSError **)outError {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        if ([fileContents length] > 0) {
            self.contents = [NSKeyedUnarchiver unarchiveObjectWithData:fileContents];
        } else {
            self.contents = [[NSMutableArray alloc] init];
        }
    });
    
    return YES;
}


@end
