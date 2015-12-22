//
//  PulseViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 14/05/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "Polaris.h"


@interface PulseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;


@property (strong,nonatomic) Polaris *projectManager;


@end
