//
//  addPinDetailViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 2/21/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddAnnotation.h"
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"

@class RecordTables;

@interface AddPinDetailViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>
{
    JFWeatherManager *weatherManager;
    NSMutableArray *tableViewContents;
}
@property (strong, nonatomic) AddAnnotation *pin;

@property(nonatomic, strong) RecordTables *record;

@property (weak, nonatomic) IBOutlet UITableView *___tableView;
@property (weak, nonatomic) IBOutlet MKMapView *___mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;

@property (nonatomic, strong) IBOutlet UIButton *_DistanceLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *_mapTypeSegmentedControl;

@property (nonatomic, strong) IBOutlet UIView *div;
@end
