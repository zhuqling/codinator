//
//  JsTextView.h
//  VWAS-HTML
//
//  Created by Vladimir on 20/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "CYRTextView.h"

@interface JsTextView : CYRTextView {
   
    
    NSUInteger size;

}

@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIFont *boldFont;
@property (nonatomic, strong) UIFont *italicFont;

@end
