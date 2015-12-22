//
//  ProjectTableViewCell.m
//  Codinator
//
//  Created by Vladimir Danila on 12/09/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor blackColor]];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
    self.artView.backgroundColor = [UIColor colorWithRed:0.06 green:0.00 blue:0.10 alpha:1.0];
    
}


@end
