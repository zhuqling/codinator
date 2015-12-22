//
//  ProjectCollectionViewCell.m
//  Codinator
//
//  Created by Vladimir Danila on 09/07/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import "ProjectCollectionViewCell.h"



@implementation ProjectCollectionViewCell


- (void)awakeFromNib{

    self.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}


@end
