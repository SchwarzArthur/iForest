//
//  WeatherViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 9/21/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"

@interface WeatherViewController : UIViewController <MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate> {
    
    JFWeatherManager *weatherManager;
    NSMutableArray *tableViewContents;
}

@property (weak, nonatomic) IBOutlet UITableView *___tableView;
@property (weak, nonatomic) IBOutlet MKMapView *___mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;

@property (strong, nonatomic) NSString *weatherGEOHASH;
@property (strong, nonatomic) NSString *weatherLATITUDE;
@property (strong, nonatomic) NSString *weatherLONGITUDE;
@property (strong, nonatomic) NSString *weatherMLS;

@end
