//
//  PlaygroundTextView.m
//  Codinator
//
//  Created by Vladimir Danila on 25/06/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import "PlaygroundTextView.h"
#import "NSUserDefaults+Additions.h"



@implementation PlaygroundTextView


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

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]



- (NSArray *)solverTokens
{
    
    NSArray *solverTokens =  @[
                               
                               
                               [CYRToken tokenWithName:@"square_brackets"
                                            expression:@"(HTML|START|END|KEYWORDS|ROBOTS|DESCRIPTION|AUTHOR|TITLE|VIEWPORT|VIEWPORT|HEAD|BODY|H1|LINK|META|H2|H3|H4|H5|H6|P|BR|TABLE|TR|TD|CODE|UL|IMPORT|B|I|LI)"
                                            attributes:@{
                                                         NSForegroundColorAttributeName : [UIColor orangeColor],
                                                         NSFontAttributeName : [self loadFontWithKey:0]
                                                         }
                                ],
                               
                               
                               [CYRToken tokenWithName:@"Tag"
                                            expression:@"<.*?(>)"
                                            attributes:@{
                                                         NSForegroundColorAttributeName : [UIColor redColor],
                                                         NSFontAttributeName : [self loadFontWithKey:0]
                                                         }
                                ],
                               
                               
                               
                               [CYRToken tokenWithName:@"reserved_words"
                                            expression:@"(algin|width|height|color|text|border|bgcolor|description|name|content|href|src|initialScale|charset|class|role|id|<!DOCTYPE html>|border)"
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



- (UIFont *)loadFontWithKey:(NSInteger)index{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Font: %li", (long)index];
    
    
    return [userDefaults fontForKey:key];
    
}


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
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(defaultFont))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(boldFont))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(italicFont))];
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
