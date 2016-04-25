//
//  FileTemplates.h
//  Codinator
//
//  Created by Vladimir Danila on 21/04/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTemplates : NSObject


+ (NSString *)htmlTemplateFileForName:(NSString *)name;
+ (NSString *)cssTemplateFile;
+ (NSString *)jsTemplateFile;
+ (NSString *)txtTemplateFile;
+ (NSString *)phpTemplateFile;

@end
