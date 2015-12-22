//
//  ProjectZipImporterViewController.h
//  Codinator
//
//  Created by Vladimir on 03/06/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//

#import "SSZipArchive.h"

@interface ProjectZipImporterViewController : UIViewController<SSZipArchiveDelegate>{

    IBOutlet UIProgressView *progressView;

}

@property (nonatomic, strong) NSString* projectsPath;
@property (nonatomic, strong) NSString* filePathToZipFile;


@end
