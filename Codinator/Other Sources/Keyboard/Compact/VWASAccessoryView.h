//

//  VWAS-HTML
//
//  Created by Vladi Danila 2014.
//  Copyright 2014 VWAS-Studios. All rights reserved.
//
@import QuartzCore;
@import CoreImage;

@interface VWASAccessoryView : UIVisualEffectView {
    UITextView *textView_;

}

- (instancetype)initWithTextView:(UITextView *)textView NS_DESIGNATED_INITIALIZER;

- (void)insertDidPush:(UIButton *)button;
- (void)tabDidPush;
- (void)backSpace:(NSString *)string;

//TODO
//- (void)escapeDidPush;
//- (void)unescapeDidPush;

@end
