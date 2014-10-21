//
//  DetailDatabaseViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 3/28/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

@class RecordTables;

@interface DetailDatabaseViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    JFWeatherManager *weatherManager;
    NSMutableArray *tableViewContents;
}

@property(nonatomic, strong) RecordTables *record;

@property (weak, nonatomic) IBOutlet UITableView *___tableView;
@property (weak, nonatomic) IBOutlet MKMapView *___mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;

@property (nonatomic, strong) IBOutlet UIButton *_DistanceLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *_mapTypeSegmentedControl;

@property (nonatomic, strong) IBOutlet UIView *div;

@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *nameField;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *pinTypeField;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextView *descriptionField;

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *addImage;
@property (nonatomic, strong) IBOutlet UIView *coverImage;

@end
