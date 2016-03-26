//
//  ProjectCollectionViewCell.m
//  Codinator
//
//  Created by Vladimir Danila on 09/07/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import "ProjectCollectionViewCell.h"



@implementation ProjectCollectionViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.document.layer.shadowColor = [UIColor blackColor].CGColor;
    self.document.layer.shadowRadius = 4.0;
    self.document.layer.shadowOpacity = 0.7;
    self.document.layer.shadowOffset = CGSizeMake(0, 2);
}

@end
