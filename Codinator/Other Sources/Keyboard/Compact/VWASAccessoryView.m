//

//  VWAS-HTML
//
//  Created by Vladi Danila 2014.
//  Copyright 2014 VWAS-Studios. All rights reserved.
//

#import "VWASAccessoryView.h"

@implementation VWASAccessoryView
@class TKDInteractiveTextColoringTextStorage;





- (instancetype)initWithTextView:(UITextView *)textView {
	if (self = [super init]) {
		
		textView_ = textView;
        textView_.autocorrectionType = UITextAutocorrectionTypeNo;
        textView_.autocapitalizationType = UITextAutocapitalizationTypeNone;
        


        
		NSArray *titles = @[@"➡️", @"<", @">", @"\"",@"/",@"@",@"=",@"!",@":",@"&",@"-",@"."];
		
		
		NSInteger padding = 0;
		NSInteger margin = 10.1;
		NSInteger size = 50;
        
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self = [self initWithEffect:blurEffect];
        self.frame = CGRectMake(0, 0, textView.frame.size.width + 90, size);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        
            
            //create UIImage from filtered image
            

		scrollView.contentSize = CGSizeMake((size + margin) * titles.count, size);
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [self.contentView addSubview:scrollView];
        
		NSInteger i = 0;
		for (NSString *title in titles) {

			UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

			if (i < 14) {
				button.frame = CGRectMake((size + margin) * i + padding, padding, size, size);
			}
			else {
				button.frame = CGRectMake((size + margin) * i + padding + padding + padding, padding, size, size);
			}
			
			
			button.titleLabel.font = [UIFont systemFontOfSize: 17];
			[button setTitle:title forState:UIControlStateNormal];
			
			if ([title isEqualToString:@"➡️"] != YES) {
				[button addTarget:self action:@selector(insertDidPush:) forControlEvents:UIControlEventTouchUpInside];				
			} 
			else {
				
                
                [button addTarget:self action:@selector(tabDidPush) forControlEvents:UIControlEventTouchUpInside];
			}
			
           
            
			[scrollView addSubview:button];
			i++;
            
            
            
            

            textView_.keyboardAppearance = UIKeyboardAppearanceDark;
            button.tintColor = [UIColor whiteColor];
        }
            
    }
    
        

	return self;
}

- (void)insertDidPush:(UIButton *)button {
    
    [textView_ insertText:button.titleLabel.text];
    [[textView_ undoManager] removeAllActions];

}



- (void)tabDidPush {
     [textView_ insertText:@"    "];
    
    
}


- (void)backSpace:(NSString *)string {
	
	NSMutableString *text = [textView_.text mutableCopy];
	
	
	NSRange range = textView_.selectedRange;
	textView_.selectedRange = NSMakeRange(range.location - 1, 1);
	[text replaceCharactersInRange:textView_.selectedRange withString:@""];
	textView_.text = text;
	
	textView_.selectedRange = NSMakeRange(range.location - 1, range.length);
	

    
}





@end
