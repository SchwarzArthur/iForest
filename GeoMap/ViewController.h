//
//  ViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//
#define TransparentColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];//0.9
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LeveyPopListView.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "RecordTables.h"
#import "ASValueTrackingSlider.h"
#import "WMOverlay.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "btSimpleSideMenu.h"
#import "AMDraggableBlurView.h"
#import "GuideViewController.h"

#define kForestURL @"http://rfdgeoinfo.servebeer.com/NRFApplicationSchwarzKiserz_iOS7/GEOJSON/FOREST55_56"
#define kWatershadURL @"http://rfdgeoinfo.servebeer.com/NRFApplicationSchwarzKiserz_iOS7/GEOJSON/WATERSHAD"
#define kAmphoeURL @"http://rfdgeoinfo.servebeer.com/NRFApplicationSchwarzKiserz_iOS7/GEOJSON/AMPHOE"
#define kOtherLayerURL @"http://rfdgeoinfo.servebeer.com/NRFApplicationSchwarzKiserz_iOS7/GEOJSON"//http://schwarzarthur.bugs3.com/iForestLayer/

typedef enum {
    TBL_CELL_NONE,
    TBL_DIRECTION_CELL,
    TBL_ADDPIN_CELL
    
}TABLE_CELL_DISPLAY_TYPE;

typedef enum {
    ROUTE_END_START,
    ROUTE_START_END
    
}ROUTE_SWITCH_TYPE;

typedef enum {
    DIGITIZE_POLYGON,
    DIGITIZE_POLYLINE
    
}DIGITIZE_TYPE;

typedef enum {
    ROUTE_FROM_TABLE,
    ROUTE_FROM_BAR
    
}ROUTE_FROM;

typedef enum {
    LAYER_OPTIONS, //NRF
    LAYER_OPTIONS_FOREST,
    LAYER_OPTIONS_WATERSHAD,
    LAYER_OPTIONS_AMPHOE
    
}LAYER;

@class RecordTables;

@interface ViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,LeveyPopListViewDelegate,UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, NSFetchedResultsControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,btSimpleSideMenuDelegate>{

    MKCircle *circle;
}
@property (assign, nonatomic) MKMapType mapType;
@property (assign, nonatomic) WMMapSource mapSource;
@property (assign, nonatomic) BOOL useClustering;

@property (strong, nonatomic) NSURL *urlDelegate;
@property (strong, nonatomic) NSString *nameDelegate;
@property (strong, nonatomic) NSString *provinceDelegate;
@property (strong, nonatomic) NSString *urlDelegateLayer;

@property (assign, nonatomic) CLLocationCoordinate2D setRegion;

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) CLLocation *userLocation;

@property (nonatomic, strong) IBOutlet UIButton *elaserAreaButton;
@property (nonatomic, strong) IBOutlet UIButton *mapChageButton;
@property (nonatomic, strong) IBOutlet UIButton *listChageButton;

@property (nonatomic, strong) IBOutlet AMDraggableBlurView *SwitchContainer;

@property(nonatomic)btSimpleSideMenu *sideMenu;

@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *easting_x;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *northing_y;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *gridZone;
@property (nonatomic, strong) IBOutlet UIView *div1;
@property (nonatomic, strong) IBOutlet UIView *div2;
@property (nonatomic, strong) IBOutlet UIView *div3;
@property (nonatomic, strong) IBOutlet UILabel *searchText;
@property (nonatomic, strong) IBOutlet UILabel *searchCoordinate;
@property (nonatomic, strong) IBOutlet UILabel *hemisphere;
@property (nonatomic, strong) IBOutlet UIButton *toLocationButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *SearchChangedSegmentedControl;

@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *nameField;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *pinTypeField;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextView *descriptionField;
@property (nonatomic, strong) IBOutlet UIView *div_pin1;
@property (nonatomic, strong) IBOutlet UIView *div_pin2;
@property (nonatomic, strong) IBOutlet UILabel *centerMap;
@property (nonatomic, strong) IBOutlet UILabel *fromCoordinate;
@property (nonatomic, strong) IBOutlet UIButton *toAddPinDatabaseButton;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *addImage;

@property (strong, nonatomic) IBOutlet UISegmentedControl *addCoordinateSegmentedControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *convertCoordinateSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *hemisphereSegmentedControl;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *mapChangedSegmentedControl;
//@property (strong, nonatomic) IBOutlet UISwitch *onOffCluster;

@property (nonatomic, strong) IBOutlet UIView *viewGesture;

@property (strong, nonatomic) NSString *urlConnect;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSArray *optionsForest;
@property (strong, nonatomic) NSArray *optionsWatershad;
@property (strong, nonatomic) NSArray *optionsAmphoe;

@property (strong, nonatomic) NSMutableArray *_areas;

//@property(nonatomic, strong) RecordTables *record;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISwitch *switchUpdateIfExist;

@property (strong, nonatomic) IBOutlet UISegmentedControl *routeDirectionChangedSegmentedControl;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *startField;
@property (nonatomic, strong) IBOutlet JVFloatLabeledTextField *endField;
@property (nonatomic, strong) IBOutlet UIButton *routeChagePositionButton;
@property (nonatomic, strong) IBOutlet UIButton *stepRoute;
@property (nonatomic, strong) IBOutlet UIButton *elaserRoute;
@property (nonatomic, strong) IBOutlet UILabel *routeDistance;
@property (nonatomic, strong) IBOutlet UILabel *routeDirection;

@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *_radiusSlider;
@property (nonatomic, strong) IBOutlet UIButton *elaserBufferZone;

@property (nonatomic, strong) IBOutlet UILabel *listOfPin;
@property (nonatomic, strong) IBOutlet UIButton *db;

@property (nonatomic, strong) IBOutlet UIButton *addDigitize;
@property (nonatomic, strong) IBOutlet UIButton *addDigitize_polyline;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinateDigitize;
@property (nonatomic) float zoomscaleDigitize;
@property (nonatomic) NSString *currentPolygonTitleDigitize;
@property (nonatomic, strong) NSMutableArray *dictionaryOfPolygonsDigitize;
@property (nonatomic, strong) NSMutableArray *pathDigitize;
@property (nonatomic, strong) MKCircle *circleDigitize;
@property (nonatomic, strong) MKPolyline *polylineDigitize;
@property (nonatomic, strong) MKPolygonRenderer *polygonViewDigitize;
@property (nonatomic, strong) MKCircleRenderer *pointCircleViewDigitize;
@property (nonatomic, strong) MKPolylineRenderer *polygonBorderViewDigitize;
@property (nonatomic, strong) MKPolygonRenderer *intersectedPolygonViewDigitize;
@property (nonatomic, strong) MKPolygon *polygonDigitize;
@property (nonatomic, strong) MKPolygon *intersectedPolygonDigitize;

@property (strong, nonatomic) CLLocationManager *locationManager;


- (void)addGestureRecogniserToMapView;
- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer;

@end