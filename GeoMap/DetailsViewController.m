//
//  DetailsViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/16/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "DetailsViewController.h"
#import "tableDetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}





- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    tableDetailsViewController *tableDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tableDetailsViewController"];
    
    mapDetailsViewController *mapDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapDetailsViewController"];
    self.delegate = self;
    
    [self setupWithTopViewController:mapDetailsViewController andTopHeight:150 andBottomViewController:tableDetailsViewController];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - QMBParallaxScrollViewControllerDelegate

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state{
    
   // NSLog(@"didChangeState %d",state);
    //[self.navigationController setNavigationBarHidden:self.state == QMBParallaxStateFullSize animated:YES];
    
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeTopHeight:(CGFloat)height{
    
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeGesture:(QMBParallaxGesture)newGesture oldGesture:(QMBParallaxGesture)oldGesture{
    
}
@end

