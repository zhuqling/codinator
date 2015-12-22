//
//  UnArchivingViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 26/04/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "SSZipArchive.h"

@interface UnArchivingViewController : UIViewController <SSZipArchiveDelegate>{
    
    IBOutlet UIProgressView *progressView;
}

@property (nonatomic, strong)NSString* filePathToZipFile;

@end
