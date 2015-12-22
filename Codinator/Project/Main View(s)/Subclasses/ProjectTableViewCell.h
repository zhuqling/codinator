//
//  ProjectTableViewCell.h
//  Codinator
//
//  Created by Vladimir Danila on 12/09/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UIView *artView;


@end
