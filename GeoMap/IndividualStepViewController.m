//
//  IndividualStepViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 4/14/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "IndividualStepViewController.h"

@interface IndividualStepViewController ()<MKMapViewDelegate>
@end

@implementation IndividualStepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    __mapView.delegate = self;
    [__mapView addOverlay:self.routeStep.polyline];
    [__mapView setVisibleMapRect:self.routeStep.polyline.boundingMapRect animated:NO];
    __instructionsTextView.text = self.routeStep.instructions;
    self.navigationItem.title = [NSString stringWithFormat:@"Step %02lu", (unsigned long)_stepIndex];
    __distanceLabel.text = [NSString stringWithFormat:@"%0.2f km", _routeStep.distance / 1000.0];
}

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    polylineRenderer.strokeColor = [[UIColor redColor]colorWithAlphaComponent:0.7];
    polylineRenderer.lineJoin = kCGLineJoinRound;
    polylineRenderer.lineCap = kCGLineCapRound;
    polylineRenderer.lineWidth = 5.0f;
    
    return polylineRenderer;
}

@end
