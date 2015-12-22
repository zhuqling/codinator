//
//  HistoryRow.m
//  VWAS-HTML
//
//  Created by Vladimir on 19/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "HistoryRow.h"

@implementation HistoryRow


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor blackColor];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}


@end
