//
//  WUTextSuggestionDisplayController.h
//  WUTextSuggestionController
//
//  Created by YuAo on 5/11/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUTextSuggestionController.h"

@interface WUTextSuggestionDisplayItem : NSObject

@property (nonatomic,copy,readonly)  NSString *title;
@property (nonatomic,copy)           void     (^customActionBlock)(WUTextSuggestionType suggestionType, NSString *suggestionQuery, NSRange suggestionRange);

- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;

@end


@protocol WUTextSuggestionDisplayControllerDataSource;

@interface WUTextSuggestionDisplayController : NSObject

@property (nonatomic,weak) id<WUTextSuggestionDisplayControllerDataSource> dataSource;

- (void)beginSuggestingForTextView:(UITextView *)textView;

- (void)endSuggesting;

- (void)reloadSuggestionsWithType:(WUTextSuggestionType)suggestionType query:(NSString *)suggestionQuery range:(NSRange)suggestionRange;

@end


@protocol WUTextSuggestionDisplayControllerDataSource <NSObject>

@optional

//Sync
- (NSArray *)textSuggestionDisplayController:(WUTextSuggestionDisplayController *)textSuggestionDisplayController
     suggestionDisplayItemsForSuggestionType:(WUTextSuggestionType)suggestionType
                                       query:(NSString *)suggestionQuery;

//Async
- (void)textSuggestionDisplayController:(WUTextSuggestionDisplayController *)textSuggestionDisplayController
suggestionDisplayItemsForSuggestionType:(WUTextSuggestionType)suggestionType
                                  query:(NSString *)suggestionQuery
                               callback:(void (^)(NSArray *suggestionDisplayItems))gotSuggestionDisplayItemsBlock;

@end


@interface WUTextSuggestionController (WUTextSuggestionDisplayController)

- (instancetype)initWithTextView:(UITextView *)textView suggestionDisplayController:(WUTextSuggestionDisplayController *)suggestionDisplayController;

@end
