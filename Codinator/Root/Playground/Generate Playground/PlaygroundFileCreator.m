//
//  PlaygroundFileCreator.m
//  Codinator
//
//  Created by Vladimir Danila on 22/03/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

#import "PlaygroundFileCreator.h"
#import "AppDelegate.h"
#import "Polaris.h"

@implementation PlaygroundFileCreator

+ (NSURL *)fileUrlForPlaygroundWithName:(NSString *)fileName {
    //Root Path
    NSString *root = [AppDelegate storagePath];
    
    //Paths
    NSString *playgroudPaths = [root stringByAppendingPathComponent:@"Playground"];
    NSURL *fileUrl = [NSURL fileURLWithPath:[playgroudPaths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cnPlay", fileName]]];

    return fileUrl;
}


+ (PlaygroundDocument *)generatePlaygroundFileWithName:(NSString *)fileName {
    
    NSURL *fileUrl = [PlaygroundFileCreator fileUrlForPlaygroundWithName:fileName];
    
    PlaygroundDocument *document = [[PlaygroundDocument alloc] initWithFileURL:fileUrl];
    [document saveToURL:fileUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:nil];
    
    
    
    NSString *html = [NSString stringWithFormat:
                      @"START \n\
                      HEAD() \n\
                      TITLE(\"%@\")TITLE \n\
                      META(name: \"viewport\", content: \"width=device-width\", initialScale: 1)\n\
                      DESCRIPTION(\"A simple webpage written in Neuron\")         \n\
                      AUTHOR(\"YOUR NAME\")    \n\
                      IMPORT(CSS)   \n\
                      IMPORT(JS)    \n\
                      ()HEAD \n\
                      BODY() \n\
                      \n\
                      H1(\"%@\")H1 \n\
                      P(\"Hello world\")P   \n\
                      \n\
                      ()BODY \n\
                      END" ,fileName, fileName];
    
    [document.contents addObject:html];
    
    
    
    NSString *css = [NSString stringWithFormat:
                     @"/* Normalize.css brings consistency to browsers. \n\
                        https://github.com/necolas/normalize.css */ \n\
                     \n\
                     @import url(http://cdn.jsdelivr.net/normalize/2.1.3/normalize.min.css); \n\
                     \n\
                     /* A fresh start */"];
    
    
    [document.contents addObject:css];
    
    
    
    NSString *js = [NSString stringWithFormat:
                    @"//JS file \n\
                    "];
    
    [document.contents addObject:js];
    
    return document;
    
}



@end
