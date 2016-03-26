//
//  QEDTextView.m
//  CYRTextViewExample
//
//  Created by Illya Busigin on 1/10/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

@import CoreText;


#import "QEDTextView.h"

#import "NSUserDefaults+Additions.h"


#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@implementation QEDTextView

#pragma mark - Initialization & Setup

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonSetup];
    }
    
    return self;
}

- (void)commonSetup
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _defaultFont = [userDefaults fontForKey:@"Font: 0"];
    _italicFont = [userDefaults fontForKey:@"Font: 1"];
    _boldFont = [userDefaults fontForKey:@"Font: 2"];
    
    self.font = _defaultFont;
    self.textColor = [UIColor whiteColor];
 


    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont)) options:NSKeyValueObservingOptionNew context:0];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont)) options:NSKeyValueObservingOptionNew context:0];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont)) options:NSKeyValueObservingOptionNew context:0];
    

    self.tokens = [self solverTokens];
}


- (NSArray *)solverTokens
{
    
    NSArray *solverTokens =  @[
                           
                                [CYRToken tokenWithName:@"Tag"
                                                expression:[self macroForKey:3]
                                                attributes:[self dictionaryForKey:3]
                                ],
                            
                            
                                [CYRToken tokenWithName:@"square_brackets"
                                                    expression:[self macroForKey:4]
                                                    attributes:[self dictionaryForKey:4]
                                ],

                                [CYRToken tokenWithName:@"reserved_words"
                                            expression:[self macroForKey:5]
                                            attributes:[self dictionaryForKey:5]
                                ],
                            
                                [CYRToken tokenWithName:@"string"
                                            expression:[self macroForKey:6]
                                            attributes:[self dictionaryForKey:6]
                                 ]
                            

                            
                            ];
    
    return solverTokens;
}


#pragma mark - Private API


- (NSDictionary *)dictionaryForKey:(NSInteger)selectedType{
    
    NSString *key = [NSString stringWithFormat:@"Macro:%li Attribute",(long)selectedType];
    
    return [[NSUserDefaults standardUserDefaults] dicForKey:key];
    
}


- (NSString *)macroForKey:(NSInteger)selectedType{
    
    NSString *key = [NSString stringWithFormat:@"Macro:%li",(long)selectedType];
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}


#pragma mark - Cleanup

- (void)dealloc
{
    //[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont))];
    //[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont))];
    //[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont))];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(defaultFont))] ||
        [keyPath isEqualToString:NSStringFromSelector(@selector(boldFont))] ||
        [keyPath isEqualToString:NSStringFromSelector(@selector(italicFont))])
    {
        // Reset the tokens, this will clear any existing formatting
        self.tokens = [self solverTokens];
    }
    else
    {
        //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}





@end
