//
//  IndividualStepViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 4/14/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IndividualStepViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *_instructionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *_distanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *_mapView;

@property (strong, nonatomic) MKRouteStep *routeStep;
@property (assign, nonatomic) NSUInteger stepIndex;

@end
