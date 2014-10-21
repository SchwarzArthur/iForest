//
//  DetailsViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/16/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"
#import "mapDetailsViewController.h"
#import "Annotation.h"

@interface DetailsViewController : QMBParallaxScrollViewController<QMBParallaxScrollViewControllerDelegate>

@property (strong, nonatomic) Annotation *area;

@end
