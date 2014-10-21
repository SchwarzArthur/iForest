//
//  WebPDFViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 5/11/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface WebPDFViewController : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (strong, nonatomic) NSURL *url;

@end
