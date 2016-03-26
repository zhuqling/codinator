//
//  ProjectCollectionViewCell.h
//  Codinator
//
//  Created by Vladimir Danila on 09/07/15.
//  Copyright © 2015 Vladimir Danila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCollectionViewCell : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *labelHolder;
@property (weak, nonatomic) IBOutlet UIView *document;


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


@end
