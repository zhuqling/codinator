//
//  HistoryWebViewController.h
//  VWAS-HTML
//
//  Created by Vladimir on 20/03/15.
//  Copyright (c) 2015 Vladimir Danila. All rights reserved.
//


@interface HistoryWebViewController : UIViewController{
    
    IBOutlet UIWebView *webView;
    __weak IBOutlet UIButton *closeButton;
}

@property (nonatomic, strong) NSString *path;

@end
