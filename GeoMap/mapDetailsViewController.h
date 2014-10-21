//
//  mapDetailsViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/16/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"

@interface mapDetailsViewController : UIViewController<MKMapViewDelegate>


@property (strong, nonatomic) Annotation *area;

@property (weak, nonatomic) IBOutlet MKMapView *_mapView;

@end
