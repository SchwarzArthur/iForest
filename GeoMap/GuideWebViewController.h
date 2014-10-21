//
//  GuideWebViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 10/19/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface GuideWebViewController : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (strong, nonatomic) NSURL *url;

@end
