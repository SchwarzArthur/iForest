//
//  ViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "DetailViewController.h"
#import "CurlViewController.h"
#import "Annotation.h"
#import "PinViewNRF.h"
#import "PinViewIndex.h"
#import "PinViewNP.h"
#import "PinViewNHA.h"
#import "PinViewWLS.h"
#import "PinViewFP.h"
#import "PinViewCommunityForest.h"
#import "PinViewMF.h"
#import "PinViewProvince.h"
#import "PinViewAmphoe.h"
#import "PinViewTambon.h"
#import "DigitizePinView.h"
#import "QTree.h"
#import "QCluster.h"
#import "ClusterAnnotationView.h"
#import "CSNotificationView.h"
#import "MZLoadingCircle.h"
#import "SVBlurView.h"
#import "HATransparentView.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "GeodeticUTMConverter.h"
#import "AddAnnotation.h"
#import "AddPinDetailViewController.h"
#import "MyDatabaseManager.h"
#import "IQDatabaseManager.h"
#import "NotQTree.h"
#import "DetailDatabaseViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "AFNetworking.h"
#import "PlacemarkAnnotation.h"
#import "StepRouteViewController.h"
#import "BFNavigationBarDrawer.h"
#import "ASValueTrackingSlider.h"
#import "GeoJSONSerialization.h"
#import "AHKActionSheet.h"
#import "MKPolygon+GSPolygonIntersections.h"
#import <QuartzCore/QuartzCore.h>
#import "WMOverlay.h"
#import "WMOverlayView.h"
#import "MCSwipeTableViewCell.h"
#import "GuideViewController.h"
#import "OtherLayerGeoJSONSerialization.h"
#import "OtherLayerAnnotation.h"
#import "GSIndeterminateProgressView.h"
#import "AboutViewController.h"

static inline CLLocationCoordinate2D CLLocationCoordinateFromCoordinates(NSArray *coordinates) {
    NSCParameterAssert(coordinates && [coordinates count] == 2);
    /*    NSNumber *longitude = [coordinates objectAtIndex:0];//[coordinates firstObject];
     NSNumber *latitude = [coordinates objectAtIndex:1];
     
     return CLLocationCoordinate2DMake(CLLocationCoordinateNormalizedLatitude([latitude doubleValue]), CLLocationCoordinateNormalizedLongitude([longitude doubleValue]));
     // return CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
     }*/
    NSNumber *longitude = [coordinates objectAtIndex:0];//[coordinates firstObject];
    NSNumber *latitude = [coordinates objectAtIndex:1];
    
    UTMCoordinates coordinatess;
    coordinatess.gridZone = 47;
    coordinatess.northing = [latitude doubleValue];
    coordinatess.easting = [longitude doubleValue];
    coordinatess.hemisphere = kUTMHemisphereNorthern;
    
    GeodeticUTMConverter *converter = [[GeodeticUTMConverter alloc] init];
    CLLocationCoordinate2D addCoordinate = [converter UTMCoordinatesToLatitudeAndLongitude:coordinatess];
    
    return CLLocationCoordinate2DMake(addCoordinate.latitude, addCoordinate.longitude);
}

static inline CLLocationCoordinate2D * CLLocationCoordinatesFromCoordinatePairs(NSArray *coordinatePairs) {
    NSUInteger count = [coordinatePairs count];
    CLLocationCoordinate2D *locationCoordinates = malloc(sizeof(CLLocationCoordinate2D) * count);
    for (NSUInteger idx = 0; idx < count; idx++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinateFromCoordinates(coordinatePairs[idx]);
        locationCoordinates[idx] = coordinate;
    }
    
    return locationCoordinates;
}


const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 10.0f;
const static CGFloat kJVFieldFontSize = 16.0f;
const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface ViewController ()<MCSwipeTableViewCellDelegate,CurlViewControllerDelegate,LeveyPopListViewDelegate,UITextFieldDelegate,WYPopoverControllerDelegate,GuideWebViewControllerDelegate>
{
    __weak IBOutlet MKMapView *_mapView;
    __weak IBOutlet UIView *_containerView;
    
    IBOutlet UISwitch *onOffSwitch;
    
    SVBlurView *blurView;
    
    //NSMutableArray *__areas;
    ListViewController *__listViewController;
    
    MKPointAnnotation *toAdd;
    
    MZLoadingCircle *loadingCircle;
    
    NSMutableArray *__pins;
    
    NSMutableArray *pinRecords;
    
    NSMutableArray *pinPolygon;
    
    NSArray *records;
    NSArray *filteredRecords;
    RecordTables *selectedRecord;
    NSString *sortingAttribute;
    
    NSArray *locations;
 
    WYPopoverController *detailDatabasePopoverController;
    WYPopoverController *addPinDetailPopoverController;
    WYPopoverController *detailPopoverController;
    WYPopoverController *stepRoutePopoverController;
    WYPopoverController *listAndSearchPopoverController;
    WYPopoverController *aboutPopoverController;
    
    TABLE_CELL_DISPLAY_TYPE cell_type_to_display;
    ROUTE_SWITCH_TYPE route_type;
    DIGITIZE_TYPE digitize_type;
    ROUTE_FROM route_from;
    LAYER layer;

    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    
    BFNavigationBarDrawer *drawer;
    
    float radius;
    
    UILongPressGestureRecognizer *lpgr;
    
    UITapGestureRecognizer *mapTapRecognizer;
    CLLocationCoordinate2D *coordsDigitize;
    BOOL addingShape;
    BOOL canAddPoints;
    
    UIImage *image;
    NSData *dataImage;
    UIImagePickerController *imagePicker;
    
    UIImage *imageListPin;
    NSString *stringListPin;
 
    GSIndeterminateProgressView *_progressView;
}

@property (nonatomic, strong) MCSwipeTableViewCell *cellToDelete;

-(void)drawCircleWithCoordinate:(CLLocationCoordinate2D)coord;
-(void)drawPolygonBorder;

-(void)deleteAllRecords:(id)sender;
-(void)ShowActionSheet:(id)sender;

- (IBAction)mapChage:(id)sender;
- (IBAction)listChage:(id)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@property(nonatomic, strong) QTree* qTree;
@property (strong, nonatomic) HATransparentView *transparentView;
@property (nonatomic) NSInteger selected;

@property(nonatomic, strong) NotQTree* notQTree;

@property (strong, nonatomic) WMOverlay *overlayGoogle;
@end

#define CELL_HEIGHT 50

@implementation ViewController

@synthesize sideMenu;

@synthesize options = _options;

CLLocationCoordinate2D circleCoordinate;

#pragma mark -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
         _dimView.alpha = 0.7f;
     } completion:nil];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (self.notQTree == nil) {
        self.notQTree = [NotQTree new];
    } else {
        
    }
 /*   NSArray *annotations = _mapView.annotations;
    for (id annotation in annotations) {
        if (annotation != _mapView.userLocation) {
            [_mapView removeAnnotation:annotation];
        }
    }*/
    [_progressView startAnimating];//---[self showLoadingMode];
    
    //SVBlurView *blurView = [[SVBlurView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_mapView addSubview:blurView];
    
    [self setTitle:@"Searching..."];
    
    NSString *searchString = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *status = [responseObject valueForKeyPath:@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [responseObject valueForKeyPath:@"results"];
            NSInteger index = 0;
            for (id result in results) {
                CLLocationCoordinate2D coord = [self coordinateFromJSON:result];
                NSDictionary *addressDictionary = [self addressDictionaryFromJSON:result];
                if (index == 0) {
                    [_mapView setCenterCoordinate:coord animated:NO];
                }
                NSArray *addressLines = [addressDictionary objectForKey:@"FormattedAddressLines"];
                PlacemarkAnnotation *placemark = [[PlacemarkAnnotation alloc] initWithCoordinate:coord addressDictionary:addressDictionary];
                
                if (addressLines) {
                    placemark.title = [addressLines componentsJoinedByString:@", "];
                }
                else {
                    placemark.title = nil;
                }
                GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
                UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:coord];
               
                placemark.subtitle = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];//[NSString stringWithFormat:@"Lat: %.4f , Lon: %.4f",placemark.coordinate.latitude,placemark.coordinate.longitude];
                placemark.addressDictionary = addressDictionary;
                
                [_mapView addAnnotation:placemark];
                [__pins addObject:placemark];
                [self.notQTree insertObject:placemark];
                [self reloadAnnotations];
                self.elaserAreaButton.hidden = NO;
                index++;
                
                [_progressView stopAnimating];
                [self setTitle:@"Map"];//---[self hideLoadingMode];
                [blurView removeFromSuperview];
                
                [CSNotificationView showInViewController:self
                                                   style:CSNotificationViewStyleSuccess
                                                 message:@"Search Complete"];
            }
        }
    } failure:nil];
    [operation start];
    
    [self finishSearch];
}

- (IBAction)dimmingViewTapped:(id)sender {
    [self finishSearch];
}

- (void)finishSearch
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         self.dimView.alpha = 0.0f;
     } completion:nil];
    
    [self.searchBar resignFirstResponder];
    [_transparentView close];
}

- (CLLocationDistance)getDistanceFrom:(CLLocationCoordinate2D)start to:(CLLocationCoordinate2D)end
{
	CLLocation *startLoccation = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
	CLLocation *endLoccation = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    
	return [startLoccation distanceFromLocation:endLoccation];
}

- (CLLocationCoordinate2D)coordinateFromJSON:(id)JSON
{
    NSDictionary *location = [[JSON valueForKey:@"geometry"] valueForKey:@"location"];
    NSNumber *lat = [location valueForKey:@"lat"];
    NSNumber *lng = [location valueForKey:@"lng"];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    return coord;
}

- (NSDictionary *)addressDictionaryFromJSON:(id)JSON
{
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    addressDictionary[@"FormattedAddressLines"] = [((NSString *)[JSON valueForKey:@"formatted_address"]) componentsSeparatedByString:@", "];
    for (id component in [JSON valueForKey:@"address_components"]) {
        NSArray *types = [component valueForKey:@"types"];
        id longName = [component valueForKey:@"long_name"];
        id shortName = [component valueForKey:@"short_name"];
        for (NSString *type in types) {
            if ([type isEqualToString:@"postal_code"]) {
                addressDictionary[@"ZIP"] = longName;
            }
            else if ([type isEqualToString:@"country"]) {
                addressDictionary[@"Country"] = longName;
                addressDictionary[@"CountryCode"] = shortName;
            }
            else if ([type isEqualToString:@"administrative_area_level_1"]) {
                addressDictionary[@"State"] = longName;
            }
            else if ([type isEqualToString:@"administrative_area_level_2"]) {
                addressDictionary[@"SubAdministrativeArea"] = longName;
            }
            else if ([type isEqualToString:@"locality"]) {
                addressDictionary[@"City"] = longName;
            }
            else if ([type isEqualToString:@"sublocality"]) {
                addressDictionary[@"SubLocality"] = longName;
            }
            else if ([type isEqualToString:@"establishment"]) {
                addressDictionary[@"Name"] = longName;
            }
            else if ([type isEqualToString:@"route"]) {
                addressDictionary[@"Thoroughfare"] = longName;
            }
            else if ([type isEqualToString:@"street_number"]) {
                addressDictionary[@"SubThoroughfare"] = longName;
            }
        }
    }
    return addressDictionary;
}

-(void)guideWebViewController:(GuideViewController *)controller name:(NSString *)name province:(NSString *)province urlDelegateLayer:(NSString *)urlDelegateLayer urlDelegate:(NSURL *)urlDelegate {

    self.nameDelegate = name;
    self.provinceDelegate = province;
    self.urlDelegate = urlDelegate;
    self.urlDelegateLayer = urlDelegateLayer;
    
    if (self.qTree == nil) {
        self.qTree = [QTree new];
    } else {
        
    }
    
    _urlConnect = urlDelegateLayer;
    [self layer];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"พื้นที่เป้าหมาย"
                                                      message:@"เลือกพื้นที่ป่าสงวนแห่งชาติที่ต้องการ"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Next", nil];
    [message show];
}
/*-(void)setUrlDelegateLayer:(NSString *)urlDelegateLayer {

    if (self.qTree == nil) {
        self.qTree = [QTree new];
    } else {
        
    }
    
    _urlConnect = urlDelegateLayer;
    [self layer];
}*/


- (void)curlViewController:(CurlViewController *)controller mapTypeChanged:(MKMapType)mapType
{
    self.mapType = mapType;
}

- (void)curlViewController:(CurlViewController *)controller mapSourceChanged:(WMMapSource)mapSource
{
    self.mapSource = mapSource;
}

- (void)refresh {
    [_mapView removeOverlay:_overlayGoogle];
    
    if (_mapSource == WMMapSourceGoogle) {
        
        [self removeOverlayLayer];
        
        self.overlayGoogle = [[WMOverlay alloc] initWithMapType:_mapType];
        [_mapView addOverlay:_overlayGoogle];
    }
}

- (void)removeOverlayLayer {
    
    self.elaserAreaButton.hidden = YES;
    self.SwitchContainer.hidden = YES;
    self.stepRoute.hidden = YES;
    self.routeDistance.hidden = YES;
    self._radiusSlider.hidden = YES;
    self.elaserRoute.hidden = YES;
    self.elaserBufferZone.hidden = YES;
    
    NSArray *pole = [_mapView overlays];
    [_mapView removeOverlays:pole];
    
    NSArray *area = [_mapView annotations];
    [_mapView removeAnnotations:area];
    
    [__areas removeAllObjects];
 
    self.qTree = [QTree new];
    self.notQTree = [NotQTree new];
    
    [self updateLocations];
}

- (void)setMapSource:(WMMapSource)mapSource {
    _mapSource = mapSource;
    
    [self refresh];
}
- (void)setMapType:(MKMapType)mapType {
    _mapType = mapType;
    _mapView.mapType = mapType;
    
    [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    blurView = [[SVBlurView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	self.navigationItem.title = NSLocalizedString(@"Map", nil);
    // self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(show)];
    
    
  //  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.1) {
   
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    GSIndeterminateProgressView *progressView = [[GSIndeterminateProgressView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.size.height - 2,
                                                                                                              navigationBar.frame.size.width, 2)];
    progressView.progressTintColor = navigationBar.barTintColor;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [navigationBar addSubview:progressView];
    
    _progressView = progressView;
    
    [_elaserAreaButton setImage:[UIImage imageNamed:@"clean96.png"] forState:UIControlStateNormal];
    _elaserAreaButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _elaserAreaButton.layer.borderWidth = 1.0f;
    _elaserAreaButton.layer.cornerRadius = 17.0f;
    _elaserAreaButton.layer.masksToBounds = YES;
    _elaserAreaButton.opaque = NO;
    _elaserAreaButton.alpha = .90f;
    [_elaserAreaButton addTarget:self action:@selector(elaserArea) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapView addSubview:_elaserAreaButton];
    
    //_SwitchContainer.backgroundColor = [UIColor blackColor];
    //_SwitchContainer.layer.cornerRadius = 50.0/2;
    //_SwitchContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    //_SwitchContainer.layer.shadowOpacity = 0.2;
    //_SwitchContainer.layer.shadowOffset = CGSizeMake(0, 1);
    //_SwitchContainer.layer.shadowRadius = 2.0f;
    //_SwitchContainer.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor;
    //_SwitchContainer.layer.borderWidth = 1.0f;
    
    [_SwitchContainer setDraggable:YES];
	[_SwitchContainer setCornerRadius:46/2];
    //[_SwitchContainer setBlurTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
    _mapChageButton.enabled = YES;
    _listChageButton.enabled = YES;
    
    _mapChageButton.frame = CGRectMake(5, 5, 36, 36);
    [_mapChageButton setImage:[UIImage imageNamed:@"map_CircleBlack"] forState:UIControlStateNormal];
  /*  _mapChageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _mapChageButton.layer.borderWidth = 1.0f;
    _mapChageButton.layer.cornerRadius = 17.0f;
  //  _mapChageButton.layer.masksToBounds = YES;
    _mapChageButton.opaque = NO;
    _mapChageButton.alpha = .90f;
    _mapChageButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _mapChageButton.layer.shadowOpacity = 0.2;
    _mapChageButton.layer.shadowOffset = CGSizeMake(0, 1);
    _mapChageButton.layer.shadowRadius = 2.0f;*/
    
    [_SwitchContainer addSubview:_mapChageButton];
    
    _listChageButton.frame = CGRectMake(5, 5, 36, 36);
    [_listChageButton setImage:[UIImage imageNamed:@"list_CircleBlack"] forState:UIControlStateNormal];
   /* _listChageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _listChageButton.layer.borderWidth = 1.0f;
    _listChageButton.layer.cornerRadius = 17.0f;
   // _listChageButton.layer.masksToBounds = YES;
    _listChageButton.opaque = NO;
    _listChageButton.alpha = .90f;
    _listChageButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _listChageButton.layer.shadowOpacity = 0.2;
    _listChageButton.layer.shadowOffset = CGSizeMake(0, 1);
    _listChageButton.layer.shadowRadius = 2.0f;*/
    
    [_SwitchContainer addSubview:_listChageButton];
    
   // [_addDigitize setImage:[UIImage imageNamed:@"stop96.png"] forState:UIControlStateNormal];
    [_addDigitize setTitle:@"STOP" forState:UIControlStateNormal];
    _addDigitize.titleLabel.font = [UIFont boldSystemFontOfSize: 11];
    [_addDigitize setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addDigitize.backgroundColor = [UIColor redColor];
    _addDigitize.layer.borderColor = [UIColor redColor].CGColor;
    _addDigitize.layer.borderWidth = 1.0f;
    _addDigitize.layer.cornerRadius = 17.0f;
   // _addDigitize.layer.masksToBounds = YES;
    _addDigitize.opaque = NO;
    _addDigitize.alpha = 1.0f;
    _addDigitize.layer.shadowColor = [UIColor blackColor].CGColor;
    _addDigitize.layer.shadowOpacity = 0.2;
    _addDigitize.layer.shadowOffset = CGSizeMake(0, 1);
    _addDigitize.layer.shadowRadius = 2.0f;
    
    [_addDigitize addTarget:self action:@selector(doneDigitize) forControlEvents:UIControlEventAllEvents];
    
    [_mapView addSubview:_addDigitize];
    
   
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 960){
                NSLog(@"iphone 4, 4s retina resolution");
                
                //CODE IF IPHONE 4
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                    //Code if iPhone 4 or 4s and iOS 7
                    NSLog(@"iPhone 4 iOS 7");
                    
                   // _mapChageButton.frame = CGRectMake(80, 415, 34, 34);
                  //  _listChageButton.frame = CGRectMake(205, 415, 34, 34);
                    _routeDistance = [[UILabel alloc] initWithFrame:CGRectMake(_mapView.frame.size.width - 155,150, 140, 15)];
                    _elaserRoute.frame = CGRectMake(250, 108, 16, 16);
                    _elaserBufferZone.frame = CGRectMake(85, 100, 16, 16);
                    _stepRoute.frame = CGRectMake(269.0, 108.0, 40.0, 40.0);
                    __radiusSlider.frame = CGRectMake(101.0, 108.0, 118.0, 31.0);
                    _addDigitize.frame = CGRectMake(6, 68, 34, 34);
                    _elaserAreaButton.frame = CGRectMake(6, 68, 34, 34);
                }
            }
            if(result.height == 1136){
                NSLog(@"iphone 5 resolution");
                
                //CODE IF iPHONE 5
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                    //Code if iPhone 5 or 5s and iOS 7
                    NSLog(@"iPhone 5 iOS 7");

                    //  _mapChageButton.frame = CGRectMake(80, 503, 34, 34);
                  //  _listChageButton.frame = CGRectMake(205, 503, 34, 34);
                    _routeDistance = [[UILabel alloc] initWithFrame:CGRectMake(_mapView.frame.size.width - 155,150, 140, 15)];
                    _elaserRoute.frame = CGRectMake(250, 108, 16, 16);
                    _elaserBufferZone.frame = CGRectMake(85, 100, 16, 16);
                    _stepRoute.frame = CGRectMake(269.0, 108.0, 40.0, 40.0);
                    __radiusSlider.frame = CGRectMake(101.0, 108.0, 118.0, 31.0);
                    _addDigitize.frame = CGRectMake(6, 68, 34, 34);
                    _elaserAreaButton.frame = CGRectMake(6, 68, 34, 34);
                }
            }
        }
        
    } else {
        
        _routeDistance = [[UILabel alloc] initWithFrame:CGRectMake(_mapView.frame.size.width - 160,150, 140, 15)];
        _elaserRoute.frame = CGRectMake(685, 104, 16, 16);
        _elaserBufferZone.frame = CGRectMake(250, 104, 16, 16);
        _stepRoute.frame = CGRectMake(708.0, 104.0, 40.0, 40.0);
        __radiusSlider.frame = CGRectMake(271.0, 109.0, 227.0, 31.0);
        _addDigitize.frame = CGRectMake(20, 107, 34, 34);
        _elaserAreaButton.frame = CGRectMake(20, 107, 34, 34);
    }

    _routeDistance.font = [UIFont boldSystemFontOfSize:13];
    _routeDistance.backgroundColor = [UIColor clearColor];
    _routeDistance.textColor = [UIColor blackColor];
    _routeDistance.textAlignment = NSTextAlignmentRight;
    _routeDistance.layer.shadowColor = [UIColor blackColor].CGColor;
    _routeDistance.layer.shadowOpacity = 0.2;
    _routeDistance.layer.shadowOffset = CGSizeMake(0, 1);
    _routeDistance.layer.shadowRadius = 2.0f;
    [_mapView addSubview:_routeDistance];
    
    if (_routeDirectionChangedSegmentedControl.selectedSegmentIndex == 0) {
        [_stepRoute setImage:[UIImage imageNamed:@"car.png"] forState:UIControlStateNormal];
    } else if (_routeDirectionChangedSegmentedControl.selectedSegmentIndex == 1) {
        [_stepRoute setImage:[UIImage imageNamed:@"walk.png"] forState:UIControlStateNormal];
    } else {
        [_stepRoute setImage:[UIImage imageNamed:@"bus.png"] forState:UIControlStateNormal];
    }
    // [_stepRoute setImage:[UIImage imageNamed:@"routing.png"] forState:UIControlStateNormal];
    _stepRoute.layer.borderColor = [UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
    //[UIColor grayColor].CGColor;
    // _stepRoute.backgroundColor = [UIColor whiteColor];
    _stepRoute.layer.borderWidth = 1.5f;
    _stepRoute.layer.cornerRadius = 20.0f;
   // _stepRoute.layer.masksToBounds = YES;
    _stepRoute.opaque = NO;
    _stepRoute.alpha = .90f;
    _stepRoute.layer.shadowColor = [UIColor blackColor].CGColor;
    _stepRoute.layer.shadowOpacity = 0.2;
    _stepRoute.layer.shadowOffset = CGSizeMake(0, 1);
    _stepRoute.layer.shadowRadius = 2.0f;
    //  [_stepRoute addTarget:self action:@selector(routeDirection) forControlEvents:UIControlEventAllEvents];
    [_mapView addSubview:_stepRoute];
    
    [_elaserRoute setTitle:@"-" forState:UIControlStateNormal];
    _elaserRoute.titleLabel.font = [UIFont fontWithName:@"Avenir Roman bold" size:17];
    [_elaserRoute setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _elaserRoute.backgroundColor = [UIColor redColor];
    _elaserRoute.layer.cornerRadius = 8.0f;
   // _elaserRoute.layer.masksToBounds = YES;
    _elaserRoute.opaque = NO;
    _elaserRoute.alpha = .90f;
    _elaserRoute.layer.shadowColor = [UIColor blackColor].CGColor;
    _elaserRoute.layer.shadowOpacity = 0.2;
    _elaserRoute.layer.shadowOffset = CGSizeMake(0, 1);
    _elaserRoute.layer.shadowRadius = 2.0f;
    [_elaserRoute addTarget:self action:@selector(routeDirectionElaser) forControlEvents:UIControlEventAllEvents];
    [_mapView addSubview:_elaserRoute];
    
    [_mapView addSubview:__radiusSlider];
    
    [_elaserBufferZone setTitle:@"-" forState:UIControlStateNormal];
    _elaserBufferZone.titleLabel.font = [UIFont fontWithName:@"Avenir Roman bold" size:17];
    [_elaserBufferZone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _elaserBufferZone.backgroundColor = [UIColor redColor];
    _elaserBufferZone.layer.cornerRadius = 8.0f;
  //  _elaserBufferZone.layer.masksToBounds = YES;
    _elaserBufferZone.opaque = NO;
    _elaserBufferZone.alpha = .90f;
    _elaserBufferZone.layer.shadowColor = [UIColor blackColor].CGColor;
    _elaserBufferZone.layer.shadowOpacity = 0.2;
    _elaserBufferZone.layer.shadowOffset = CGSizeMake(0, 1);
    _elaserBufferZone.layer.shadowRadius = 2.0f;
    [_elaserBufferZone addTarget:self action:@selector(circleElaser) forControlEvents:UIControlEventAllEvents];
    [_mapView addSubview:_elaserBufferZone];

   /* MKUserTrackingBarButtonItem *buttonItem =
    [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    //UIBarButtonItem *showTableDatabase = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico-to-do-list"] style:UIBarButtonItemStylePlain target:self action:@selector(showTableDatabase)];
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:self action:@selector(barButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"ico-to-do-list"] forState:UIControlStateNormal];

    showTableDatabase = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    showTableDatabase.badgeValue = @"0";
    
    showTableDatabase.badgeOriginX = 13;
    showTableDatabase.badgeOriginY = -9;
    
    buttonArray = [[NSArray alloc] initWithObjects:buttonItem,showTableDatabase, nil];
    
    self.navigationItem.rightBarButtonItems = buttonArray;*/

    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
       
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager startUpdatingLocation];
        
        [_locationManager requestWhenInUseAuthorization];
    }
    
   // _mapView.showsUserLocation = YES;
    [_mapView setShowsUserLocation:YES];
  
    MKUserTrackingBarButtonItem *buttonItem =
    [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
   /* MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance ( userLocation.location.coordinate, 1000, 1000 );
    [_mapView setRegion:region animated:YES];*/
    
    __areas = [NSMutableArray array];
    
    __pins = [NSMutableArray array];

    self.elaserAreaButton.hidden = YES;
    self.SwitchContainer.hidden = YES;
    self.mapChageButton.hidden = YES;
    self.stepRoute.hidden = YES;
    self.routeDistance.hidden = YES;
    self._radiusSlider.hidden = YES;
    self.elaserRoute.hidden = YES;
    self.elaserBufferZone.hidden = YES;
    self.addDigitize.hidden = YES;
    
    radius = 100;
    __radiusSlider.value = radius;
    
 /*   if (self.record.coordinate_x == nil && self.record.coordinate_y == nil && self.record.name== nil && self.record.type == nil && self.record.descriptions == nil) {
    self.pinTableButton.hidden = YES;
    } else {
        self.pinTableButton.hidden = NO;
    }*/
    _useClustering = YES;
    
    self.mapSource = WMMapSourceStandard;
    
    _coordinateDigitize = kCLLocationCoordinate2DInvalid;
    coordsDigitize = NULL;
    addingShape = NO;
    canAddPoints = NO;
    
    [self addGestureRecogniserToMapView];
 
 //   self.qTree = [QTree new];

   /* self.viewDraggable.hidden = YES;
    [self.viewDraggable setDraggable:YES];
    [self.viewDraggable setCornerRadius:10];*/
    
   // [[MyDatabaseManager sharedManager] deleteAllTableRecord]; //------delete database
    [self.tableView setEditing:YES animated:YES];
    self.tableView.allowsSelectionDuringEditing = YES;
    
    //self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    filteredRecords = [NSMutableArray arrayWithCapacity:[records count]];
    
    [self.tableView reloadData];
    
    imageListPin = [UIImage imageNamed:@"MlistPin"];
    sideMenu.delegate = self;
    
    [self updateLocations];
    [self warning];
    [self arertAddLayer];
    [self setMapRegion];
    [self mainmenu];
}

-(void)mainmenu {

    if ([records count] <= 1) {
        stringListPin = [NSString stringWithFormat:@"(%lu) Pin",(unsigned long)[records count]];
    } else {
        stringListPin = [NSString stringWithFormat:@"(%lu) Pins",(unsigned long)[records count]];
    }

    btSimpleMenuItem *item1 = [[btSimpleMenuItem alloc]initWithTitle:@"+  NRF Layer"
                                                               image:[UIImage imageNamed:@"MLayerOverlay"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self NRFselectProvinceMenu];
                                                        }];
    
    btSimpleMenuItem *item2 = [[btSimpleMenuItem alloc]initWithTitle:@"+  Other Layer"
                                                               image:[UIImage imageNamed:@"MLayerOverlay"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self menuButtons];
                                                        }];
    
    btSimpleMenuItem *item3 = [[btSimpleMenuItem alloc]initWithTitle:@"+ Pin"
                                                               image:[UIImage imageNamed:@"Mpin_add_n"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self addPinToMapDatabase];
                                                        }];
    

    btSimpleMenuItem *item4 = [[btSimpleMenuItem alloc]initWithTitle:[NSString stringWithFormat:@"You've %@",stringListPin]
                                                 image:imageListPin
                                          onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                              imageListPin = [UIImage imageNamed:@"MlistPin"];
                                              
                                              [self showTableDatabase];
                                              [self mainmenu];
                                          }];
    
    btSimpleMenuItem *item5 = [[btSimpleMenuItem alloc]initWithTitle:@"Search Place"
                                                               image:[UIImage imageNamed:@"Msearch"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self gotoCoordinate];
                                                        }];
    btSimpleMenuItem *item6 = [[btSimpleMenuItem alloc]initWithTitle:@"Route Direction"
                                                               image:[UIImage imageNamed:@"MRouteN"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            route_from = ROUTE_FROM_BAR;
                                                            [self routeDirectionTable];
                                                        }];
    
    btSimpleMenuItem *item7 = [[btSimpleMenuItem alloc]initWithTitle:@"Digitize"
                                                               image:[UIImage imageNamed:@"pMenu_polygon"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self selectDigitizeFuctions];
                                                        }];
    
    btSimpleMenuItem *item8 = [[btSimpleMenuItem alloc]initWithTitle:@"List & Search"
                                                               image:[UIImage imageNamed:@"list_search"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self listAndSearch];
                                                        }];
    
    btSimpleMenuItem *item9 = [[btSimpleMenuItem alloc]initWithTitle:@"Setting Map"
                                                               image:[UIImage imageNamed:@"Msetting"]
                                                        onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                            [self performCurl];
                                                        }];
    
    btSimpleMenuItem *item10 = [[btSimpleMenuItem alloc]initWithTitle:@"About"
                                                                image:[UIImage imageNamed:@"Mlegend"]
                                                         onCompletion:^(BOOL success, btSimpleMenuItem *item) {
                                                             [self about];
                                                         }];
    
    
    sideMenu = [[btSimpleSideMenu alloc]initWithItem:@[item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
                                 addToViewController:self];
}

-(void)show {
    [sideMenu toggleMenu];
    [self closeTransparentView];
 
}

#pragma -mark btSimpleSideMenuDelegate

-(void)btSimpleSideMenu:(btSimpleSideMenu *)menu didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"Item Cliecked : %ld", (long)index);
}

-(void)btSimpleSideMenu:(btSimpleSideMenu *)menu selectedItemTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Menu Clicked"
                                                   message:[NSString stringWithFormat:@"Item Title : %@", title]
                                                  delegate:self
                                         cancelButtonTitle:@"Dismiss"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

- (void)arertAddLayer {

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"พื้นที่เป้าหมาย"
                                                      message:@"เลือกพื้นที่ป่าสงวนแห่งชาติที่ต้องการ"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Next", nil];
    [message show];
}

-(void)setMapRegion {

    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 13.13;
    region.center.longitude = 101.44;
    region.span.longitudeDelta = 10.0f;
    region.span.latitudeDelta = 10.0f;
    [_mapView setRegion:region animated:YES];
}

-(void)listAndSearch {

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
         [self performSegueWithIdentifier:@"ListAndSearch" sender:self];
    } else {
        
        if (listAndSearchPopoverController == nil) {
            
            UIView *btn = [UIView new];
            btn.frame = CGRectMake(0, 0, _mapView.frame.size.width +180 , 110);
            
            GuideViewController *guideViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GuideViewController"];
            guideViewController.preferredContentSize = CGSizeMake(320, 480);
           
            guideViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:guideViewController];
            
            listAndSearchPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            listAndSearchPopoverController.delegate = self;
            listAndSearchPopoverController.passthroughViews = @[btn];
            listAndSearchPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            listAndSearchPopoverController.wantsDefaultContentAppearance = NO;
            
            [listAndSearchPopoverController presentPopoverFromRect:btn.bounds
                                                             inView:self.view
                                           permittedArrowDirections:WYPopoverArrowDirectionAny
                                                           animated:YES
                                                            options:WYPopoverAnimationOptionFadeWithScale];
        }
    }
}

-(void)about {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [self performSegueWithIdentifier:@"toAbout" sender:self];
    } else {
        
        if (aboutPopoverController == nil) {
            
            UIView *btn = [UIView new];
            btn.frame = CGRectMake(0, 0, _mapView.frame.size.width +180 , 110);
            
            AboutViewController *aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
            aboutViewController.preferredContentSize = CGSizeMake(320, 480);
            
            aboutViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
            
            aboutPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            aboutPopoverController.delegate = self;
            aboutPopoverController.passthroughViews = @[btn];
            aboutPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            aboutPopoverController.wantsDefaultContentAppearance = NO;
            
            [aboutPopoverController presentPopoverFromRect:btn.bounds
                                                            inView:self.view
                                          permittedArrowDirections:WYPopoverArrowDirectionAny
                                                          animated:YES
                                                           options:WYPopoverAnimationOptionFadeWithScale];
        }
    }
}

- (void)warning {
    [CSNotificationView showInViewController:self
                                        style:CSNotificationViewStyleWarning
                                    message:@"แผนที่ดังกล่าว ไม่สามารถใช้เพื่อการอ้างอิงในทางกฏหมายได้ !"];
}

- (void)updateLocations {
    
    records =  [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:sortingAttribute] mutableCopy];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabasePin"
                                              withExtension:@"momd"];
    if( modelURL == nil)
        NSLog(@"Fail url");
    
    // Model
    NSManagedObjectModel *model = nil;
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Coordinator
    NSPersistentStoreCoordinator *psc = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *storeURL = [NSURL fileURLWithPath:@"RecordCell.sqlite"];
    NSError *error = nil;
    NSPersistentStore *store = nil;
    
    // Store
    store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:storeURL
                                    options:nil
                                      error:&error];
    NSManagedObjectContext* context;
    NSManagedObjectContextConcurrencyType ccType = NSMainQueueConcurrencyType;
    
    // Context
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:ccType];
    [context setPersistentStoreCoordinator:psc];
    
    // Create managed objects
    NSEntityDescription *bioEntry = [[model entitiesByName] objectForKey:@"RecordTables"];
    RecordTables* pin = [[RecordTables alloc] initWithEntity:bioEntry insertIntoManagedObjectContext:context];
    
    CLLocationCoordinate2D addCoordinate;
    for(int i = 0; i < [records count]; i++) {
        pin = [records objectAtIndex:i];
        
        addCoordinate.longitude = [pin.coordinate_x doubleValue];
        addCoordinate.latitude = [pin.coordinate_y doubleValue];
        
        pin.coordinate = addCoordinate;
        pin.title = pin.name;
        pin.subtitle = pin.type;
        pin.description = pin.descriptions;
        pin.image = [UIImage imageWithData:pin.photo];
        
        [_mapView addAnnotation:pin];
    }
}

-(void)refreshTable {
    records = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:sortingAttribute] mutableCopy];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    [self refreshTable];
}

- (void)addGestureRecogniserToMapView {

    lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5;
    [_mapView addGestureRecognizer:lpgr];
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
 /*  ----MKPointAnnotation
  
  if (self.qTree == nil) {
  self.qTree = [QTree new];
  } else {
  
  }
    toAdd = [[MKPointAnnotation alloc]init];
    toAdd.coordinate = touchMapCoordinate;
    toAdd.title = @"Drop";
    toAdd.subtitle = [NSString stringWithFormat:@"Lat: %.4f , Lon: %.4f",toAdd.coordinate.latitude,toAdd.coordinate.longitude];
     [_mapView addAnnotation:toAdd];*/
    
/*    AddAnnotation *pin = [[AddAnnotation alloc] init];
    pin.coordinate = touchMapCoordinate;
    pin.title = @"Drop";
    pin.subtitle = [NSString stringWithFormat:@"Lat: %.4f , Lon: %.4f",pin.coordinate.latitude,pin.coordinate.longitude];
    pin.interModalTransfer = @"";

    [_mapView addAnnotation:pin];
    [__pins addObject:pin];
    [self.qTree insertObject:pin];
    [self reloadAnnotations];
    self.elaserAreaButton.hidden = NO;*/

    NSDate *date = [NSDate date];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"New Pin",kName,
                          @"touch map pin",kType,
                          [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude],kCoordinate_y,
                          [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude],kCoordinate_x,
                          @"",kComment,date,KDate,
                          nil];
    
    [[MyDatabaseManager sharedManager] insertRecordInRecordTable:dict];
    [self refreshTable];
    [self reloadAnnotations];
    
    [sideMenu hide];
    imageListPin = [UIImage imageNamed:@"MlistPinBlue"];
    [self mainmenu];
}

- (void)addPinToMapButton {
    if (self.qTree == nil) {
        self.qTree = [QTree new];
    } else {
        
    }
    
    CLLocationCoordinate2D centerCoordinate = _mapView.centerCoordinate;
    
    AddAnnotation *pin = [[AddAnnotation alloc] init];
    pin.coordinate = centerCoordinate;
    pin.title = @"Drop";
    pin.subtitle = [NSString stringWithFormat:@"Lat: %.4f , Lon: %.4f",pin.coordinate.latitude,pin.coordinate.longitude];
    pin.interModalTransfer = @"";
    
    [_mapView addAnnotation:pin];
    [__pins addObject:pin];
    [self.qTree insertObject:pin];
    [self reloadAnnotations];
    self.elaserAreaButton.hidden = NO;
}

-(void)layer {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    
    [self setTitle:@"Please Wait..."];

    if (self.qTree == nil) {
        self.qTree = [QTree new];
    } else {
        
    }

    NSURL *url = [NSURL URLWithString:_urlConnect];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",url);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if ([data length] >0 && error == nil)
                               {
        
   // NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"krabi_1" withExtension:@"geojson"]]; // for connect file in xcode
    NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSArray *shapes = [GeoJSONSerialization shapesFromGeoJSONFeatureCollection:geoJSON error:nil];

    NSLog(@"%@",shapes);
    for (MKShape *shape in shapes) {

        if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
 
            [_mapView addOverlay:(id <MKOverlay>)shape];
            
            Annotation *annotation = [[Annotation alloc] init];
            
            annotation.title = [[shape.title componentsSeparatedByString:@","] objectAtIndex:1];
            annotation.subtitle = [NSString stringWithFormat:@"%@ / %@ / จ.%@", [[shape.title componentsSeparatedByString:@","] objectAtIndex:6],[[shape.title componentsSeparatedByString:@","] objectAtIndex:0], [[shape.title componentsSeparatedByString:@","] objectAtIndex:3]];
      
            annotation.nameThai = [[shape.title componentsSeparatedByString:@","] objectAtIndex:1];
            annotation.province = [[shape.title componentsSeparatedByString:@","] objectAtIndex:3];
            annotation.code = [[shape.title componentsSeparatedByString:@","] objectAtIndex:6];
            annotation.nameEng = [[shape.title componentsSeparatedByString:@","] objectAtIndex:2];
            annotation.type = [[shape.title componentsSeparatedByString:@","] objectAtIndex:0];
            
            annotation.polygon = shape.subtitle;
            
            annotation.coordinate = CLLocationCoordinate2DMake([[[shape.title componentsSeparatedByString:@","] objectAtIndex:4] doubleValue], [[[shape.title componentsSeparatedByString:@","] objectAtIndex:5] doubleValue]);
            
            [__areas addObject:annotation];
            [self.qTree insertObject:annotation];
            [self reloadAnnotations];
            __listViewController.areas = __areas;
        }
    }
    
    for (Annotation *shape in shapes) {
        
        if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
            
        } else {
            
            [_mapView addAnnotation:shape];
            
            [__areas addObject:shape];
            [self.qTree insertObject:shape];
            [self reloadAnnotations];
            __listViewController.areas = __areas;
            
            NSArray *array = shape.multiPolygon;
            
            if ([array conformsToProtocol:@protocol(MKOverlay)]) {
                
            } else {
                NSString *jsonString = [array componentsJoinedByString:@","];
                
                for (jsonString in array) {
                    
                    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *geometry = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    NSDictionary *subFeature = [NSDictionary dictionaryWithDictionary:geometry[@"geometry"]];
                    
                    NSArray *coordinateSets = subFeature[@"coordinates"];
                    
                    NSMutableArray *mutablePolygons = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
                    for (NSArray *coordinatePairs in coordinateSets) {
                        CLLocationCoordinate2D *polygonCoordinates = CLLocationCoordinatesFromCoordinatePairs(coordinatePairs);
                        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:[coordinatePairs count]];
                        [mutablePolygons addObject:polygon];
                    }
                    
                    MKPolygon *polygon = nil;
                    switch ([mutablePolygons count]) {
                        case 0:
                           
                        case 1:
                            polygon = [mutablePolygons firstObject];
                            break;
                        default: {
                            MKPolygon *exteriorPolygon = [mutablePolygons firstObject];
                            NSArray *interiorPolygons = [mutablePolygons subarrayWithRange:NSMakeRange(1, [mutablePolygons count] - 1)];
                            polygon = [MKPolygon polygonWithPoints:exteriorPolygon.points count:exteriorPolygon.pointCount interiorPolygons:interiorPolygons];
                        }
                            break;
                    }
                    polygon.title = shape.type;
                    
                    [_mapView addOverlay:polygon];
                }
            }
        }
    }
                                  /* NSArray *pole = [_mapView overlays];
                                   
                                   NSArray *area = [_mapView annotations];
                                   
                                   MKMapRect flyTo = MKMapRectNull;
                                   for (id <MKOverlay> overlay in pole) {
                                       if (MKMapRectIsNull(flyTo)) {
                                           flyTo = [overlay boundingMapRect];
                                       } else {
                                           flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
                                       }
                                   }
                                   
                                   for (id <MKAnnotation> annotation in area) {
                                       MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                                       MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                                       if (MKMapRectIsNull(flyTo)) {
                                           flyTo = pointRect;
                                       } else {
                                           flyTo = MKMapRectUnion(flyTo, pointRect);
                                       }
                                   }
                                   _mapView.visibleMapRect = flyTo;*/
                                   
                                   [self setMapRegion];
                                   [_progressView stopAnimating];
                                   [self setTitle:@"Map"];//---[self hideLoadingMode];
                                   
                                   [blurView removeFromSuperview];
                                   
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   _mapChageButton.enabled = YES;
                                   _listChageButton.enabled = YES;
                                   self.elaserAreaButton.hidden = NO;
                                   self.SwitchContainer.hidden = NO;
                                
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleSuccess
                                                                    message:@"Overlay Complete"];
                                   
                               } else if ([data length] == 0 && error == nil) {
                                   NSLog(@"Nothing was downloaded.");
                                   [_progressView stopAnimating];
                                   [self setTitle:@"Map"];//---[self hideLoadingMode];
                                   
                                   [blurView removeFromSuperview];
                                   
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   _mapChageButton.enabled = YES;
                                   _listChageButton.enabled = YES;
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleError
                                                                    message:@"Overlay Error!"];
                               } else if (error != nil) {
                                   NSLog(@"Error = %@", error);
                                   
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnected", nil) message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                                   [alertView show];
                                   
                                   [_progressView stopAnimating];
                                   [self setTitle:@"Map"];//---[self hideLoadingMode];
                                   
                                   [blurView removeFromSuperview];
                                   
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   _mapChageButton.enabled = YES;
                                   _listChageButton.enabled = YES;
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleError
                                                                    message:@"Overlay Error!"];
                               }
                           }];
}

-(void)selectDigitizeFuctions {
    [drawer hideAnimated:YES];
 
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Digitize", nil)];
   /* actionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    actionSheet.blurRadius = 8.0f;
    actionSheet.buttonHeight = 50.0f;
    actionSheet.cancelButtonHeight = 50.0f;
    actionSheet.cancelButtonShadowColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    actionSheet.separatorColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    actionSheet.selectedBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir" size:17.0f];
    actionSheet.buttonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                          NSForegroundColorAttributeName : [UIColor whiteColor] };
    actionSheet.destructiveButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                     NSForegroundColorAttributeName : [UIColor redColor] };
    actionSheet.cancelButtonTextAttributes = @{ NSFontAttributeName : defaultFont,
                                                NSForegroundColorAttributeName : [UIColor whiteColor] };*/
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Create line", nil)
                              image:[UIImage imageNamed:@"DigitizePolyline"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self digitizeCreateTopolyline];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Create polygon", nil)
                              image:[UIImage imageNamed:@"DigitizePolygon"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self digitizeCreateTopolygon];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Point to line", nil)
                              image:[UIImage imageNamed:@"pPolyline"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self digitizePointToPolyline];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Point to polygon", nil)
                              image:[UIImage imageNamed:@"pPolygon"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self digitizePointToPolygon];
                            }];
    [actionSheet show];
}

-(void)digitizeCreateTopolyline {
    [_mapView removeGestureRecognizer:lpgr];
    
    mapTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCoordinateToList:)];
    [mapTapRecognizer setNumberOfTapsRequired:1];
    [_mapView addGestureRecognizer:mapTapRecognizer];
    
    addingShape = YES;
    canAddPoints = YES;
    
    [self.pathDigitize removeAllObjects];
    self.pathDigitize = nil;
    
    (digitize_type = DIGITIZE_POLYLINE);
    
    self.navigationItem.title = NSLocalizedString(@"Start Digitizing", nil);
    self.elaserAreaButton.hidden = NO;
    self.addDigitize.hidden = NO;
    [_addDigitize bringSubviewToFront:_elaserAreaButton];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

-(void)digitizeCreateTopolygon {
    [_mapView removeGestureRecognizer:lpgr];
    
    mapTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCoordinateToList:)];
    [mapTapRecognizer setNumberOfTapsRequired:1];
    [_mapView addGestureRecognizer:mapTapRecognizer];
    
    addingShape = YES;
    canAddPoints = YES;
    
    [self.pathDigitize removeAllObjects];
    self.pathDigitize = nil;
    
    (digitize_type = DIGITIZE_POLYGON);
    
    self.navigationItem.title = NSLocalizedString(@"Start Digitizing", nil);
    self.elaserAreaButton.hidden = NO;
    self.addDigitize.hidden = NO;
    [_addDigitize bringSubviewToFront:_elaserAreaButton];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
}

-(NSMutableArray *)dictionaryOfPolygonsDigitize {
    if(!_dictionaryOfPolygonsDigitize){
        _dictionaryOfPolygonsDigitize = [[NSMutableArray alloc] init];
    }
    return _dictionaryOfPolygonsDigitize;
}

-(NSMutableArray *)pathDigitize {
    if(!_pathDigitize){
        _pathDigitize = [[NSMutableArray alloc] init];
    }
    return _pathDigitize;
}

-(void)doneDigitize {
    self.navigationItem.title = NSLocalizedString(@"Map", nil);
    
    if (digitize_type == DIGITIZE_POLYLINE) {
        addingShape = NO;
        canAddPoints = NO;
        
        if (_pathDigitize.count == 0) {

        } else if (_pathDigitize.count == 1) {
            [_mapView removeOverlay:self.circleDigitize];
        } else {
            self.polylineDigitize = [MKPolyline polylineWithCoordinates:coordsDigitize count:[self.pathDigitize count]];
            self.polylineDigitize.title = @"polylineDigitize";
            
            [_mapView addOverlay:self.polylineDigitize];
        }
        
    } else if (digitize_type == DIGITIZE_POLYGON) {
        addingShape = NO;
        canAddPoints = NO;

        if (_pathDigitize.count == 0) {
          
        } else if (_pathDigitize.count == 1) {
            [_mapView removeOverlay:self.circleDigitize];
        } else {
            
            self.polygonDigitize = [MKPolygon polygonWithCoordinates:coordsDigitize count:[self.pathDigitize count]];
            self.polygonDigitize.title = [self currentPolygonTitleDigitize];
            self.intersectedPolygonViewDigitize = [[MKPolygonRenderer alloc] initWithPolygon:self.polygonDigitize];
          //  [self.dictionaryOfPolygonsDigitize addObject:self.polygonDigitize];

          /*  if (self.dictionaryOfPolygonsDigitize.count == 2){
                self.intersectedPolygonDigitize = [MKPolygon polygon:[self.dictionaryOfPolygonsDigitize objectAtIndex:0] intersectedWithSecondPolygon:[self.dictionaryOfPolygonsDigitize objectAtIndex:1]];
                self.intersectedPolygonDigitize.title = @"intersectedPolygonDigitize";
                self.intersectedPolygonViewDigitize = [[MKPolygonRenderer alloc] initWithPolygon:self.intersectedPolygonDigitize];
                NSLog(@"intersected polygon has %lu points", (unsigned long)self.intersectedPolygonDigitize.pointCount);
                [_mapView addOverlay:self.intersectedPolygonDigitize];
            }*/
            self.polygonDigitize.title = @"polygonDigitize_create";
            
            [_mapView addOverlay:self.polygonDigitize];
        }
    }
    [_mapView removeGestureRecognizer:mapTapRecognizer];
    [self addGestureRecogniserToMapView];
    
    self.addDigitize.hidden = YES;
    self.elaserAreaButton.hidden = NO;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    _mapChageButton.enabled = YES;
    _listChageButton.enabled = YES;
}

-(void)addCoordinateToList:(UITapGestureRecognizer*)recognizer {
    
    CGPoint tappedPoint = [recognizer locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView convertPoint:tappedPoint toCoordinateFromView:_mapView];
    //NSLog(@"Coordinate tapped: %f,%f", coord.latitude, coord.longitude);
    MKMapPoint mapPoint = MKMapPointForCoordinate(coord);
    NSLog(@"Corresponding MKMapPoint: %f,%f", mapPoint.x, mapPoint.y);
    
    if(canAddPoints){
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [self.pathDigitize addObject:newLocation];
        
        [self drawCircleWithCoordinate:coord];
        [self drawPolygonBorder];
    }
}

-(void)drawCircleWithCoordinate:(CLLocationCoordinate2D)coord {
    
    //self.circleDigitize = [MKCircle circleWithCenterCoordinate:coord radius:10];
    //[_mapView addOverlay:self.circleDigitize];

    MKPointAnnotation *digitizePin = [[MKPointAnnotation alloc]init];
    digitizePin.coordinate = coord;
 
    [_mapView addAnnotation:digitizePin];
}

-(void)drawPolygonBorder {
    
    NSInteger numberOfCoordinates = [self.pathDigitize count];
    
    if (numberOfCoordinates < 2)
        return;
    
    if(coordsDigitize != NULL)
        free(coordsDigitize);
    coordsDigitize = malloc(sizeof(CLLocationCoordinate2D) * numberOfCoordinates);
    
    for(int pathIndex = 0; pathIndex < numberOfCoordinates; pathIndex++){
        CLLocation *location = [self.pathDigitize objectAtIndex:pathIndex];
        coordsDigitize[pathIndex] = location.coordinate;
    }
    
    self.polylineDigitize = [MKPolyline polylineWithCoordinates:coordsDigitize count:numberOfCoordinates];
    self.polylineDigitize.title = @"polylineDigitize_border";
    
    [_mapView addOverlay:self.polylineDigitize];
}

-(void)digitizePointToPolyline {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Calculating..."];
    
    if (records.count == 0) {
        [drawer hideAnimated:YES];
        
        [_progressView stopAnimating];
        [self setTitle:@"Map"];//---[self hideLoadingMode];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [blurView removeFromSuperview];
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:@"NO Point"];
    } else {
        
        records =  [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:sortingAttribute] mutableCopy];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabasePin"
                                                  withExtension:@"momd"];
        if( modelURL == nil)
            NSLog(@"Fail url");
        
        // Model
        NSManagedObjectModel *model = nil;
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // Coordinator
        NSPersistentStoreCoordinator *psc = nil;
        psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSURL *storeURL = [NSURL fileURLWithPath:@"RecordCell.sqlite"];
        NSError *error = nil;
        NSPersistentStore *store = nil;
        
        // Store
        store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:storeURL
                                        options:nil
                                          error:&error];
        
        NSManagedObjectContext* context;
        NSManagedObjectContextConcurrencyType ccType = NSMainQueueConcurrencyType;
        
        // Context
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:ccType];
        [context setPersistentStoreCoordinator:psc];
        
        // Create managed objects
        NSEntityDescription *bioEntry = [[model entitiesByName] objectForKey:@"RecordTables"];
        RecordTables* pin = [[RecordTables alloc] initWithEntity:bioEntry insertIntoManagedObjectContext:context];
        
        CLLocationCoordinate2D *coords = malloc([records count] * sizeof(CLLocationCoordinate2D));
        
        for(int i = 0; i < [records count]; i++) {
            pin = [records objectAtIndex:i];
            coords[i] = CLLocationCoordinate2DMake([pin.coordinate_y doubleValue ], [pin.coordinate_x doubleValue]);
        }
        
        self.polylineDigitize = [MKPolyline polylineWithCoordinates:coords count:[records count]];
        free(coords);
        
        self.polylineDigitize.title = @"polylineDigitize";
        [_mapView addOverlay:self.polylineDigitize];
        
        [drawer hideAnimated:YES];
        
        [_progressView stopAnimating];
        [self setTitle:@"Map"];//---[self hideLoadingMode];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.elaserAreaButton.hidden = NO;
        _mapChageButton.enabled = YES;
        _listChageButton.enabled = YES;
        [blurView removeFromSuperview];
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleSuccess
                                         message:@"Point to Polyline Success"];
        [self setMapRegion];
    }
}

-(void)digitizePointToPolygon {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Calculating..."];
    
    if (records.count == 0) {
        [drawer hideAnimated:YES];
        
        [_progressView stopAnimating];
        [self setTitle:@"Map"];//---[self hideLoadingMode];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        _mapChageButton.enabled = YES;
        _listChageButton.enabled = YES;
        [blurView removeFromSuperview];
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:@"NO Point"];
    } else {
        
        records =  [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:sortingAttribute] mutableCopy];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabasePin"
                                                  withExtension:@"momd"];
        if( modelURL == nil)
            NSLog(@"Fail url");
        
        // Model
        NSManagedObjectModel *model = nil;
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // Coordinator
        NSPersistentStoreCoordinator *psc = nil;
        psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSURL *storeURL = [NSURL fileURLWithPath:@"RecordCell.sqlite"];
        NSError *error = nil;
        NSPersistentStore *store = nil;
        
        // Store
        store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:storeURL
                                        options:nil
                                          error:&error];
        
        NSManagedObjectContext* context;
        NSManagedObjectContextConcurrencyType ccType = NSMainQueueConcurrencyType;
        
        // Context
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:ccType];
        [context setPersistentStoreCoordinator:psc];
        
        // Create managed objects
        NSEntityDescription *bioEntry = [[model entitiesByName] objectForKey:@"RecordTables"];
        RecordTables* pin = [[RecordTables alloc] initWithEntity:bioEntry insertIntoManagedObjectContext:context];
        
        CLLocationCoordinate2D *coords = malloc([records count] * sizeof(CLLocationCoordinate2D));
        
        for(int i = 0; i < [records count]; i++) {
            pin = [records objectAtIndex:i];
            coords[i] = CLLocationCoordinate2DMake([pin.coordinate_y doubleValue ], [pin.coordinate_x doubleValue]);
        }
        self.polygonDigitize = [MKPolygon polygonWithCoordinates:coords count:[records count]];
        free(coords);
        self.polygonDigitize.title = @"polygonDigitize";
        [_mapView addOverlay:self.polygonDigitize];
        
        [drawer hideAnimated:YES];
        
        [_progressView stopAnimating];
        [self setTitle:@"Map"];//---[self hideLoadingMode];
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.elaserAreaButton.hidden = NO;
        _mapChageButton.enabled = YES;
        _listChageButton.enabled = YES;
        [blurView removeFromSuperview];
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleSuccess
                                         message:@"Point to Polygon Success"];
        [self setMapRegion];
    }
}

-(void)selectAnnotationButton {
    [drawer hideAnimated:YES];

    drawer = [[BFNavigationBarDrawer alloc] init];
    //drawer.scrollView = self.tableView; //if wanna scrollview
    route_from = ROUTE_FROM_BAR;
    
    [sideMenu hide];
    
    UIBarButtonItem *flexibleSpace_0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *buffer = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pin_buf_3"] style:UIBarButtonItemStyleBordered target:self action:@selector(bufferZoneAnnotation)];
    UIBarButtonItem *flexibleSpace_1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *route = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pin_routeN"] style:UIBarButtonItemStyleBordered target:self action:@selector(routeDirectionTable)];
    UIBarButtonItem *flexibleSpace_2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *detail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pin_detail_1"] style:UIBarButtonItemStyleBordered target:self action:@selector(toDetail)];
    UIBarButtonItem *flexibleSpace_3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDrawer)];
    UIBarButtonItem *flexibleSpace_4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        drawer.items = @[buffer, flexibleSpace_1, route, flexibleSpace_2, detail, flexibleSpace_3, cancel];
    } else {
        drawer.items = @[flexibleSpace_0, buffer, flexibleSpace_1, route, flexibleSpace_2, detail, flexibleSpace_3, cancel, flexibleSpace_4];
    }
    drawer.tintColor = [UIColor whiteColor];
    drawer.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
    if (selectedAnnotation) {
        [drawer showFromNavigationBar:self.navigationController.navigationBar animated:YES];
	} else {
		[drawer hideAnimated:YES];
	}
//
    _viewGesture = [UIView new];
    _viewGesture.frame = CGRectMake(0, 0, _mapView.frame.size.width, _mapView.frame.size.height);
    _viewGesture.backgroundColor = [UIColor clearColor];
    [_mapView addSubview:_viewGesture];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDrawer)];
    [gesture setNumberOfTapsRequired:1];
    [_viewGesture addGestureRecognizer:gesture];

    [_transparentView close];
    
    MKUserTrackingBarButtonItem *buttonItem =
    [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.navigationItem.title = NSLocalizedString(@"Map", nil);
    
    addingShape = NO;
    canAddPoints = NO;
    
    self.addDigitize.hidden = YES;
    [_mapView removeGestureRecognizer:mapTapRecognizer];
    
    [self addGestureRecogniserToMapView];
//
}

-(void)cancelDrawer {
    [drawer hideAnimated:YES];
    
    [_viewGesture removeFromSuperview];
    [sideMenu hide];
}

-(void)toDetail {
    [_viewGesture removeFromSuperview];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [drawer hideAnimated:YES];
        
        DetailDatabaseViewController *detailDatabaseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailDatabaseViewController"];
        RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
        detailDatabaseViewController.record = selectedAnnotation;
        
        [self.navigationController pushViewController:detailDatabaseViewController animated:NO];
       // [self performSegueWithIdentifier:@"TableToDetails" sender:self];
    } else {
        
        UIView *btn = [UIView new];
        btn.frame = CGRectMake(0, 0, _mapView.frame.size.width +180 , 110);
        // UIView *btn = (UIView *)sender;
        
        DetailDatabaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailDatabaseViewController"];
        controller.preferredContentSize = CGSizeMake(320, 480);
      
           RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
           controller.record = selectedAnnotation;
        
        controller.modalInPopover = NO;
        
        UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        detailDatabasePopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        detailDatabasePopoverController.delegate = self;
        detailDatabasePopoverController.passthroughViews = @[btn];
        detailDatabasePopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        detailDatabasePopoverController.wantsDefaultContentAppearance = NO;
        
        [detailDatabasePopoverController presentPopoverFromRect:btn.bounds
                                                    inView:self.view
                                  permittedArrowDirections:WYPopoverArrowDirectionAny
                                                  animated:YES
                                                   options:WYPopoverAnimationOptionFadeWithScale];
    }
}

- (IBAction)_radiusValueChanged:(id)sender {
    radius = [(UISlider *)sender value];

    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@" m"];
    [tempFormatter setNegativeSuffix:@" m"];
    
    [__radiusSlider setNumberFormatter:tempFormatter];
    __radiusSlider.font = [UIFont boldSystemFontOfSize:13];
    __radiusSlider.textColor = [UIColor whiteColor];
    __radiusSlider.popUpViewColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];

    [_mapView removeOverlay:circle];
    [self addCircle];
}

-(void)bufferZoneAnnotation {
    [drawer hideAnimated:YES];
    [_viewGesture removeFromSuperview];
    
    self._radiusSlider.hidden = NO;
    self.elaserBufferZone.hidden = NO;
    
   /* NSString *distance;
    if(radius > 1000){
        radius /= 1000;
        distance = [NSString stringWithFormat:@"%.02f km", radius];
    }else{
        distance = [NSString stringWithFormat:@"%.f m", radius];
    }
    _bufferZoneDistance.text = distance;*/
    
    RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
    circleCoordinate = selectedAnnotation.coordinate;
    
    [self addCircle];
}

-(void)addCircle {
    if(circle != nil) {
        [_mapView removeOverlay:circle];
      //  self.elaserAreaButton.hidden = NO;
    }
    circle = [MKCircle circleWithCenterCoordinate:circleCoordinate radius:radius];
    [_mapView addOverlay:circle];
}

-(void)circleElaser {
    self._radiusSlider.hidden = YES;
    self.elaserBufferZone.hidden = YES;
    [_mapView removeOverlay:circle];
}

-(void)routeDirectionTable {
   
    [drawer hideAnimated:YES];
    [_viewGesture removeFromSuperview];
    [_transparentView close];
    
    MKUserTrackingBarButtonItem *buttonItem =
    [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = buttonItem;
 
    self.navigationItem.title = NSLocalizedString(@"Map", nil);
    
    _transparentView = [[HATransparentView alloc] init];
    _transparentView.backgroundColor = TransparentColor;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _transparentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115 + 270.0f, _transparentView.frame.size.width, _transparentView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height )];
        
        _routeDirection = [[UILabel alloc] initWithFrame:CGRectMake(0,80, _transparentView.frame.size.width, 15)];
        _routeDirection.text = @"Route Direction";
        _routeDirection.font = [UIFont boldSystemFontOfSize:14];
        _routeDirection.backgroundColor = [UIColor clearColor];
        _routeDirection.textColor = [UIColor whiteColor];//[UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
        _routeDirection.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:_routeDirection];
        
    } else {
        _transparentView.frame = CGRectMake(224, 250 + 270.0f, 320, 290); //iPad
        _transparentView.layer.cornerRadius = 16.0f;
        //_transparentView.layer.borderWidth = 1.0f;
       // _transparentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
       // _transparentView.layer.masksToBounds = YES;
        _transparentView.opaque = NO;
       // _transparentView.alpha = .95f;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, _transparentView.frame.size.width, _transparentView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height -20)];

        _routeDirection = [[UILabel alloc] initWithFrame:CGRectMake(0,20, _transparentView.frame.size.width, 15)];
        _routeDirection.text = @"Route Direction";
        _routeDirection.font = [UIFont boldSystemFontOfSize:14];
        _routeDirection.backgroundColor = [UIColor clearColor];
        _routeDirection.textColor = [UIColor whiteColor];//[UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
        _routeDirection.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:_routeDirection];
    }
    
    [self.routeDirectionChangedSegmentedControl addTarget:self action:@selector(routeValueChange) forControlEvents:UIControlEventValueChanged];
    _routeDirectionChangedSegmentedControl.frame = CGRectMake(60,_routeDirection.frame.size.height + _routeDirection.frame.origin.y + 15, 200, 40);//1213
    [_transparentView addSubview:_routeDirectionChangedSegmentedControl];
    
    _routeChagePositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _routeChagePositionButton.frame = CGRectMake(15,_routeDirection.frame.size.height + _routeDirection.frame.origin.y + 95, 30, 30);
    [_routeChagePositionButton setImage:[UIImage imageNamed:@"switch_dest_1"] forState:UIControlStateNormal];
    
    _routeChagePositionButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    [_routeChagePositionButton addTarget:self action:@selector(changePositionRoute :) forControlEvents:UIControlEventTouchUpInside];
    [_transparentView addSubview:_routeChagePositionButton];
    
    UIColor *floatingLabelColor = [UIColor whiteColor];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(kJVFieldHMargin ,_routeDirectionChangedSegmentedControl.frame.size.height + _routeDirectionChangedSegmentedControl.frame.origin.y +9.0f, _transparentView.frame.size.width - 2*kJVFieldHMargin ,1.0f);
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
    [_transparentView addSubview:line];
    
    _startField = [[JVFloatLabeledTextField alloc] initWithFrame:
                   CGRectMake(kJVFieldHMargin + _routeChagePositionButton.frame.size.width +_routeChagePositionButton.frame.origin.x +10,_routeDirectionChangedSegmentedControl.frame.size.height + _routeDirectionChangedSegmentedControl.frame.origin.y +10, _transparentView.frame.size.width - 2*kJVFieldHMargin -45,
                              kJVFieldHeight)];
    _startField.placeholder = NSLocalizedString(@"Start", @"");
    _startField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Start", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _startField.text = @"Current location";
    _startField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _startField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _startField.floatingLabelTextColor = floatingLabelColor;
    // if (_startField.text != nil && ![_startField.text isEqualToString:@"Current location"]) {
    
    //     _startField.textColor = [UIColor blueColor];
    //  } else if ([_startField.text  isEqualToString: @"Current location"]) {
    
    _startField.textColor = [UIColor whiteColor];
    // }
    _startField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_transparentView addSubview:_startField];
    
    UIView *line1 = [UIView new];
    line1.frame = CGRectMake(kJVFieldHMargin + _routeChagePositionButton.frame.size.width +_routeChagePositionButton.frame.origin.x +10,_startField.frame.size.height +_startField.frame.origin.y, _startField.frame.size.width -10, 1.0f);
    line1.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
    [_transparentView addSubview:line1];
    
    _endField = [[JVFloatLabeledTextField alloc] initWithFrame:
                 CGRectMake(kJVFieldHMargin + _routeChagePositionButton.frame.size.width +_routeChagePositionButton.frame.origin.x +10,_startField.frame.size.height +_startField.frame.origin.y +1.0f, _transparentView.frame.size.width - 2*kJVFieldHMargin - 45, kJVFieldHeight)];
    _endField.placeholder = NSLocalizedString(@"End", @"");
    _endField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"End", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    if (route_from == ROUTE_FROM_BAR) {
        RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
        _endField.text = selectedAnnotation.title;
    } else if (route_from == ROUTE_FROM_TABLE) {
        
        _endField.text = selectedRecord.title;
    }
    
    // RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
    // _endField.text = selectedAnnotation.title;
    
    _endField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _endField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _endField.floatingLabelTextColor = floatingLabelColor;
    _endField.textColor = [UIColor whiteColor];
    _endField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_transparentView addSubview:_endField];
    
    UIView *line2 = [UIView new];
    line2.frame = CGRectMake(kJVFieldHMargin ,line1.frame.size.height +line1.frame.origin.y + kJVFieldHeight, _transparentView.frame.size.width - 2*kJVFieldHMargin ,
                             1.0f);
    line2.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
    [_transparentView addSubview:line2];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(60,line2.frame.size.height +line2.frame.origin.y +5, _transparentView.frame.size.width, 15)];
    text.text = @"Current location";//@"* ''Current location'' = This Here!";
    text.font = [UIFont boldSystemFontOfSize:12];
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor grayColor];
    text.textAlignment = NSTextAlignmentLeft;
    //[view addSubview:text];
    
    UIButton *route = [UIButton buttonWithType:UIButtonTypeCustom];
    route.frame = CGRectMake(_transparentView.frame.size.width/2 - 50, line2.frame.size.height +line2.frame.origin.y +15, 100, 30);//35 for insert text
    //[buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
    [route setTitle:@"Route" forState:UIControlStateNormal];
    route.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    route.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0];
    //[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1];
    route.titleLabel.textAlignment = NSTextAlignmentLeft;
    route.layer.backgroundColor = [UIColor clearColor].CGColor;//[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
    route.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
    route.layer.borderWidth = 1.0f;
    route.layer.cornerRadius = 15.0f;
    [route addTarget:self action:@selector(routePolyline) forControlEvents:UIControlEventTouchUpInside];
    [_transparentView addSubview:route];
    
    /*    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
     cancel.frame = CGRectMake(_transparentView.frame.size.width - 68, line2.frame.size.height +line2.frame.origin.y +30, 55, 20);
     //[buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
     [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
     cancel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
     cancel.titleLabel.textColor = [UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1];
     // cancel.titleLabel.textAlignment = NSTextAlignmentRight;
     cancel.layer.backgroundColor = [UIColor clearColor].CGColor;//[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
     [cancel addTarget:self action:@selector(closeTransparentView) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:cancel];*/
    

    [_transparentView open];
    [self.view addSubview:_transparentView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cell_type_to_display = TBL_DIRECTION_CELL;
    
    [_transparentView addSubview:_tableView];
    
    _tableView.tableHeaderView = ({

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];//270.0f
    // add detail on head route view
                view;
    });
    route_type = ROUTE_START_END;
    [_startField becomeFirstResponder];
}

-(void) routeValueChange {
    switch (self.routeDirectionChangedSegmentedControl.selectedSegmentIndex) {
        case 0:
            [_stepRoute setImage:[UIImage imageNamed:@"car.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [_stepRoute setImage:[UIImage imageNamed:@"walk.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [_stepRoute setImage:[UIImage imageNamed:@"bus.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)changePositionRoute:(UIButton *)sender {
    if (sender.selected) {
        _startField.placeholder = NSLocalizedString(@"Start", @"");
        _startField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Start", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _endField.placeholder = NSLocalizedString(@"End", @"");
        _endField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"End", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        route_type = ROUTE_START_END;
    } else {
        _endField.placeholder = NSLocalizedString(@"Start", @"");
        _endField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Start", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _startField.placeholder = NSLocalizedString(@"End", @"");
        _startField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"End", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        route_type = ROUTE_END_START;
    }
    sender.selected = !sender.selected;
}

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    if (route_type == ROUTE_END_START) {
        directionsRequest.source = destination;
        directionsRequest.destination = source;
    } else if (route_type == ROUTE_START_END) {
        directionsRequest.source = source;
        directionsRequest.destination = destination;
    }
    
    if (_routeDirectionChangedSegmentedControl.selectedSegmentIndex == 0) {
        directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    } else if (_routeDirectionChangedSegmentedControl.selectedSegmentIndex == 1) {
        directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    } else {
        directionsRequest.transportType = MKDirectionsTransportTypeAny;
    }
    //request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"There was an error getting your directions");
          
            [_progressView stopAnimating];
            [self setTitle:@"Map"];//---[self hideLoadingMode];
            
            [blurView removeFromSuperview];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            _mapChageButton.enabled = YES;
            _listChageButton.enabled = YES;
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"Route Error!"];
            [self closeTransparentView];
            return;
        }
        
        _currentRoute = [response.routes lastObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}

- (void)findDirectionBetweenCurrent_Pin {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Calculating..."];
    
    MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];
    
    
    if (route_from == ROUTE_FROM_BAR) {
        RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
        
        CLLocationCoordinate2D Coord = CLLocationCoordinate2DMake(selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
        
        MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:Coord addressDictionary:nil];
        MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:end];
        
        [self findDirectionsFrom:startItem to:endItem];
    } else if (route_from == ROUTE_FROM_TABLE) {
        
        CLLocationCoordinate2D Coord = CLLocationCoordinate2DMake(selectedRecord.coordinate.latitude, selectedRecord.coordinate.longitude);
        
        MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:Coord addressDictionary:nil];
        MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:end];
        
        [self findDirectionsFrom:startItem to:endItem];
    }
}

- (void)findDirectionBetweenSearch_Pin {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Calculating..."];

    NSString *searchString = [_startField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *status = [responseObject valueForKeyPath:@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [responseObject valueForKeyPath:@"results"];
            
            for (id result in results) {
                
                if (route_from == ROUTE_FROM_BAR) {
            
                    CLLocationCoordinate2D coord = [self coordinateFromJSON:result];
                    MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
                    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:start];
                    
                    RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
                    CLLocationCoordinate2D Coord = CLLocationCoordinate2DMake(selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
                    
                    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:Coord addressDictionary:nil];
                    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:end];
                    
                    [self findDirectionsFrom:startItem to:endItem];
                } else if (route_from == ROUTE_FROM_TABLE) {
                    
                    CLLocationCoordinate2D coord = [self coordinateFromJSON:result];
                    MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
                    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:start];
                    
                    RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
                    CLLocationCoordinate2D Coord = CLLocationCoordinate2DMake(selectedAnnotation.coordinate.latitude, selectedAnnotation.coordinate.longitude);
                    
                    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:Coord addressDictionary:nil];
                    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:end];
                    
                    [self findDirectionsFrom:startItem to:endItem];
                }
             /*   if (self.notQTree == nil) {
                    self.notQTree = [NotQTree new];
                } else {
                    
                }
                toAdd = [[MKPointAnnotation alloc]init];
                toAdd.coordinate = Coord;
                
                NSDictionary *addressDictionary = [self addressDictionaryFromJSON:result];
                NSArray *addressLines = [addressDictionary objectForKey:@"FormattedAddressLines"];
                
                GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
                UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:coord];
                
                toAdd.title = [addressLines componentsJoinedByString:@", "];
                toAdd.subtitle = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];
                [_mapView addAnnotation:toAdd];
                [__pins addObject:toAdd];
                [self.notQTree insertObject:toAdd];
                [self reloadAnnotations];*/
            }
        }
    } failure:nil];
    [operation start];
}
- (void)findDirectionBetweenCurrent_Search {
  
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Calculating..."];
    
    NSString *endField;
    
    if ([_endField.text isEqualToString: @"Current location"]) {
        endField = _startField.text;
    } else {
        endField = _endField.text;
    }

    NSString *searchString = [endField stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *status = [responseObject valueForKeyPath:@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [responseObject valueForKeyPath:@"results"];
            
            for (id result in results) {
                if ([_startField.text isEqualToString: @"Current location"]) {
                    
                    CLLocationCoordinate2D Coord = [self coordinateFromJSON:result];
                    
                    MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];
                    
                    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:Coord addressDictionary:nil];
                    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:end];
                    
                    [self findDirectionsFrom:startItem to:endItem];
                } else {
                    CLLocationCoordinate2D Coord = [self coordinateFromJSON:result];
                    
                    MKMapItem *endItem = [MKMapItem mapItemForCurrentLocation];
                    
                    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:Coord addressDictionary:nil];
                    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:end];
                    
                    [self findDirectionsFrom:startItem to:endItem];
                }
            }
        }
    } failure:nil];
    [operation start];
}

- (void)findDirectionBetweenSearch_Search {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Calculating..."];

    NSString *searchString = [_startField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *status = [responseObject valueForKeyPath:@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [responseObject valueForKeyPath:@"results"];
            
            for (id result in results) {
               CLLocationCoordinate2D _startCoord = [self coordinateFromJSON:result];
                
                MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:_startCoord addressDictionary:nil];
                MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:start];
       
                [self searchFindDirectionsFrom:startItem];
            }
        }
    } failure:nil];
    [operation start];
}

- (void)searchFindDirectionsFrom:(MKMapItem *)source {
    
    NSString *searchString = [_endField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *status = [responseObject valueForKeyPath:@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = [responseObject valueForKeyPath:@"results"];
            
            for (id result in results) {
                
                CLLocationCoordinate2D _endCoord = [self coordinateFromJSON:result];
                
                MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:_endCoord addressDictionary:nil];
                MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:end];
                
                [self findDirectionsFrom:source to:endItem];
            }
        }
    } failure:nil];
    [operation start];
}

-(void)routePolyline {

    [_transparentView close];
    
   // RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
    
    if (route_from == ROUTE_FROM_BAR) {
        RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
 
        if ([_startField.text isEqualToString: @"Current location"] && [_endField.text isEqualToString:selectedAnnotation.title]) {
            [self findDirectionBetweenCurrent_Pin];
        } else if ([_endField.text isEqualToString:selectedAnnotation.title]){
            [self findDirectionBetweenSearch_Pin];
        } else if ([_startField.text isEqualToString: @"Current location"]||[_endField.text isEqualToString: @"Current location"]) {
            [self findDirectionBetweenCurrent_Search];
        } else {
            [self findDirectionBetweenSearch_Search];
        }
    } else if (route_from == ROUTE_FROM_TABLE) {
        
        if ([_startField.text isEqualToString: @"Current location"] && [_endField.text isEqualToString:selectedRecord.title]) {
            [self findDirectionBetweenCurrent_Pin];
        } else if ([_endField.text isEqualToString:selectedRecord.title]){
            [self findDirectionBetweenSearch_Pin];
        } else if ([_startField.text isEqualToString: @"Current location"]||[_endField.text isEqualToString: @"Current location"]) {
            [self findDirectionBetweenCurrent_Search];
        } else {
            [self findDirectionBetweenSearch_Search];
        }
    
    }
    
}
#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [_mapView removeOverlay:_routeOverlay];
    }
    _routeOverlay = route.polyline;
    
    _routeOverlay.title = @"polylineRoute";
    [_mapView addOverlay:_routeOverlay];
    
    [_transparentView close];
    
    [_progressView stopAnimating];
    [self setTitle:@"Map"];//---[self hideLoadingMode];
    
    self.navigationItem.leftBarButtonItem.enabled = YES;
    _mapChageButton.enabled = YES;
    _listChageButton.enabled = YES;
    [blurView removeFromSuperview];
    [CSNotificationView showInViewController:self
                                       style:CSNotificationViewStyleSuccess
                                     message:@"Route Success"];
    _routeDistance.text = [NSString stringWithFormat:@"%0.1f km",_currentRoute.distance / 1000.0];
    self.routeDistance.hidden = NO;
    self.stepRoute.hidden = NO;
    self.elaserRoute.hidden = NO;
    
    [self setMapRegion];
}

-(void)routeDirectionElaser {
    self.routeDistance.hidden = YES;
    self.stepRoute.hidden = YES;
    self.elaserRoute.hidden = YES;
    
    [_mapView removeOverlay:_routeOverlay];
}

- (IBAction)routeDirection:(id)sender {
    if (stepRoutePopoverController == nil)
    {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [self performSegueWithIdentifier:@"Route" sender:self];
        [drawer hideAnimated:YES];
    } else {
        
        UIView *btn = [UIView new];
        btn.frame = CGRectMake(0, 0, _mapView.frame.size.width*2 - 80 , 170);
       // UIView *btn = (UIView *)sender;
        
        StepRouteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StepRouteViewController"];
        controller.preferredContentSize = CGSizeMake(320, 480);
        controller.route = _currentRoute;
        controller.modalInPopover = NO;
        
        [controller.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStyleBordered target:self action:@selector(close:)]];
        
        UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        stepRoutePopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
        stepRoutePopoverController.delegate = self;
        stepRoutePopoverController.passthroughViews = @[btn];
        stepRoutePopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        stepRoutePopoverController.wantsDefaultContentAppearance = NO;
        
        [stepRoutePopoverController presentPopoverFromRect:btn.bounds
                                                 inView:self.view
                               permittedArrowDirections:WYPopoverArrowDirectionAny
                                               animated:YES
                                                options:WYPopoverAnimationOptionFadeWithScale];
        }
    } else {
        [self close:nil];
    }
    [drawer hideAnimated:YES];
}
- (void)close:(id)sender
{
    [stepRoutePopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:stepRoutePopoverController];
    }];
}

-(void)showTableDatabase {
   // [self removeDigitize];
    
    [_transparentView close];
    [drawer hideAnimated:YES];
    
  /*  NSArray *pin = [_mapView annotations];
    [pinRecords removeAllObjects];
    [_mapView removeAnnotations:pin];
   
    self.notQTree = [NotQTree new];
    [self reloadAnnotations];*/
//    self.switchUpdateIfExist.hidden = YES;
    
    _transparentView = [[HATransparentView alloc] init];
    _transparentView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:0.95];//[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _transparentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, _transparentView.frame.size.width, _transparentView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height - 20)];
        if ([records count] <= 1) {
            stringListPin = [NSString stringWithFormat:@"%lu Pin",(unsigned long)[records count]];
        } else {
          stringListPin = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
        }
        self.navigationItem.title = stringListPin;
    } else {
        _transparentView.frame = CGRectMake(428, 80, 320, 500); //iPad
        _transparentView.layer.cornerRadius = 16.0f;
       // _transparentView.layer.borderWidth = 1.0f;
       // _transparentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
       // _transparentView.layer.masksToBounds = YES;
        _transparentView.opaque = NO;
        _transparentView.alpha = .95f;
        
        _transparentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _transparentView.layer.shadowOpacity = 0.5;
        _transparentView.layer.shadowOffset = CGSizeMake(0, 1);
        _transparentView.layer.shadowRadius = 16;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, _transparentView.frame.size.width, _transparentView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height -16)];
        
        self.navigationItem.title = NSLocalizedString(@"Map", nil);
        
        _listOfPin = [[UILabel alloc] initWithFrame:CGRectMake(0,17, _transparentView.frame.size.width, 20)];
        if ([records count] <= 1) {
            stringListPin = [NSString stringWithFormat:@"%lu Pin",(unsigned long)[records count]];
        } else {
            stringListPin = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
        }
        _listOfPin.text = stringListPin;
        _listOfPin.font = [UIFont boldSystemFontOfSize:17];
        _listOfPin.backgroundColor = [UIColor clearColor];
        _listOfPin.textColor = [UIColor whiteColor];//[UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
        _listOfPin.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:_listOfPin];
 
        _db = [UIButton buttonWithType:UIButtonTypeCustom];
        _db.frame = CGRectMake(_transparentView.frame.size.width -45, 8, 30, 30);
        [_db setImage:[UIImage imageNamed:@"pin_list"] forState:UIControlStateNormal];
        
        _db.layer.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:0.95].CGColor;//[UIColor clearColor].CGColor;
       
        [_db addTarget:self action:@selector(showAllPin) forControlEvents:UIControlEventTouchUpInside];
        [_transparentView addSubview:_db];
        
        UIView *lineUnder = [UIView new];
        lineUnder.frame = CGRectMake( 0, 43, _transparentView.frame.size.width, 1.0f);
        lineUnder.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0f];
        //[_transparentView addSubview:lineUnder];
    }
    [_transparentView open];
    [self.view addSubview:_transparentView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    cell_type_to_display = TBL_CELL_NONE;
    
    [_transparentView addSubview:_tableView];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, _tableView.frame.size.width, 44);
    } else {
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    }
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    self.tableView.contentOffset = CGPointMake(0,self.searchDisplayController.searchBar.frame.size.height);
    
    self.searchDisplayController.searchResultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.f, 0.f, 0.f);

    [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];

    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTransparentView)];
    UIBarButtonItem *editTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,editTabledelete, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
}

-(void)showAllPin {
    NSArray *area = [_mapView annotations];
    
    MKMapRect flyTo = MKMapRectNull;
   
    for (id <MKAnnotation> annotation in area) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    _mapView.visibleMapRect = flyTo;
}
/*- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
 
    } else{
        self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
}*/

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {

    self.searchDisplayController.searchBar.frame = CGRectMake(0, 0, _tableView.frame.size.width, 44);
     [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
}

-(void)editTableDelete {
    [self.tableView setEditing:YES animated:YES];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.title = NSLocalizedString(@"", nil);
    
    UIBarButtonItem *actionSheetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ShowActionSheet:)];
    UIBarButtonItem *deleteAllRecords = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllRecords:)];
    UIBarButtonItem *doneTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:doneTabledelete,deleteAllRecords,actionSheetButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
}

-(void)doneTableDelete {
    [self.tableView setEditing:NO animated:YES];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([records count] <= 1) {
            stringListPin = [NSString stringWithFormat:@"%lu Pin",(unsigned long)[records count]];
        } else {
            stringListPin = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
        }
        self.navigationItem.title = stringListPin;
    } else {
        self.navigationItem.title = NSLocalizedString(@"Map", nil);
        if ([records count] <= 1) {
            stringListPin = [NSString stringWithFormat:@"%lu Pin",(unsigned long)[records count]];
        } else {
            stringListPin = [NSString stringWithFormat:@"%lu Pins",(unsigned long)[records count]];
        }
        _listOfPin.text = stringListPin;
    }
    UIBarButtonItem *closeTransparentView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTransparentView)];
    UIBarButtonItem *editTabledelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableDelete)];
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:closeTransparentView,editTabledelete, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
    [self mainmenu];
}

-(void)closeTransparentView {

    [_transparentView close];
    
    [self reloadAnnotations];

    MKUserTrackingBarButtonItem *buttonItem =
    [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    NSArray* buttonArrays = [[NSArray alloc] initWithObjects:buttonItem, nil];
    self.navigationItem.rightBarButtonItems = buttonArrays;
    
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    self.navigationItem.title = NSLocalizedString(@"Map", nil);
}

-(void)addPinToMapDatabase {
    
  //  self.switchUpdateIfExist.hidden = NO;
    
    [self closeTransparentView];
    [drawer hideAnimated:YES];

    _transparentView = [[HATransparentView alloc] init];
    _transparentView.backgroundColor = TransparentColor;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _transparentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, _transparentView.frame.size.width, _transparentView.frame.size.height - 104)];
        
        UILabel *addPin = [[UILabel alloc] initWithFrame:CGRectMake(0,80, _transparentView.frame.size.width, 15)];
        addPin.text = @"Add pin";
        addPin.font = [UIFont boldSystemFontOfSize:12];
        addPin.backgroundColor = [UIColor clearColor];
        addPin.textColor = [UIColor whiteColor];
        addPin.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:addPin];
    } else {
        _transparentView.frame = CGRectMake(224, 250, 320, 400); //iPad
        _transparentView.layer.cornerRadius = 10.0f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, _transparentView.frame.size.width, _transparentView.frame.size.height - 50)];
        
        UILabel *addPin = [[UILabel alloc] initWithFrame:CGRectMake(0,20, _transparentView.frame.size.width, 15)];
        addPin.text = @"Add pin";
        addPin.font = [UIFont boldSystemFontOfSize:12];
        addPin.backgroundColor = [UIColor clearColor];
        addPin.textColor = [UIColor whiteColor];
        addPin.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:addPin];
    }
    [_transparentView open];
    [self.view addSubview:_transparentView];
    
    // Add a tableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cell_type_to_display = TBL_ADDPIN_CELL;
    
    [_transparentView addSubview:_tableView];
    
    _tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 590.0f)];
        
      //  CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height + 40;

        UIColor *floatingLabelColor = [UIColor whiteColor];
        
        self.switchUpdateIfExist.frame = CGRectMake(_transparentView.frame.size.width - kJVFieldHMargin - 65, 0, 0, 0);
        [view addSubview:self.switchUpdateIfExist];
        
        UILabel *update = [[UILabel alloc] initWithFrame:CGRectMake(kJVFieldHMargin,5, 0, 0)];
        update.text = @"Update if Name exist :";
        update.font = [UIFont boldSystemFontOfSize:15];
        update.backgroundColor = [UIColor clearColor];
        update.textColor = [UIColor whiteColor];
        [update sizeToFit];
        [view addSubview:update];
        
        UIView *div = [UIView new];
        div.frame = CGRectMake(kJVFieldHMargin,self.switchUpdateIfExist.frame.size.height + self.switchUpdateIfExist.frame.origin.y + 10, self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
        div.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:div];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kJVFieldHMargin,div.frame.size.height + div.frame.origin.y + 5, 80, 80)];

        dataImage = nil;
        _imageView.image = [UIImage imageNamed:@"noImage"];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 40.0;
        _imageView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.7].CGColor;
        _imageView.layer.borderWidth = 1.0f;
        _imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _imageView.layer.shouldRasterize = YES;
        _imageView.clipsToBounds = YES;
        _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageView.layer.shadowOpacity = 0.2;
        _imageView.layer.shadowOffset = CGSizeMake(0, 1);
        _imageView.layer.shadowRadius = 2.0f;
        
        _addImage= [[UIButton alloc] initWithFrame:CGRectMake(_imageView.frame.size.width + _imageView.frame.origin.x + 10, div.frame.size.height + div.frame.origin.y + 33, 24, 24)];
        [_addImage setTitle:@"+" forState:UIControlStateNormal];
        [_addImage setTitleColor:[UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        _addImage.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
        _addImage.backgroundColor = [UIColor clearColor];
        _addImage.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
        _addImage.layer.borderWidth = 1.0f;
        _addImage.layer.cornerRadius = 12.0f;
        _addImage.opaque = NO;
        _addImage.alpha = 1.0f;
        [_addImage addTarget:self action:@selector(actionSheetAddPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:_addImage];
        [view addSubview:_imageView];
        
        UIView *divBetweenImageWithName = [UIView new];
        divBetweenImageWithName.frame = CGRectMake(kJVFieldHMargin,_imageView.frame.size.height + _imageView.frame.origin.y + 5, self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
        divBetweenImageWithName.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:divBetweenImageWithName];
        
        _nameField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                               CGRectMake(kJVFieldHMargin, divBetweenImageWithName.frame.origin.y + divBetweenImageWithName.frame.size.height, _transparentView.frame.size.width - 10 * kJVFieldHMargin -40, kJVFieldHeight)];
        _nameField.placeholder = NSLocalizedString(@"Name", @"");
        _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Name", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _nameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _nameField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _nameField.floatingLabelTextColor = floatingLabelColor;
        _nameField.textColor = [UIColor whiteColor];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [view addSubview:_nameField];
        
        UIView *div1 = [UIView new];
        div1.frame = CGRectMake(kJVFieldHMargin, _nameField.frame.origin.y + _nameField.frame.size.height, self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
        div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:div1];
        
        _pinTypeField = [[JVFloatLabeledTextField alloc] initWithFrame:
                                                 CGRectMake(kJVFieldHMargin + kJVFieldHMargin + _nameField.frame.size.width ,
                                                            divBetweenImageWithName.frame.origin.y + divBetweenImageWithName.frame.size.height + 1.0f, self.view.frame.size.width - 3*kJVFieldHMargin - _nameField.frame.size.width - 1.0f,
                                                            kJVFieldHeight)];
        _pinTypeField.placeholder = NSLocalizedString(@"Pin type", @"");
        _pinTypeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pin type", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _pinTypeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _pinTypeField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _pinTypeField.floatingLabelTextColor = floatingLabelColor;
        _pinTypeField.textColor = [UIColor whiteColor];
        _pinTypeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [view addSubview:_pinTypeField];
        
        UIView *div2 = [UIView new];
        div2.frame = CGRectMake(kJVFieldHMargin + _nameField.frame.size.width,divBetweenImageWithName.frame.origin.y + divBetweenImageWithName.frame.size.height,
                                1.0f, kJVFieldHeight);
        div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:div2];
        
        _descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectZero];
        _descriptionField.frame = CGRectMake(kJVFieldHMargin - _descriptionField.textContainer.lineFragmentPadding,
                                            div1.frame.origin.y + div1.frame.size.height,
                                            self.view.frame.size.width - 2*kJVFieldHMargin + _descriptionField.textContainer.lineFragmentPadding,
                                            kJVFieldHeight*3);
        _descriptionField.placeholder = NSLocalizedString(@"Description", @"");
        _descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _descriptionField.floatingLabelTextColor = floatingLabelColor;
        _descriptionField.textColor = [UIColor whiteColor];
        _descriptionField.backgroundColor = [UIColor clearColor];
        [view addSubview:_descriptionField];
        
        UIView *div3 = [UIView new];
        div3.frame = CGRectMake(kJVFieldHMargin, _descriptionField.frame.origin.y + _descriptionField.frame.size.height, self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
        div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:div3];

        UILabel *coordinate = [[UILabel alloc] initWithFrame:CGRectMake(kJVFieldHMargin,div3.frame.origin.y + div3.frame.size.height +5, _transparentView.frame.size.width - 2*kJVFieldHMargin, 15)];
        coordinate.text = @"Coordinate :";
        coordinate.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        coordinate.backgroundColor = [UIColor clearColor];
        coordinate.textColor = [UIColor whiteColor];
        coordinate.textAlignment = NSTextAlignmentLeft;
        [view addSubview:coordinate];
        
        self.centerMap.text = @"Center";
        self.centerMap.textAlignment = NSTextAlignmentRight;
        self.centerMap.backgroundColor = [UIColor clearColor];
        
        self.fromCoordinate.text = @"Specify";
        self.fromCoordinate.textAlignment = NSTextAlignmentLeft;
        self.fromCoordinate.backgroundColor = [UIColor clearColor];
    
        [self.addCoordinateSegmentedControl addTarget:self action:@selector(addCoordinateValueChange) forControlEvents:UIControlEventValueChanged];
        [view addSubview:self.addCoordinateSegmentedControl];
        
        
        self.centerMap.frame = CGRectMake(kJVFieldHMargin,div3.frame.origin.y + div3.frame.size.height + 25, 120 - kJVFieldHMargin, 20);
        self.fromCoordinate.frame = CGRectMake(200,div3.frame.origin.y + div3.frame.size.height + 25, 140 - kJVFieldHMargin, 20);
        self.addCoordinateSegmentedControl.frame = CGRectMake(140,div3.frame.origin.y + div3.frame.size.height + 25, 40, 20);
        
        [view addSubview:self.centerMap];
        [view addSubview:self.fromCoordinate];
        
        UIView *div4 = [UIView new];
        div4.frame = CGRectMake(kJVFieldHMargin, _addCoordinateSegmentedControl.frame.origin.y + _addCoordinateSegmentedControl.frame.size.height +5, self.view.frame.size.width - 2*kJVFieldHMargin, 1.0f);
        div4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:div4];
        
        self.convertCoordinateSegmentedControl.frame = CGRectMake(60, div4.frame.origin.y + div4.frame.size.height + 10, 200, 25);
        [self.convertCoordinateSegmentedControl addTarget:self action:@selector(coordinateValueChange) forControlEvents:UIControlEventValueChanged];
        [view addSubview:self.convertCoordinateSegmentedControl];
        
        _easting_x = [[JVFloatLabeledTextField alloc] initWithFrame:
                      CGRectMake(kJVFieldHMargin, self.convertCoordinateSegmentedControl.frame.origin.y + self.convertCoordinateSegmentedControl.frame.size.height + 5, _transparentView.frame.size.width - 10 * kJVFieldHMargin, kJVFieldHeight)];
        
        _easting_x.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _easting_x.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _easting_x.floatingLabelTextColor = floatingLabelColor;
        _easting_x.textColor = [UIColor whiteColor];
        _easting_x.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_easting_x setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [_easting_x setDelegate:self];
        
        _div_pin1 = [UIView new];
        _div_pin1.frame = CGRectMake(kJVFieldHMargin, _easting_x.frame.origin.y + _easting_x.frame.size.height,
                                _transparentView.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
        _div_pin1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        
        _northing_y = [[JVFloatLabeledTextField alloc] initWithFrame:
                       CGRectMake(kJVFieldHMargin,
                                  _div_pin1.frame.origin.y + _div_pin1.frame.size.height,
                                  _transparentView.frame.size.width - 3*kJVFieldHMargin - 80.0f - 1.0f,
                                  kJVFieldHeight)];
        _northing_y.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _northing_y.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _northing_y.floatingLabelTextColor = floatingLabelColor;
        _northing_y.textColor = [UIColor whiteColor];
        _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _northing_y.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_northing_y setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [_northing_y setDelegate:self];
        
        _gridZone = [[JVFloatLabeledTextField alloc] initWithFrame:
                     CGRectMake(kJVFieldHMargin + kJVFieldHMargin + _northing_y.frame.size.width + 1.0f, _div_pin1.frame.origin.y + _div_pin1.frame.size.height, 80.0f, kJVFieldHeight)];
        _gridZone.placeholder = NSLocalizedString(@"Zone", @"");
        _gridZone.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        _gridZone.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        _gridZone.floatingLabelTextColor = floatingLabelColor;
        _gridZone.textColor = [UIColor whiteColor];
        _gridZone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Zone", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        _gridZone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_gridZone setKeyboardType:UIKeyboardTypeNumberPad];
        [_gridZone setDelegate:self];
        
        _div2 = [UIView new];
        _div2.frame = CGRectMake(kJVFieldHMargin + _northing_y.frame.size.width,
                                 _easting_x.frame.origin.y + _easting_x.frame.size.height + 1.0f, 1.0f, kJVFieldHeight);
        _div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        
        _div_pin2 = [UIView new];
        _div_pin2.frame = CGRectMake(kJVFieldHMargin, _gridZone.frame.origin.y + _gridZone.frame.size.height,
                                _transparentView.frame.size.width - 2*kJVFieldHMargin, 1.0f);
        _div_pin2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
        
        self.hemisphere.text = @"hemisphere :";
        self.hemisphere.textColor = [UIColor whiteColor];
        self.hemisphere.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
        self.hemisphere.backgroundColor = [UIColor clearColor];
        
        self.hemisphere.frame = CGRectMake(kJVFieldHMargin,_gridZone.frame.origin.y + _gridZone.frame.size.height + 10, 70, 20);
        self.hemisphereSegmentedControl.frame = CGRectMake(kJVFieldHMargin + _hemisphere.frame.origin.x + 70,_gridZone.frame.origin.y + _gridZone.frame.size.height + 10, 50, 20);
        
        [view addSubview:self.hemisphereSegmentedControl];
        [view addSubview:_easting_x];
        [view addSubview:_northing_y];
        [view addSubview:_gridZone];
        [view addSubview:_div_pin1];
        [view addSubview:_div2];
        [view addSubview:_div_pin2];
        [view addSubview:_hemisphere];
        
        _toAddPinDatabaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toAddPinDatabaseButton setTitle:@"+ Pin" forState:UIControlStateNormal];
        [_toAddPinDatabaseButton setTitleColor:[UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        _toAddPinDatabaseButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
        _toAddPinDatabaseButton.layer.borderWidth = 1.0f;
        _toAddPinDatabaseButton.layer.cornerRadius = 15.0f;
        [_toAddPinDatabaseButton addTarget:self action:@selector(toDatabase) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_toAddPinDatabaseButton];
        
        if (self.addCoordinateSegmentedControl.selectedSegmentIndex == 0) {
            self.centerMap.textColor = [UIColor whiteColor];
            self.centerMap.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.fromCoordinate.textColor = [UIColor lightGrayColor];
            self.fromCoordinate.font = [UIFont systemFontOfSize:14];
            self.convertCoordinateSegmentedControl.hidden = YES;
            _toAddPinDatabaseButton.frame = CGRectMake(105,self.addCoordinateSegmentedControl.frame.origin.y + self.addCoordinateSegmentedControl.frame.size.height + 15, 110, 32);
            _easting_x.hidden = YES;
            _northing_y.hidden = YES;
            _gridZone.hidden = YES;
            _div_pin1.hidden = YES;
            _div2.hidden = YES;
            _div_pin2.hidden = YES;
            _hemisphere.hidden = YES;
            _hemisphereSegmentedControl.hidden = YES;
        } else {
            self.centerMap.textColor = [UIColor lightGrayColor];
            self.centerMap.font = [UIFont systemFontOfSize:14];
            self.fromCoordinate.textColor = [UIColor whiteColor];
            self.fromCoordinate.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.convertCoordinateSegmentedControl.hidden = NO;
             _toAddPinDatabaseButton.frame = CGRectMake(105,_hemisphereSegmentedControl.frame.origin.y + _hemisphereSegmentedControl.frame.size.height + 10, 110, 32);
            
            if (_convertCoordinateSegmentedControl.selectedSegmentIndex == 0) {
                _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"x (easting)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _easting_x.placeholder = NSLocalizedString(@"x (easting)", @"");
                _northing_y.placeholder = NSLocalizedString(@"y (northing)", @"");
                _gridZone.hidden = NO;
                _div2.hidden = NO;
                _hemisphereSegmentedControl.hidden = NO;
                _hemisphere.hidden = NO;
            } else {
                _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Longitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Latitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _easting_x.placeholder = NSLocalizedString(@"Longitude", @"");
                _northing_y.placeholder = NSLocalizedString(@"Latitude", @"");
                _gridZone.hidden = YES;
                _div2.hidden = YES;
                _hemisphereSegmentedControl.hidden = YES;
                _hemisphere.hidden = YES;
            }
            _easting_x.hidden = NO;
            _northing_y.hidden = NO;
            _div_pin1.hidden = NO;
            _div_pin2.hidden = NO;
        }
        view;
    });
    
    [_nameField becomeFirstResponder];
}

-(void) addCoordinateValueChange {
    switch (self.addCoordinateSegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.centerMap.textColor = [UIColor whiteColor];
            self.centerMap.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.fromCoordinate.textColor = [UIColor lightGrayColor];
            self.fromCoordinate.font = [UIFont systemFontOfSize:14];
            self.convertCoordinateSegmentedControl.hidden = YES;
            _toAddPinDatabaseButton.frame = CGRectMake(105,self.addCoordinateSegmentedControl.frame.origin.y + self.addCoordinateSegmentedControl.frame.size.height + 15, 110, 32);
            _easting_x.hidden = YES;
            _northing_y.hidden = YES;
            _gridZone.hidden = YES;
            _div_pin1.hidden = YES;
            _div2.hidden = YES;
            _div_pin2.hidden = YES;
            _hemisphere.hidden = YES;
            _hemisphereSegmentedControl.hidden = YES;
        }
            break;
        case 1:
        {
            self.centerMap.textColor = [UIColor lightGrayColor];
            self.centerMap.font = [UIFont systemFontOfSize:14];
            self.fromCoordinate.textColor = [UIColor whiteColor];
            self.fromCoordinate.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.convertCoordinateSegmentedControl.hidden = NO;
             _toAddPinDatabaseButton.frame = CGRectMake(105,_hemisphereSegmentedControl.frame.origin.y + _hemisphereSegmentedControl.frame.size.height + 10, 110, 32);
            
            if (_convertCoordinateSegmentedControl.selectedSegmentIndex == 0) {
                _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"x (easting)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _easting_x.placeholder = NSLocalizedString(@"x (easting)", @"");
                _northing_y.placeholder = NSLocalizedString(@"y (northing)", @"");
                _gridZone.hidden = NO;
                _div2.hidden = NO;
                _hemisphereSegmentedControl.hidden = NO;
                _hemisphere.hidden = NO;
            } else {
                _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Longitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Latitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _easting_x.placeholder = NSLocalizedString(@"Longitude", @"");
                _northing_y.placeholder = NSLocalizedString(@"Latitude", @"");
                _gridZone.hidden = YES;
                _div2.hidden = YES;
                _hemisphereSegmentedControl.hidden = YES;
                _hemisphere.hidden = YES;
            }
            _easting_x.hidden = NO;
            _northing_y.hidden = NO;
            _div_pin1.hidden = NO;
            _div_pin2.hidden = NO;
        }
            break;
        default:
            break;
    }
}

-(void)toDatabase {
    [_transparentView close];

    if (_addCoordinateSegmentedControl.selectedSegmentIndex == 0) {

        CLLocationCoordinate2D centerCoordinate = _mapView.centerCoordinate;
        
        _northing_y.text = [NSString stringWithFormat:@"%f",centerCoordinate.latitude];
        _easting_x.text = [NSString stringWithFormat:@"%f",centerCoordinate.longitude];
        
        NSDate *date = [NSDate date];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              _nameField.text,kName,
                              _pinTypeField.text,kType,
                              _northing_y.text,kCoordinate_y,
                              _easting_x.text,kCoordinate_x,
                              _descriptionField.text,kComment,date,KDate,dataImage,KPhoto,
                              nil];
        if (_switchUpdateIfExist.on) {
            [[MyDatabaseManager sharedManager] insertUpdateRecordInRecordTable:dict];
        } else {
            [[MyDatabaseManager sharedManager] insertRecordInRecordTable:dict];
        }
    } else {
        if (_convertCoordinateSegmentedControl.selectedSegmentIndex == 0) {
            
            UTMCoordinates coordinates;
            coordinates.gridZone = [_gridZone.text intValue];
            coordinates.northing = [_northing_y.text doubleValue];
            coordinates.easting = [_easting_x.text doubleValue];
            
            if (_hemisphereSegmentedControl.selectedSegmentIndex == 0) {
                coordinates.hemisphere = kUTMHemisphereNorthern;
            } else {
                coordinates.hemisphere = kUTMHemisphereSouthern;
            }
            GeodeticUTMConverter *converter = [[GeodeticUTMConverter alloc] init];
            CLLocationCoordinate2D addCoordinate = [converter UTMCoordinatesToLatitudeAndLongitude:coordinates];
            
            _northing_y.text = [NSString stringWithFormat:@"%f",addCoordinate.latitude];
            _easting_x.text = [NSString stringWithFormat:@"%f",addCoordinate.longitude];
            
            NSDate *date = [NSDate date];
            
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  _nameField.text,kName,
                                  _pinTypeField.text,kType,
                                  _northing_y.text,kCoordinate_y,
                                  _easting_x.text,kCoordinate_x,
                                  _descriptionField.text,kComment,date,KDate,dataImage,KPhoto,
                                  nil];
            if (_switchUpdateIfExist.on) {
                [[MyDatabaseManager sharedManager] insertUpdateRecordInRecordTable:dict];
            } else {
                [[MyDatabaseManager sharedManager] insertRecordInRecordTable:dict];
            }
        } else {
            NSDate *date = [NSDate date];
            
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  _nameField.text,kName,
                                  _pinTypeField.text,kType,
                                  _northing_y.text,kCoordinate_y,
                                  _easting_x.text,kCoordinate_x,
                                  _descriptionField.text,kComment,date,KDate,dataImage,KPhoto,
                                  nil];
            if (_switchUpdateIfExist.on) {
                [[MyDatabaseManager sharedManager] insertUpdateRecordInRecordTable:dict];
            } else {
                [[MyDatabaseManager sharedManager] insertRecordInRecordTable:dict];
            }
        }
    }    
    [self refreshTable];

    if (_switchUpdateIfExist.on) {
        [self reloadAnnotations];
    } else {
        [self updateLocations];
    }
    
    CLLocationCoordinate2D addCoordinate;
    addCoordinate.longitude = [_easting_x.text doubleValue];
    addCoordinate.latitude = [_northing_y.text doubleValue];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = addCoordinate;
    
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    
    imageListPin = [UIImage imageNamed:@"MlistPinBlue"];
    [self mainmenu];
}

-(void)actionSheetAddPhoto {
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Image", nil)];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Take photo", nil)
                              image:nil//[UIImage imageNamed:@"c_polyline"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self takePhoto];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Photo from library", nil)
                              image:nil//[UIImage imageNamed:@"c_polygon"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self choosePhotoFromLibrary];
                            }];
    [actionSheet show];
    
    [_nameField resignFirstResponder];
    [_pinTypeField resignFirstResponder];
    [_descriptionField resignFirstResponder];
}

-(void)takePhoto {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

-(void)choosePhotoFromLibrary {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    dataImage = UIImagePNGRepresentation(image);
    
    if ([self isViewLoaded]) {
        [self showImage:image];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancelled image picker controller");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

-(void)showImage:(UIImage *)theImage
{
    self.imageView.image = theImage;
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return cell_row;
 
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredRecords count];
    } else if  (cell_type_to_display == TBL_ADDPIN_CELL){
        return 0;
    } else if (cell_type_to_display == TBL_CELL_NONE){
        return [records count];
    } else if (cell_type_to_display == TBL_DIRECTION_CELL){
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *cellId = @"recordCell";

   // UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
  //  cell.accessoryView = (_selected == indexPath.row) ? check : nil;
   // return cell;
    
   // static NSString *CellIdentifier = @"recordCell";
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
       
    } else {
//--no line        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        RecordTables *record = [filteredRecords objectAtIndex:indexPath.row];
        
        cell.textLabel.text = record.name;
        cell.detailTextLabel.text = record.type;
        return cell;
        
    } else if (cell_type_to_display == TBL_CELL_NONE) {
       /* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        
        RecordTables *record = [records objectAtIndex:indexPath.row];

        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.0, 40.0)];//140 for Lat.Lon
        distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor grayColor];
        
        CLLocationCoordinate2D addCoordinate;
        addCoordinate.latitude = [record.coordinate_y doubleValue];
        addCoordinate.longitude = [record.coordinate_x doubleValue];
        
        GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
        UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:addCoordinate];
        
        cell.textLabel.text = record.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
      
      //  distanceLabel.text = [NSString stringWithFormat:@"Lat: %.2f , Lon: %.2f",addCoordinate.latitude,addCoordinate.longitude];
        distanceLabel.text = record.type;
        distanceLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = distanceLabel;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;*/
        
        static NSString *CellIdentifier = @"Cell";
        
        MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            // iOS 7 separator
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                cell.separatorInset = UIEdgeInsetsZero;
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        [self configureCell:cell forRowAtIndexPath:indexPath];

        return cell;
        
    } else if (cell_type_to_display == TBL_DIRECTION_CELL) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"NO Route";
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    return cell;
}



- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *images = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:images];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark - MCSwipeTableViewCellDelegate

// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    // NSLog(@"Did start swiping the cell!");
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
    // NSLog(@"Did end swiping the cell!");
}

// When the user is dragging, this method is called and return the dragged percentage from the border
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage {
    // NSLog(@"Did swipe with percentage : %f", percentage);
}

- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *routeView = [self viewWithImageName:@"pin_routeN"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
   // UIView *crossView = [self viewWithImageName:@"cross"];
   // UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

    UIView *gotoView = [self viewWithImageName:@"Goto"];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:[UIColor grayColor]];
    
    [cell setDelegate:self];
    
    RecordTables *record = [records objectAtIndex:indexPath.row];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.0, 40.0)];//140 for Lat.Lon
    distanceLabel.font = [UIFont systemFontOfSize:12.0f];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textColor = [UIColor grayColor];
    
    CLLocationCoordinate2D addCoordinate;
    addCoordinate.latitude = [record.coordinate_y doubleValue];
    addCoordinate.longitude = [record.coordinate_x doubleValue];
    
    GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
    UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:addCoordinate];
    
    cell.textLabel.text = record.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    //  distanceLabel.text = [NSString stringWithFormat:@"Lat: %.2f , Lon: %.2f",addCoordinate.latitude,addCoordinate.longitude];
    distanceLabel.text = record.type;
    distanceLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryView = distanceLabel;
    cell.editingAccessoryType = UITableViewCellAccessoryNone;
    
  /*  [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Cross\" cell");
        
        RecordTables *aRecord = [records objectAtIndex: indexPath.row];
        [[MyDatabaseManager sharedManager] deleteTableRecord:aRecord];
        
        [self updateLocations];
        
        [self refreshTable];
    }];*/
    
    [cell setSwipeGestureWithView:routeView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Cross\" cell");
        
        if (_tableView == self.searchDisplayController.searchResultsTableView) {
            selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
        } else {
            selectedRecord = [records objectAtIndex:indexPath.row];
        }
        
        route_from = ROUTE_FROM_TABLE;
        [self routeDirectionTable];

        MKUserTrackingBarButtonItem *buttonItem =
        [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
        self.navigationItem.rightBarButtonItem = buttonItem;
        
        NSArray* buttonArrays = [[NSArray alloc] initWithObjects:buttonItem, nil];
        self.navigationItem.rightBarButtonItems = buttonArrays;
        
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.title = NSLocalizedString(@"Map", nil);
        
        [self reloadAnnotations];
    }];
    
    [cell setSwipeGestureWithView:gotoView color:yellowColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Clock\" cell");
        
        if (_tableView == self.searchDisplayController.searchResultsTableView) {
            selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
        } else {
            selectedRecord = [records objectAtIndex:indexPath.row];
        }
        
        MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = [selectedRecord.coordinate_y doubleValue];
        region.center.longitude = [selectedRecord.coordinate_x doubleValue];
        region.span.longitudeDelta = 0.01f;
        region.span.latitudeDelta = 0.01f;
        [_mapView setRegion:region animated:YES];
        
        [self closeTransparentView];
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //_selected = indexPath.row;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
    } else {
        selectedRecord = [records objectAtIndex:indexPath.row];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [self performSegueWithIdentifier:@"TableToDetails" sender:self];
    } else {
        
        if (detailDatabasePopoverController == nil) {
            
            UIView *btn = [UIView new];
            btn.frame = CGRectMake(0, 0, _mapView.frame.size.width*2 - 95 , 130);
            
            DetailDatabaseViewController *detailDatabaseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailDatabaseViewController"];
            detailDatabaseViewController.preferredContentSize = CGSizeMake(320, 480);
            
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
                detailDatabaseViewController.record = selectedRecord;
            } else {
                selectedRecord = [records objectAtIndex:indexPath.row];
                detailDatabaseViewController.record = selectedRecord;
            }
            detailDatabaseViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:detailDatabaseViewController];
            
            detailDatabasePopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            detailDatabasePopoverController.delegate = self;
            detailDatabasePopoverController.passthroughViews = @[btn];
            detailDatabasePopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            detailDatabasePopoverController.wantsDefaultContentAppearance = NO;
            
            [detailDatabasePopoverController presentPopoverFromRect:btn.bounds
                                                             inView:self.view
                                           permittedArrowDirections:WYPopoverArrowDirectionAny
                                                           animated:YES
                                                            options:WYPopoverAnimationOptionFadeWithScale];
        } else {
          //  [self close:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        RecordTables *aRecord = [records objectAtIndex: indexPath.row];
        [[MyDatabaseManager sharedManager] deleteTableRecord:aRecord];

        [self updateLocations];

        [self refreshTable];
     }
}



/*-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Go to Point";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
    } else {
        selectedRecord = [records objectAtIndex:indexPath.row];
    }
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [selectedRecord.coordinate_y doubleValue];
    region.center.longitude = [selectedRecord.coordinate_x doubleValue];
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];
    
    [self closeTransparentView];
}*/

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    filteredRecords = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil where:scope contains:searchText];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

-(void)deleteAllRecords:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                      message:@"Do you want to delete all records"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"])
    {
        [[MyDatabaseManager sharedManager] deleteAllTableRecord];
        
        [self refreshTable];
        
        [self updateLocations];
        
        NSLog(@"Delete was selected.");
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel was selected.");
    }
    else if ([title isEqualToString:@"Next"])
    {
        [self NRFselectProvinceMenu];
    }
}

-(void)ShowActionSheet:(id)sender
{
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Sort list", nil)];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Sort by Name", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                sortingAttribute = kName;
                                [self refreshTable];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Sort by Type", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                sortingAttribute = kType;
                                [self refreshTable];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Sort by Description", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                sortingAttribute = kComment;
                                [self refreshTable];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Sort by Date", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                sortingAttribute = KDate;
                                [self refreshTable];
                            }];
    [actionSheet show];
}

/*-(void)setting {
    [_transparentView close];
    [drawer hideAnimated:YES];
    
    _transparentView = [[HATransparentView alloc] init];
    _transparentView.backgroundColor = TransparentColor;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _transparentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    } else {
        _transparentView.frame = CGRectMake(224, 250, 320, 320);
        _transparentView.layer.cornerRadius = 10.0f;
    }
    [_transparentView open];
    [self.view addSubview:_transparentView];
    
    self.mapChangedSegmentedControl.frame = CGRectMake(60,185, 200, 25);
    [_mapChangedSegmentedControl setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:0];
    [_mapChangedSegmentedControl setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:1];
    [_mapChangedSegmentedControl setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:2];
    [_transparentView addSubview:self.mapChangedSegmentedControl];
    
    self.onOffCluster.frame = CGRectMake(_transparentView.frame.size.width - kJVFieldHMargin - 65, 120, 0, 0);
    [_transparentView addSubview:self.onOffCluster];
    
    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin,115,_transparentView.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    UIView *div2 = [UIView new];
    div2.frame = CGRectMake(_transparentView.frame.size.width - 90,115 + 1.0f, 1.0f, 39);
    div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    UIView *div3 = [UIView new];
    div3.frame = CGRectMake(kJVFieldHMargin,155, _transparentView.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    UILabel *clusterPin = [[UILabel alloc] initWithFrame:CGRectMake(kJVFieldHMargin +15,125, 0, 0)];
    clusterPin.text = @"Cluster Pin";
    clusterPin.font = [UIFont boldSystemFontOfSize:15];
    clusterPin.backgroundColor = [UIColor clearColor];
    clusterPin.textColor = [UIColor whiteColor];
    [clusterPin sizeToFit];
    
    UILabel *setting = [[UILabel alloc] initWithFrame:CGRectMake(0,80, _transparentView.frame.size.width, 15)];
    setting.text = @"Setting Map";
    setting.font = [UIFont boldSystemFontOfSize:12];
    setting.backgroundColor = [UIColor clearColor];
    setting.textColor = [UIColor whiteColor];
    //[setting sizeToFit];
    setting.textAlignment = NSTextAlignmentCenter;
    
    [_transparentView addSubview:setting];
    [_transparentView addSubview:clusterPin];
    [_transparentView addSubview:div1];
    [_transparentView addSubview:div2];
    [_transparentView addSubview:div3];
}

- (IBAction)_mapTypeChage:(id)sender {
    
    switch (self.mapChangedSegmentedControl.selectedSegmentIndex) {
        case 0:
            _mapView.mapType = MKMapTypeStandard;
     
            break;
        case 1:
            _mapView.mapType = MKMapTypeSatellite;
    
            break;
        case 2:
            _mapView.mapType = MKMapTypeHybrid;
       
            break;
        default:
            break;
    }
}

-(IBAction)onOffSwitch:(id)sender {
    
    if(_onOffCluster.on) {
        [self reloadAnnotations];
    } else {
        [self reloadAnnotations];
    }
}*/


-(void)gotoCoordinate {
    [self closeTransparentView];
    [drawer hideAnimated:YES];
    
    _transparentView = [[HATransparentView alloc] init];
    _transparentView.backgroundColor = TransparentColor;
    
    UIView* divpre = [UIView new];
    divpre.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [_transparentView addSubview:divpre];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _transparentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
     
        divpre.frame = CGRectMake(kJVFieldHMargin, 115, _transparentView.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
       
        UILabel *search = [[UILabel alloc] initWithFrame:CGRectMake(kJVFieldHMargin,80, _transparentView.frame.size.width - 2*kJVFieldHMargin, 15)];
        search.text = @"Search Place";
        search.font = [UIFont boldSystemFontOfSize:12];
        search.backgroundColor = [UIColor clearColor];
        search.textColor = [UIColor whiteColor];
        search.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:search];
    } else {
        _transparentView.frame = CGRectMake(224, 250, 320, 360);
        _transparentView.layer.cornerRadius = 10.0f;
        
        divpre.frame = CGRectMake(kJVFieldHMargin, 55, _transparentView.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
        
        UILabel *search = [[UILabel alloc] initWithFrame:CGRectMake(kJVFieldHMargin,20, _transparentView.frame.size.width - 2*kJVFieldHMargin, 15)];
        search.text = @"Search Place";
        search.font = [UIFont boldSystemFontOfSize:12];
        search.backgroundColor = [UIColor clearColor];
        search.textColor = [UIColor whiteColor];
        search.textAlignment = NSTextAlignmentCenter;
        [_transparentView addSubview:search];
    }
    [_transparentView open];
    [_transparentView addSubview:self.convertCoordinateSegmentedControl];
    [self.view addSubview:_transparentView];
    
    self.searchText.text = @"Text";
    self.searchText.textAlignment = NSTextAlignmentRight;
    self.searchText.backgroundColor = [UIColor clearColor];
    [_transparentView addSubview:_searchText];
    
    self.searchCoordinate.text = @"Coordinate";
    self.searchCoordinate.textAlignment = NSTextAlignmentLeft;
    self.searchCoordinate.backgroundColor = [UIColor clearColor];
    [_transparentView addSubview:_searchCoordinate];

    self.searchText.frame = CGRectMake(kJVFieldHMargin,divpre.frame.origin.y + divpre.frame.size.height + 25, 120 - kJVFieldHMargin, 20);
    
    self.searchCoordinate.frame = CGRectMake(200,divpre.frame.origin.y + divpre.frame.size.height + 25, 140 - kJVFieldHMargin, 20);
    
    self.SearchChangedSegmentedControl.frame = CGRectMake(140,divpre.frame.origin.y + divpre.frame.size.height + 25, 40, 20);
    [self.SearchChangedSegmentedControl addTarget:self action:@selector(searchValueChange) forControlEvents:UIControlEventValueChanged];
    [_transparentView addSubview:self.SearchChangedSegmentedControl];
    
    UIView* divfirst = [UIView new];
    divfirst.frame = CGRectMake(kJVFieldHMargin, self.SearchChangedSegmentedControl.frame.size.height + self.SearchChangedSegmentedControl.frame.origin.y + 5,
                             _transparentView.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    divfirst.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [_transparentView addSubview:divfirst];
    
    self.convertCoordinateSegmentedControl.frame = CGRectMake(60, divfirst.frame.size.height + divfirst.frame.origin.y + 10, 200, 25);
    [self.convertCoordinateSegmentedControl addTarget:self action:@selector(coordinateValueChange) forControlEvents:UIControlEventValueChanged];
    
    self.searchBar.frame = CGRectMake(0, divfirst.frame.size.height + divfirst.frame.origin.y  + 15, _transparentView.frame.size.width, 40);
    _searchBar.tintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9];
    _searchBar.placeholder = @"Search address";
    [_transparentView addSubview:self.searchBar];
    
   // self.convertCoordinateSegmentedControl.hidden = NO;
    
    [self.view setTintColor:[UIColor blueColor]];
    
   // CGFloat topOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height + 40;
    
    UIColor *floatingLabelColor = [UIColor whiteColor];
    
    _easting_x = [[JVFloatLabeledTextField alloc] initWithFrame:
                  CGRectMake(kJVFieldHMargin, self.convertCoordinateSegmentedControl.frame.size.height + self.convertCoordinateSegmentedControl.frame.origin.y  + 10, _transparentView.frame.size.width - 10 * kJVFieldHMargin, kJVFieldHeight)];
   
    _easting_x.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _easting_x.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _easting_x.floatingLabelTextColor = floatingLabelColor;
    _easting_x.textColor = [UIColor whiteColor];
    _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"x (easting)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _easting_x.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_easting_x setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_easting_x setDelegate:self];
 
    _div1 = [UIView new];
    _div1.frame = CGRectMake(kJVFieldHMargin, _easting_x.frame.origin.y + _easting_x.frame.size.height,
                            _transparentView.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    _div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];

    _northing_y = [[JVFloatLabeledTextField alloc] initWithFrame:
                   CGRectMake(kJVFieldHMargin,
                              _div1.frame.origin.y + _div1.frame.size.height,
                              _transparentView.frame.size.width - 3*kJVFieldHMargin - 80.0f - 1.0f,
                              kJVFieldHeight)];
    _northing_y.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _northing_y.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _northing_y.floatingLabelTextColor = floatingLabelColor;
    _northing_y.textColor = [UIColor whiteColor];
    _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _northing_y.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_northing_y setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_northing_y setDelegate:self];

    _gridZone = [[JVFloatLabeledTextField alloc] initWithFrame:
                 CGRectMake(kJVFieldHMargin + kJVFieldHMargin + _northing_y.frame.size.width + 1.0f, _div1.frame.origin.y + _div1.frame.size.height, 80.0f, kJVFieldHeight)];
    _gridZone.placeholder = NSLocalizedString(@"Zone", @"");
    _gridZone.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _gridZone.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _gridZone.floatingLabelTextColor = floatingLabelColor;
    _gridZone.textColor = [UIColor whiteColor];
    _gridZone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Zone", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _gridZone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_gridZone setKeyboardType:UIKeyboardTypeNumberPad];
    [_gridZone setDelegate:self];

    _div2 = [UIView new];
    _div2.frame = CGRectMake(kJVFieldHMargin + _northing_y.frame.size.width,
                            _easting_x.frame.origin.y + _easting_x.frame.size.height + 1.0f, 1.0f, kJVFieldHeight);
    _div2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    _div3 = [UIView new];
    _div3.frame = CGRectMake(kJVFieldHMargin, _gridZone.frame.origin.y + _gridZone.frame.size.height,
                            _transparentView.frame.size.width - 2*kJVFieldHMargin, 1.0f);
    _div3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    self.hemisphere.text = @"hemisphere :";
    self.hemisphere.textColor = [UIColor whiteColor];
    self.hemisphere.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.hemisphere.backgroundColor = [UIColor clearColor];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.hemisphere.frame = CGRectMake(kJVFieldHMargin,_gridZone.frame.origin.y + _gridZone.frame.size.height + 5, 70, 20);
        self.hemisphereSegmentedControl.frame = CGRectMake(kJVFieldHMargin + _hemisphere.frame.origin.x + 70,_gridZone.frame.origin.y + _gridZone.frame.size.height + 5, 50, 20);
    } else {
        self.hemisphere.frame = CGRectMake(kJVFieldHMargin,_gridZone.frame.origin.y + _gridZone.frame.size.height + 15, 70, 20);
        self.hemisphereSegmentedControl.frame = CGRectMake(kJVFieldHMargin + _hemisphere.frame.origin.x + 70,_gridZone.frame.origin.y + _gridZone.frame.size.height + 15, 50, 20);
    }
    [_transparentView addSubview:self.hemisphereSegmentedControl];
    
    _toLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        _toLocationButton.frame = CGRectMake(105,_hemisphereSegmentedControl.frame.origin.y + _hemisphereSegmentedControl.frame.size.height + 10, 110, 32);
    } else {
        _toLocationButton.frame = CGRectMake(105,_hemisphereSegmentedControl.frame.origin.y + _hemisphereSegmentedControl.frame.size.height + 20, 110, 32);
    }
    //[buttonBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_toLocationButton setTitle:@"Search" forState:UIControlStateNormal];
    [_toLocationButton setTitleColor:[UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    _toLocationButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
    _toLocationButton.layer.borderWidth = 1.0f;
    _toLocationButton.layer.cornerRadius = 15.0f;
    [_toLocationButton addTarget:self action:@selector(toLocation) forControlEvents:UIControlEventTouchUpInside];
    [_transparentView addSubview:_toLocationButton];
    
    [_transparentView addSubview:_easting_x];
    [_transparentView addSubview:_northing_y];
    [_transparentView addSubview:_gridZone];
    [_transparentView addSubview:_div1];
    [_transparentView addSubview:_div2];
    [_transparentView addSubview:_div3];
    [_transparentView addSubview:_hemisphere];
    
    if (_SearchChangedSegmentedControl.selectedSegmentIndex == 0) {
        
        self.searchText.textColor = [UIColor whiteColor];
        self.searchText.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        self.searchCoordinate.textColor = [UIColor lightGrayColor];
        self.searchCoordinate.font = [UIFont systemFontOfSize:14];
        _convertCoordinateSegmentedControl.hidden = YES;
        _easting_x.hidden = YES;
        _northing_y.hidden = YES;
        _gridZone.hidden = YES;
        _div1.hidden = YES;
        _div2.hidden = YES;
        _div3.hidden = YES;
        _hemisphereSegmentedControl.hidden = YES;
        _hemisphere.hidden = YES;
        _toLocationButton.hidden = YES;
        _searchBar.hidden = NO;
    } else if (_SearchChangedSegmentedControl.selectedSegmentIndex == 1) {
        self.searchCoordinate.textColor = [UIColor whiteColor];
        self.searchCoordinate.font = [UIFont systemFontOfSize:kJVFieldFontSize];
        self.searchText.textColor = [UIColor lightGrayColor];
        self.searchText.font = [UIFont systemFontOfSize:14];
        _convertCoordinateSegmentedControl.hidden = NO;
        _easting_x.hidden = NO;
        _northing_y.hidden = NO;
        _div1.hidden = NO;
        _div3.hidden = NO;
        _toLocationButton.hidden = NO;
        _searchBar.hidden = YES;
        
        if (_convertCoordinateSegmentedControl.selectedSegmentIndex == 0) {
            _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"x (easting)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _easting_x.placeholder = NSLocalizedString(@"x (easting)", @"");
            _northing_y.placeholder = NSLocalizedString(@"y (northing)", @"");
            _gridZone.hidden = NO;
            _div2.hidden = NO;
            _hemisphereSegmentedControl.hidden = NO;
            _hemisphere.hidden = NO;
        } else {
            _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Longitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Latitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _easting_x.placeholder = NSLocalizedString(@"Longitude", @"");
            _northing_y.placeholder = NSLocalizedString(@"Latitude", @"");
            _gridZone.hidden = YES;
            _div2.hidden = YES;
            _hemisphereSegmentedControl.hidden = YES;
            _hemisphere.hidden = YES;
        }

    }
    [_easting_x becomeFirstResponder];
}

-(void)searchValueChange {
    switch (self.SearchChangedSegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.searchText.textColor = [UIColor whiteColor];
            self.searchText.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.searchCoordinate.textColor = [UIColor lightGrayColor];
            self.searchCoordinate.font = [UIFont systemFontOfSize:14];
            _convertCoordinateSegmentedControl.hidden = YES;
            _easting_x.hidden = YES;
            _northing_y.hidden = YES;
            _gridZone.hidden = YES;
            _div1.hidden = YES;
            _div2.hidden = YES;
            _div3.hidden = YES;
            _hemisphereSegmentedControl.hidden = YES;
            _hemisphere.hidden = YES;
            _toLocationButton.hidden = YES;
            _searchBar.hidden = NO;
        }
            break;
        case 1:
        {
            self.searchCoordinate.textColor = [UIColor whiteColor];
            self.searchCoordinate.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.searchText.textColor = [UIColor lightGrayColor];
            self.searchText.font = [UIFont systemFontOfSize:14];
            self.searchCoordinate.textColor = [UIColor whiteColor];
            self.searchCoordinate.font = [UIFont systemFontOfSize:kJVFieldFontSize];
            self.searchText.textColor = [UIColor lightGrayColor];
            self.searchText.font = [UIFont systemFontOfSize:14];
            _convertCoordinateSegmentedControl.hidden = NO;
            _easting_x.hidden = NO;
            _northing_y.hidden = NO;
            _div1.hidden = NO;
            _div3.hidden = NO;
            _toLocationButton.hidden = NO;
            _searchBar.hidden = YES;
            
            if (_convertCoordinateSegmentedControl.selectedSegmentIndex == 0) {
                _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"x (easting)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _easting_x.placeholder = NSLocalizedString(@"x (easting)", @"");
                _northing_y.placeholder = NSLocalizedString(@"y (northing)", @"");
                _gridZone.hidden = NO;
                _div2.hidden = NO;
                _hemisphereSegmentedControl.hidden = NO;
                _hemisphere.hidden = NO;
            } else {
                _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Longitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Latitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
                _easting_x.placeholder = NSLocalizedString(@"Longitude", @"");
                _northing_y.placeholder = NSLocalizedString(@"Latitude", @"");
                _gridZone.hidden = YES;
                _div2.hidden = YES;
                _hemisphereSegmentedControl.hidden = YES;
                _hemisphere.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}

-(void)toLocation {
    
    [_transparentView close];
    
    if (self.notQTree == nil) {
        self.notQTree = [NotQTree new];
    } else {
        
    }

    if (_convertCoordinateSegmentedControl.selectedSegmentIndex == 0) {

        UTMCoordinates coordinates;
        coordinates.gridZone = [_gridZone.text intValue];
        coordinates.northing = [_northing_y.text doubleValue];
        coordinates.easting = [_easting_x.text doubleValue];
        
        if (_hemisphereSegmentedControl.selectedSegmentIndex == 0) {
            coordinates.hemisphere = kUTMHemisphereNorthern;
        } else {
            coordinates.hemisphere = kUTMHemisphereSouthern;
        }
        GeodeticUTMConverter *converter = [[GeodeticUTMConverter alloc] init];
        CLLocationCoordinate2D addCoordinate = [converter UTMCoordinatesToLatitudeAndLongitude:coordinates];

        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = addCoordinate;
        
        [_mapView setRegion:region animated:TRUE];
        [_mapView regionThatFits:region];
        
        
        AddAnnotation *pin = [[AddAnnotation alloc] init];
        pin.coordinate = addCoordinate;
        
        GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
        UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:addCoordinate];
        
        pin.subtitle = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];
        pin.title = [NSString stringWithFormat:@"Lat: %.4f , Lon: %.4f",pin.coordinate.latitude,pin.coordinate.longitude];
        pin.interModalTransfer = @"";
        
        [_mapView addAnnotation:pin];
        [__pins addObject:pin];
        [self.notQTree insertObject:pin];
        [self reloadAnnotations];
        self.elaserAreaButton.hidden = NO;

    } else {
        CLLocationCoordinate2D addCoordinate;
        addCoordinate.latitude = [_northing_y.text doubleValue];
        addCoordinate.longitude = [_easting_x.text doubleValue];

        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = addCoordinate;
 
        [_mapView setRegion:region animated:TRUE];
        [_mapView regionThatFits:region];
        
        AddAnnotation *pin = [[AddAnnotation alloc] init];
        pin.coordinate = addCoordinate;
       
        GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
        UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:addCoordinate];
        
        pin.subtitle = [NSString stringWithFormat:@"E: %.1f N: %.1f Zone: %u",utmCoordinates.easting,utmCoordinates.northing,utmCoordinates.gridZone];
        pin.title = [NSString stringWithFormat:@"Lat: %.4f , Lon: %.4f",pin.coordinate.latitude,pin.coordinate.longitude];
        pin.interModalTransfer = @"";
        
        [_mapView addAnnotation:pin];
        [__pins addObject:pin];
        [self.notQTree insertObject:pin];
        [self reloadAnnotations];
        self.elaserAreaButton.hidden = NO;
    }
}

-(void)coordinateValueChange {
    
    switch (self.convertCoordinateSegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"x (easting)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"y (northing)", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _easting_x.placeholder = NSLocalizedString(@"x (easting)", @"");
            _northing_y.placeholder = NSLocalizedString(@"y (northing)", @"");
            _gridZone.hidden = NO;
            _div2.hidden = NO;
            _hemisphereSegmentedControl.hidden = NO;
            _hemisphere.hidden = NO;
        }
            break;
        case 1:
        {
            _easting_x.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Longitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _northing_y.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Latitude", @"") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            _easting_x.placeholder = NSLocalizedString(@"Longitude", @"");
            _northing_y.placeholder = NSLocalizedString(@"Latitude", @"");
            _gridZone.hidden = YES;
            _div2.hidden = YES;
            _hemisphereSegmentedControl.hidden = YES;
            _hemisphere.hidden = YES;
        }
            break;
        default:
            break;
    }
}

-(void)performCurl{
    
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        CurlViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Curl"];
        controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
        CurlViewController *controller = [storyboard           instantiateViewControllerWithIdentifier:@"Curl"];
        controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }*/
    [self performSegueWithIdentifier:@"Configure" sender:self];
}

- (void)elaserArea {
 
    self.elaserAreaButton.hidden = YES;
    self.SwitchContainer.hidden = YES;
    self.stepRoute.hidden = YES;
    self.routeDistance.hidden = YES;
    self._radiusSlider.hidden = YES;
    self.elaserRoute.hidden = YES;
    self.elaserBufferZone.hidden = YES;

    NSArray *pole = [_mapView overlays];
    [_mapView removeOverlays:pole];
    
    NSArray *area = [_mapView annotations];
    [_mapView removeAnnotations:area];

    [__areas removeAllObjects];
   // [__pins removeAllObjects];
    
    self.qTree = [QTree new];
    self.notQTree = [NotQTree new];
    
    self.mapSource = WMMapSourceStandard;

    [self updateLocations];
}

- (IBAction)mapChage:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        _mapView.alpha = 1;
        _containerView.alpha = 0;
        self.elaserAreaButton.hidden = NO;
        self.mapChageButton.hidden = YES;
        self.listChageButton.hidden = NO;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.title = NSLocalizedString(@"Map", nil);
    }];
}

-(void)setSetRegion:(CLLocationCoordinate2D)setRegion
{
    _setRegion = setRegion;

     [self setMapRegionDelegate];
}

-(void)setMapRegionDelegate {
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = _setRegion.latitude;
    region.center.longitude = _setRegion.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        _mapView.alpha = 1;
        _containerView.alpha = 0;
        self.elaserAreaButton.hidden = NO;
        self.mapChageButton.hidden = YES;
        self.listChageButton.hidden = NO;
        self.navigationItem.title = NSLocalizedString(@"Map", nil);
    }];
}

- (IBAction)listChage:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _mapView.alpha = 0;
        _containerView.alpha = 1;
        self.elaserAreaButton.hidden = YES;
        self.mapChageButton.hidden = NO;
        self.listChageButton.hidden = YES;
        self.navigationItem.title = [NSString stringWithFormat:@"List of %lu",(unsigned long)[__areas count]];//NSLocalizedString(@"List", nil);
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [drawer hideAnimated:YES];
        
        [sideMenu hide];
    }];
}

- (void)curlViewControllerWillClusterPin:(CurlViewController *)controller didCluster:(BOOL)onOffClusterPin
{
    _useClustering = onOffClusterPin;

    [self reloadAnnotations];
}

-(void)reloadAnnotations
{
    if( !self.isViewLoaded ) {
        return;
    }
    
    const MKCoordinateRegion mapRegion = _mapView.region;
  //  BOOL useClustering = (self.onOffCluster.on);//--- onOffCuster
    
    const CLLocationDegrees minNonClusteredSpan = _useClustering ? MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5:0;
    /*const CLLocationDegrees minNonClusteredSpan = MIN(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta) / 5;*/
    
    NSArray* objects_notqtree = [self.notQTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
   
    NSArray* objects = [self.qTree getObjectsInRegion:mapRegion minNonClusteredSpan:minNonClusteredSpan];
    
    NSMutableArray* annotationsToRemove = [_mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:_mapView.userLocation];
    [annotationsToRemove removeObjectsInArray:objects];
    [annotationsToRemove removeObjectsInArray:objects_notqtree];
    [_mapView removeAnnotations:annotationsToRemove];
    
    NSMutableArray* annotationsToAdd = [objects mutableCopy];
    [annotationsToAdd removeObjectsInArray:_mapView.annotations];
    
    [_mapView addAnnotations:annotationsToAdd];
    
    NSMutableArray* annotationsToAdd_notQTree = [objects_notqtree mutableCopy];
    [annotationsToAdd_notQTree removeObjectsInArray:_mapView.annotations];
    
    [_mapView addAnnotations:annotationsToAdd_notQTree];
    
    [self updateLocations];
}

-(void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self reloadAnnotations];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
 
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    /*if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        NSString *toAddIdentifier = @"toAddIdentifier";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:toAddIdentifier];
    
        if( !annotationView ) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:toAddIdentifier];
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        return annotationView;
    }*/
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        NSString *DigitizePinIdentifier = @"DigitizePinIdentifier";
        DigitizePinView* annotationView = (DigitizePinView*)[mapView dequeueReusableAnnotationViewWithIdentifier:DigitizePinIdentifier];
        
        if( !annotationView ) {
            annotationView = [[DigitizePinView alloc] initWithAnnotation:annotation reuseIdentifier:DigitizePinIdentifier];
        }
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[PlacemarkAnnotation class]]) {
        NSString *placemark = @"placemark";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:placemark];
        
        if( !annotationView ) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemark];
            annotationView.pinColor = MKPinAnnotationColorPurple;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        return annotationView;
    }


    if( [annotation isKindOfClass:[QCluster class]]){
        ClusterAnnotationView* annotationView = (ClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:[ClusterAnnotationView reuseId]];
        if( !annotationView ) {
            annotationView = [[ClusterAnnotationView alloc] initWithCluster:(QCluster*)annotation];
        }
        annotationView.cluster = (QCluster*)annotation;
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[AddAnnotation class]]) {
        NSString *addPinIdentifier = @"AddPinIdentifier";
        MKPinAnnotationView* annotationView = [[MKPinAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:addPinIdentifier];
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:addPinIdentifier];
        
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.animatesDrop = NO;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
        
        if( !annotationView ) {
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[RecordTables class]]) {
        NSString *recordIdentifier = @"RecordIdentifier";
        MKPinAnnotationView* annotationView = [[MKPinAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:recordIdentifier];
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:recordIdentifier];
        
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.animatesDrop = NO;
        annotationView.canShowCallout = YES;
      //  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = btn;
      //  [btn setImage:[UIImage imageNamed:@"routing.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectAnnotationButton) forControlEvents:UIControlEventTouchUpInside];
        
     //  UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:]];
      //  annotationView.leftCalloutAccessoryView = iconView;
        
        if( !annotationView ) {
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MKAnnotationView class]])
        return nil;
  
    MKAnnotationView *annotationView;
    
    static NSString *anotherIdentifier = @"anotherIdentifier";
    NSString *NRFIdentifier = @"NRFIdentifier";
    NSString *indexIdentifier = @"IndexIdentifier";
    NSString *NPIdentifier = @"NPIdentifier";
    NSString *WLSIdentifier = @"WLSIdentifier";
    NSString *NHAIdentifier = @"NHAIdentifier";
    NSString *FPIdentifier = @"FPIdentifier";
    NSString *CommunityForestIdentifier = @"CommunityForestIdentifier";
    NSString *MFIdentifier = @"MFIdentifier";
    NSString *ProvinceIdentifier = @"ProvinceIdentifier";
    NSString *AmphoeIdentifier = @"AmphoeIdentifier";
    NSString *TambonIdentifier = @"TambonIdentifier";

 //   NSString *addPinIdentifier = @"AddPinIdentifier";

    NSString *addPinIdentifier = @"OtherLayerPinIdentifier";
    
    if ([((Annotation *)annotation).type isEqualToString:@""]) {
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:NRFIdentifier];
    } else if ([((Annotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:indexIdentifier];
    }/* else if ([((AddAnnotation *)annotation).title isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:addPinIdentifier];
    }*/
    else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:addPinIdentifier];
    }
    
    else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:NPIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:WLSIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:NHAIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:FPIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:CommunityForestIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:MFIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ProvinceIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AmphoeIdentifier];
    } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:TambonIdentifier];
    }
    
    
    if (!annotationView) {
        if ([((Annotation *)annotation).type isEqualToString:@"ป่าสงวนแห่งชาติ"]) {
            annotationView = [[PinViewNRF alloc] initWithAnnotation:annotation reuseIdentifier:NRFIdentifier];
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
            /* else if ([((AddAnnotation *)annotation).title isEqualToString:@"Drop"]){
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:addPinIdentifier];
            if([annotation class] == [AddAnnotation class]) {
                
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorRed;
            ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
            } else {
                
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorGreen;
            }
          }*/
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"อุทยานแห่งชาติ"]){
            annotationView = [[PinViewNP alloc] initWithAnnotation:annotation reuseIdentifier:NPIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"เขตรักษาพันธุ์สัตว์ป่า"]){
            annotationView = [[PinViewWLS alloc] initWithAnnotation:annotation reuseIdentifier:WLSIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"เขตห้ามล่าสัตว์ป่า"]){
            annotationView = [[PinViewNHA alloc] initWithAnnotation:annotation reuseIdentifier:NHAIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"วนอุทยาน"]){
            annotationView = [[PinViewFP alloc] initWithAnnotation:annotation reuseIdentifier:FPIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"ป่าชุมชน"]){
            annotationView = [[PinViewCommunityForest alloc] initWithAnnotation:annotation reuseIdentifier:CommunityForestIdentifier];
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"ป่าชายเลน"]){
            annotationView = [[PinViewMF alloc] initWithAnnotation:annotation reuseIdentifier:MFIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"ขอบเขตจังหวัด"]){
            annotationView = [[PinViewProvince alloc] initWithAnnotation:annotation reuseIdentifier:ProvinceIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"ขอบเขตอำเภอ"]){
            annotationView = [[PinViewAmphoe alloc] initWithAnnotation:annotation reuseIdentifier:AmphoeIdentifier];
            
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"ขอบเขตตำบล"]){
            annotationView = [[PinViewTambon alloc] initWithAnnotation:annotation reuseIdentifier:TambonIdentifier];
        } else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@"ระวาง 1:50000"]){
            annotationView = [[PinViewIndex alloc] initWithAnnotation:annotation reuseIdentifier:indexIdentifier];
        }
        
        
        else if ([((OtherLayerAnnotation *)annotation).type isEqualToString:@""]){
              annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:addPinIdentifier];
              if([annotation class] == [OtherLayerAnnotation class]) {
                  
                  ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorRed;
                  ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
              } else {
                  
                  ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorGreen;
              }
          } else {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anotherIdentifier];
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorGreen;
            ((MKPinAnnotationView *)annotationView).animatesDrop = NO;
        }
        annotationView.canShowCallout = YES;
        
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            Annotation *selectedAnnotation = [_mapView selectedAnnotations][0];
            
            ((DetailViewController *)segue.destinationViewController).area = selectedAnnotation;
        } else {
            WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
            
            detailPopoverController = [popoverSegue popoverControllerWithSender:sender
                                                             permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                             animated:YES
                                                                              options:WYPopoverAnimationOptionFadeWithScale];
            detailPopoverController.delegate = self;
        }
    }
    else if ([segue.destinationViewController isKindOfClass:[AddPinDetailViewController class]]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            AddAnnotation *selectedAnnotation = [_mapView selectedAnnotations][0];
            
            ((AddPinDetailViewController *)segue.destinationViewController).pin = selectedAnnotation;
        } else {
            WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
            
            addPinDetailPopoverController = [popoverSegue popoverControllerWithSender:sender
                                                               permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                               animated:YES
                                                                                options:WYPopoverAnimationOptionFadeWithScale];
            addPinDetailPopoverController.delegate = self;
        }
    }
/*    else if ([segue.destinationViewController isKindOfClass:[DetailDatabaseViewController class]]) {
        RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
        
        ((DetailDatabaseViewController *)segue.destinationViewController).record = selectedAnnotation;
    }*/
    else if ([segue.destinationViewController isKindOfClass:[ListViewController class]]){
        __listViewController = (ListViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"Configure"]){
        CurlViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.mapType = _mapType;
        controller.mapSource = _mapSource;
        controller.useClustering = _useClustering;
    }
    else if ([segue.identifier isEqualToString:@"ListAndSearch"]){
       // GuideViewController *controller = segue.destinationViewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
        } else {
            WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
            
            listAndSearchPopoverController = [popoverSegue popoverControllerWithSender:sender
                                                             permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                             animated:YES
                                                                              options:WYPopoverAnimationOptionFadeWithScale];
            listAndSearchPopoverController.delegate = self;
        }
    }
    else if ([segue.identifier isEqualToString:@"toAbout"]){
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
        } else {
            WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
            
            aboutPopoverController = [popoverSegue popoverControllerWithSender:sender
                                                              permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                              animated:YES
                                                                               options:WYPopoverAnimationOptionFadeWithScale];
            aboutPopoverController.delegate = self;
        }
    }
    else if ([segue.identifier isEqualToString:@"TableToDetails"])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            DetailDatabaseViewController *controller = [segue destinationViewController];
            controller.record = selectedRecord;
            
            ////   RecordTables *selectedAnnotation = [_mapView selectedAnnotations][0];
            //   ((DetailDatabaseViewController *)segue.destinationViewController).record = selectedAnnotation;
        } else {
            WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
            
            detailDatabasePopoverController = [popoverSegue popoverControllerWithSender:sender
                                                        permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                        animated:YES
                                                                         options:WYPopoverAnimationOptionFadeWithScale];
            detailDatabasePopoverController.delegate = self;
        }
    }
    else if ([segue.destinationViewController isKindOfClass:[StepRouteViewController class]]) //([segue.identifier isEqualToString:@"Route"])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            StepRouteViewController *controller = [segue destinationViewController];
            controller.route = _currentRoute;
            
            [drawer hideAnimated:YES];
        } else {
        /*    WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
            
            stepRoutePopoverController = [popoverSegue popoverControllerWithSender:sender
                                                               permittedArrowDirections:WYPopoverArrowDirectionDown
                                                                               animated:YES
                                                                                options:WYPopoverAnimationOptionFadeWithScale];
            stepRoutePopoverController.delegate = self;*/
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[Annotation class]]) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
           [self performSegueWithIdentifier:@"mapToDetails" sender:self];
        } else {
            
            UIView *btn = [UIView new];
            btn.frame = CGRectMake(0, 0, _mapView.frame.size.width*2 - 80 , 80);
            
            DetailViewController *DetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            DetailViewController.preferredContentSize = CGSizeMake(320, 522);
            
            Annotation *selectedAnnotation = [_mapView selectedAnnotations][0];
            
            DetailViewController.area = selectedAnnotation;
            DetailViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:DetailViewController];
            
            detailPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            detailPopoverController.delegate = self;
            detailPopoverController.passthroughViews = @[btn];
            detailPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            detailPopoverController.wantsDefaultContentAppearance = NO;
            
            [detailPopoverController presentPopoverFromRect:btn.bounds
                                                           inView:self.view
                                         permittedArrowDirections:WYPopoverArrowDirectionAny
                                                         animated:YES
                                                          options:WYPopoverAnimationOptionFadeWithScale];
        }
    }
    else if ([view.annotation isKindOfClass:[AddAnnotation class]] || [view.annotation isKindOfClass:[PlacemarkAnnotation class]]) {
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [self performSegueWithIdentifier:@"PinToDetails" sender:self];
        } else {

            UIView *btn = [UIView new];
            btn.frame = CGRectMake(0, 0, _mapView.frame.size.width*2 - 80 , 80);
            
            AddPinDetailViewController *addPinDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPinDetailViewController"];
            addPinDetailViewController.preferredContentSize = CGSizeMake(320, 480);
            
            AddAnnotation *selectedAnnotation = [_mapView selectedAnnotations][0];
            
            addPinDetailViewController.pin = selectedAnnotation;
            addPinDetailViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:addPinDetailViewController];
            
            addPinDetailPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            addPinDetailPopoverController.delegate = self;
            addPinDetailPopoverController.passthroughViews = @[btn];
            addPinDetailPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            addPinDetailPopoverController.wantsDefaultContentAppearance = NO;
            
            [addPinDetailPopoverController presentPopoverFromRect:btn.bounds
                                                           inView:self.view
                                         permittedArrowDirections:WYPopoverArrowDirectionAny
                                                         animated:YES
                                                          options:WYPopoverAnimationOptionFadeWithScale];
        }
    }
    else if ([view.annotation isKindOfClass:[RecordTables class]]) {
        //[self performSegueWithIdentifier:@"TableToDetails" sender:self];
      //  [self menuISVertical];
        //  UIButton *btn;
        //  [btn addTarget:self action:@selector(menuISVertical:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([view.annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dropped Pin"message:[NSString stringWithFormat:@"Latitude: %.4f , Longitude: %.4f",toAdd.coordinate.latitude,toAdd.coordinate.longitude] delegate:self cancelButtonTitle:@"cancel"otherButtonTitles: nil];
        [alertView show];
        self.elaserAreaButton.hidden = NO;
    }
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view
{
    id<MKAnnotation> annotation = view.annotation;
    if( [annotation isKindOfClass:[QCluster class]] ) {
        QCluster* cluster = (QCluster*)annotation;
        [mapView setRegion:MKCoordinateRegionMake(cluster.coordinate, MKCoordinateSpanMake(2.5 * cluster.radius, 2.5 * cluster.radius))
                  animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayRenderer *overlayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"polylineDigitize"]) {
            MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
            polylineRenderer.strokeColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
            polylineRenderer.lineJoin = kCGLineJoinRound;
            polylineRenderer.lineCap = kCGLineCapRound;
            polylineRenderer.lineWidth = 2.5f;
            overlayRenderer = polylineRenderer;
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"polylineDigitize_border"]) {
            MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
            polylineRenderer.strokeColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
            polylineRenderer.lineJoin = kCGLineJoinRound;
            polylineRenderer.lineCap = kCGLineCapRound;
            polylineRenderer.lineWidth = 0.5f;
            overlayRenderer = polylineRenderer;
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"polylineRoute"]) {
            MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
            polylineRenderer.strokeColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:0.7];//[[UIColor redColor]colorWithAlphaComponent:0.7];
            polylineRenderer.lineJoin = kCGLineJoinRound;
            polylineRenderer.lineCap = kCGLineCapRound;
            polylineRenderer.lineWidth = 5.0f;
            overlayRenderer = polylineRenderer;
        } else {
            MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
            polylineRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
            polylineRenderer.lineJoin = kCGLineJoinRound;
            polylineRenderer.lineCap = kCGLineCapRound;
            polylineRenderer.lineWidth = 0.5f;
            overlayRenderer = polylineRenderer;
        }
        
    } else if ([overlay isKindOfClass:[MKPolygon class]]) {
        if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"polygonDigitize"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"polygonDigitize_create"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7/2];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2/2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ป่าสงวนแห่งชาติ"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];//[[UIColor alloc] initWithRed:0.0 green:250.0 blue:250.0 alpha:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"อุทยานแห่งชาติ"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.3];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"เขตรักษาพันธุ์สัตว์ป่า"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor brownColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor brownColor] colorWithAlphaComponent:0.3];//
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"เขตห้ามล่าสัตว์ป่า"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"วนอุทยาน"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor alloc] initWithRed:200.0 green:0.0 blue:50.0 alpha:0.8];//[[UIColor orangeColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor alloc] initWithRed:200.0 green:0.0 blue:50.0 alpha:0.2];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ป่าชายเลน"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ป่าชุมชน"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ขอบเขตจังหวัด"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.9f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ขอบเขตอำเภอ"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor darkGrayColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ขอบเขตตำบล"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"พื้นที่คงสภาพป่า 2555-2556"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];//[UIColor blackColor];
            polygonRenderer.fillColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:0.7];//[[UIColor greenColor] colorWithAlphaComponent:0.3];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ชั้นคุณภาพลุ่มนํ้า 1 2"]) {
            
        } else if ([[[overlay.title componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"ระวาง 1:50000"]) {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:1.0];//[UIColor blackColor];
            polygonRenderer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
            
        } else {
            MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:(MKPolygon *)overlay];
            polygonRenderer.strokeColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:0.7];//[[UIColor greenColor] colorWithAlphaComponent:0.5];//[UIColor blackColor];
            polygonRenderer.fillColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:0.7];//[[UIColor greenColor] colorWithAlphaComponent:0.3];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
            polygonRenderer.lineWidth = 0.5f;
            overlayRenderer = polygonRenderer;
        }
        
    }
    else if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1.0];        circleRenderer.fillColor = [[UIColor alloc] initWithRed:255/255 green:20/255 blue:147/255 alpha:0.2];
        //[[UIColor alloc] initWithRed:56/255 green:142/255 blue:142/155 alpha:0.2];
        circleRenderer.lineWidth = 0.5f;
        overlayRenderer = circleRenderer;
    }
    else if ([overlay isKindOfClass:[WMOverlay class]]) {
        WMOverlayView *overlayView = [[WMOverlayView alloc] initWithOverlay:overlay];
        
        
        overlayRenderer = overlayView;
        
        
    }
    return overlayRenderer;
}

#pragma mark - WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller {
    return YES;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController {
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value {
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 0; // set value to 0 if you want to avoid the popover to be moved
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)aPopoverController {
    if (aPopoverController == detailDatabasePopoverController) {
        detailDatabasePopoverController.delegate = nil;
        detailDatabasePopoverController = nil;
    } else if (aPopoverController == stepRoutePopoverController) {
        stepRoutePopoverController.delegate = nil;
        stepRoutePopoverController = nil;
    }
}

-(void)menuButtons {
    [self closeTransparentView];
    [drawer hideAnimated:YES];

    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"Other Layer", nil)];
   
    /*[actionSheet addButtonWithTitle:NSLocalizedString(@"+  หน่วยป้องกันรักษาป่า", nil)
     image:[UIImage imageNamed:nil]
     type:AHKActionSheetButtonTypeDefault
     handler:^(AHKActionSheet *as) {
     _urlConnect = @"http://pirun.ku.ac.th/~b521030091/forestProtectCenter.geojson";
     [self layer];
     }];*/
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"อุทยานแห่งชาติ", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/NP.geojson",kOtherLayerURL];
                                 [self otherLayer];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"เขตรักษาพันธุ์สัตว์ป่า", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/WLS.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"เขตห้ามล่าสัตว์ป่า", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/NHA.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"วนอุทยาน", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/FP.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"ป่าชายเลน", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/MF.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"พื้นที่คงสภาพป่า ปี 2555 - 2556", nil)
                              image:[UIImage imageNamed:@"MLayerOverlayNoPin"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self ForestSelectProvinceMenu];
                            }];
    
    /*[actionSheet addButtonWithTitle:NSLocalizedString(@"+  ชั้นคุณภาพลุ่มนํ้าชั้นที่ 1 และ 2", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self WatershadSelectProvinceMenu];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"+  ป่าชุมชน", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/CommunityForest.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];*/
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"ขอบเขตจังหวัด", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/PROVINCE.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"ขอบเขตอำเภอ ", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self AmphoeSelectProvinceMenu];
                            }];
    
    /*[actionSheet addButtonWithTitle:NSLocalizedString(@"+  ขอบเขตตำบล", nil)
                              image:[UIImage imageNamed:nil]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/CommunityForest.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];*/
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"สารบัญระวาง 1 : 50,000", nil)
                              image:[UIImage imageNamed:@"MLayerOverlay"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                _urlConnect = [NSString stringWithFormat:@"%@/INDEX50000.geojson",kOtherLayerURL];
                                [self otherLayer];
                            }];
    [actionSheet show];
}

-(void)otherLayer {
    
    [_progressView startAnimating];//---[self showLoadingMode];
    [_mapView addSubview:blurView];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _mapChageButton.enabled = NO;
    _listChageButton.enabled = NO;
    [self setTitle:@"Please Wait..."];
    
    if (self.qTree == nil) {
        self.qTree = [QTree new];
    } else {
        
    }

    NSURL *url = [NSURL URLWithString:_urlConnect];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",url);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if ([data length] >0 && error == nil)
                               {
                                   NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   
                                   NSArray *shapes = [OtherLayerGeoJSONSerialization shapesFromGeoJSONFeatureCollection:geoJSON error:nil];
                                   
                                   NSLog(@"%@",shapes);
                                   for (MKShape *shape in shapes) {
                                       
                                       if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
                                           
                                           [_mapView addOverlay:(id <MKOverlay>)shape];
                                           
                                           OtherLayerAnnotation *annotation = [[OtherLayerAnnotation alloc] init];
                                           
                                           annotation.title = [[shape.title componentsSeparatedByString:@","] objectAtIndex:1];
                                           annotation.subtitle = [NSString stringWithFormat:@"%@ / %@ / จ.%@", [[shape.title componentsSeparatedByString:@","] objectAtIndex:5],[[shape.title componentsSeparatedByString:@","] objectAtIndex:0], [[shape.title componentsSeparatedByString:@","] objectAtIndex:2]];
                                           
                                           annotation.nameThai = [[shape.title componentsSeparatedByString:@","] objectAtIndex:1];
                                           annotation.province = [[shape.title componentsSeparatedByString:@","] objectAtIndex:2];
                                           annotation.code = [[shape.title componentsSeparatedByString:@","] objectAtIndex:5];
                                           annotation.type = [[shape.title componentsSeparatedByString:@","] objectAtIndex:0];
                                           
                                           annotation.polygon = shape.subtitle;
                                           
                                           annotation.coordinate = CLLocationCoordinate2DMake([[[shape.title componentsSeparatedByString:@","] objectAtIndex:3] doubleValue], [[[shape.title componentsSeparatedByString:@","] objectAtIndex:4] doubleValue]);
                                           
                                           [self.qTree insertObject:annotation];
                                           [self reloadAnnotations];
                                       }
                                   }
                                   
                                   for (OtherLayerAnnotation *shape in shapes) {
                                       
                                       if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
                                           
                                       } else {
                                           
                                           [_mapView addAnnotation:shape];
                                           
                                           [self.qTree insertObject:shape];
                                           [self reloadAnnotations];
                                           
                                           NSArray *array = shape.multiPolygon;
                                           
                                           if ([array conformsToProtocol:@protocol(MKOverlay)]) {
                                               
                                           } else {
                                               NSString *jsonString = [array componentsJoinedByString:@","];
                                               
                                               for (jsonString in array) {
                                                   
                                                   NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                                   NSDictionary *geometry = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                   
                                                   NSDictionary *subFeature = [NSDictionary dictionaryWithDictionary:geometry[@"geometry"]];
                                                   
                                                   NSArray *coordinateSets = subFeature[@"coordinates"];
                                                   
                                                   NSMutableArray *mutablePolygons = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
                                                   for (NSArray *coordinatePairs in coordinateSets) {
                                                       CLLocationCoordinate2D *polygonCoordinates = CLLocationCoordinatesFromCoordinatePairs(coordinatePairs);
                                                       MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:[coordinatePairs count]];
                                                       [mutablePolygons addObject:polygon];
                                                   }
                                                   
                                                   MKPolygon *polygon = nil;
                                                   switch ([mutablePolygons count]) {
                                                       case 0:
                                                           
                                                       case 1:
                                                           polygon = [mutablePolygons firstObject];
                                                           break;
                                                       default: {
                                                           MKPolygon *exteriorPolygon = [mutablePolygons firstObject];
                                                           NSArray *interiorPolygons = [mutablePolygons subarrayWithRange:NSMakeRange(1, [mutablePolygons count] - 1)];
                                                           polygon = [MKPolygon polygonWithPoints:exteriorPolygon.points count:exteriorPolygon.pointCount interiorPolygons:interiorPolygons];
                                                       }
                                                           break;
                                                   }
                                                   polygon.title = shape.type;
                                                   
                                                   [_mapView addOverlay:polygon];
                                               }
                                           }
                                       }
                                   }
                                   
                                   [self setMapRegion];
                                   
                                   [_progressView stopAnimating];
                                   [self setTitle:@"Map"];//---[self hideLoadingMode];
                                   
                                   [blurView removeFromSuperview];
                                   
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   _mapChageButton.enabled = YES;
                                   _listChageButton.enabled = YES;
                                   self.elaserAreaButton.hidden = NO;
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleSuccess
                                                                    message:@"Overlay Complete"];
                                   
                               } else if ([data length] == 0 && error == nil) {
                                   NSLog(@"Nothing was downloaded.");
                                   
                                   [_progressView stopAnimating];
                                   [self setTitle:@"Map"];//---[self hideLoadingMode];
                                   
                                   [blurView removeFromSuperview];
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   _mapChageButton.enabled = YES;
                                   _listChageButton.enabled = YES;
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleError
                                                                    message:@"Overlay Error!"];
                               } else if (error != nil) {
                                   NSLog(@"Error = %@", error);
                                   
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnected", nil) message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                                   [alertView show];
                                   
                                   [_progressView stopAnimating];
                                   [self setTitle:@"Map"];//---[self hideLoadingMode];
                                   
                                   [blurView removeFromSuperview];
                                   self.navigationItem.leftBarButtonItem.enabled = YES;
                                   _mapChageButton.enabled = YES;
                                   _listChageButton.enabled = YES;
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleError
                                                                    message:@"Overlay Error!"];
                               }
                           }];
}

- (void)NRFselectProvinceMenu {
    
    _options = [NSArray arrayWithObjects:
                
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.กระบี่",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.กาญจนบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.กาฬสินธุ์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.กำแพงเพชร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ขอนแก่น",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.จันทบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ฉะเชิงเทรา",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ชลบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ชัยนาท",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ชัยภูมิ",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+   ป่าสงวนแห่งชาติ  จ.ชุมพร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ตรัง",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ตราด",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ตาก",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.นครพนม",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.นครราชสีมา",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.นครศรีธรรมราช",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.นครสวรรค์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.นราธิวาส",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.น่าน",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.บุรีรัมย์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ประจวบคีรีขันธ์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ปราจีนบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ปัตตานี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.พะเยา",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.พังงา",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.พัทลุง",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.พิจิตร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.พิษณุโลก",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ภูเก็ต",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.มหาสารคาม",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.มุกดาหาร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ยะลา",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ยโสธร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ระนอง",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ระยอง",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ราชบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ร้อยเอ็ด",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ลพบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ลำปาง",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ลำพูน",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.ศรีสะเกษ",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สกลนคร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สงขลา",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สตูล",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สมุทรสาคร",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สระบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สระแก้ว",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สุพรรณบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สุราษฎร์ธานี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สุรินทร์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.สุโขทัย",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.หนองคาย",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.หนองบัวลำภู",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.อำนาจเจริญ",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.อุดรธานี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.อุตรดิตถ์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.อุทัยธานี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.อุบลราชธานี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.เชียงราย",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.เชียงใหม่",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.เพชรบุรี",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.เพชรบูรณ์",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.เลย",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.แพร่",@"text", nil],
                [NSDictionary
                 dictionaryWithObjectsAndKeys:@"+  ป่าสงวนแห่งชาติ  จ.แม่ฮ่องสอน",@"text", nil],
                nil];
    
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"ป่าสงวนแห่งชาติ" options:_options];
    lplv.delegate = self;
    //    lplv.isModal = NO;
    [lplv showInView:self.view animated:YES];
    
    (layer = LAYER_OPTIONS);
}

- (void)ForestSelectProvinceMenu {
    
    _optionsForest = [NSArray arrayWithObjects:
                      
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.กระบี่",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  กรุงเทพมหานคร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.กาญจนบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.กาฬสินธุ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.กำแพงเพชร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ขอนแก่น",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.จันทบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ฉะเชิงเทรา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ชลบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ชัยนาท",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ชัยภูมิ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ชุมพร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.เชียงราย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.เชียงใหม่",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ตรัง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ตราด",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ตาก",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.นครนายก",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.นครพนม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.นครราชสีมา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.นครศรีธรรมราช",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.นครสวรรค์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.นราธิวาส",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.น่าน",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.บึงกาฬ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.บุรีรัมย์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ประจวบคีรีขันธ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ปราจีนบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ปัตตานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.พะเยา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.พังงา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.พัทลุง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.พิจิตร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.พิษณุโลก",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.เพชรบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.เพชรบูรณ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.แพร่",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ภูเก็ต",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.มหาสารคาม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.มุกดาหาร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.แม่ฮ่องสอน",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ยโสธร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ยะลา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ร้อยเอ็ด",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ระนอง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ระยอง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ราชบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ลพบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ลำปาง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ลำพูน",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.เลย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.ศรีสะเกษ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สกลนคร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สงขลา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สตูล",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สมุทรปราการ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สมุทรสงคราม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สมุทรสาคร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สระแก้ว",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สระบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สุโขทัย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สุพรรณบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สุราษฎร์ธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.สุรินทร์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.หนองคาย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.หนองบัวลำภู",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.อำนาจเจริญ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.อุดรธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.อุตรดิตถ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.อุทัยธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  พื้นที่คงสภาพป่า  จ.อุบลราชธานี",@"text", nil],
                nil];
    
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"พื้นที่คงสภาพป่า ปี 2555 - 2556" options:_optionsForest];
    lplv.delegate = self;
    //    lplv.isModal = NO;
    [lplv showInView:self.view animated:YES];
    
    (layer = LAYER_OPTIONS_FOREST);
}

- (void)WatershadSelectProvinceMenu {
    
    _optionsWatershad = [NSArray arrayWithObjects:
                      
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.กระบี่",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.กาญจนบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.กาฬสินธุ์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.กำแพงเพชร",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ขอนแก่น",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.จันทบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ฉะเชิงเทรา",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชลบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชัยนาท",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชัยภูมิ",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชุมพร",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.เชียงราย",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.เชียงใหม่",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ตรัง",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ตราด",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ตาก",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครนายก",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครพนม",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครราชสีมา",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครศรีธรรมราช",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครสวรรค์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.นราธิวาส",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.น่าน",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.บึงกาฬ",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.บุรีรัมย์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ประจวบคีรีขันธ์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ปราจีนบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ปัตตานี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.พะเยา",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.พังงา",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.พัทลุง",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.พิจิตร",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.พิษณุโลก",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.เพชรบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.เพชรบูรณ์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.แพร่",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ภูเก็ต",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.มุกดาหาร",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.แม่ฮ่องสอน",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ยโสธร",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ยะลา",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ร้อยเอ็ด",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ระนอง",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ระยอง",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ราชบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ลพบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ลำปาง",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ลำพูน",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.เลย",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.ศรีสะเกษ",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สกลนคร",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สงขลา",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สตูล",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สระแก้ว",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สระบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุโขทัย",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุพรรณบุรี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุราษฎร์ธานี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุรินทร์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.หนองคาย",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.หนองบัวลำภู",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.อำนาจเจริญ",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุดรธานี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุตรดิตถ์",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุทัยธานี",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุบลราชธานี",@"text", nil],
                      nil];
    
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"ชั้นคุณภาพลุ่มนํ้าชั้นที่ 1 และ 2" options:_optionsWatershad];
    lplv.delegate = self;
    //    lplv.isModal = NO;
    [lplv showInView:self.view animated:YES];
    
    (layer = LAYER_OPTIONS_WATERSHAD);
}

- (void)AmphoeSelectProvinceMenu {
    _optionsAmphoe = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.กระบี่",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.กรุงเทพมหานคร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.กาญจนบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.กาฬสินธุ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.กำแพงเพชร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ขอนแก่น",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.จันทบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ฉะเชิงเทรา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ชลบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ชัยนาท",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ชัยภูมิ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ชุมพร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.เชียงราย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.เชียงใหม่",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ตรัง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ตราด",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ตาก",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นครนายก",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นครปฐม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นครพนม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นครราชสีมา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นครศรีธรรมราช",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นครสวรรค์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นนทบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.นราธิวาส",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.น่าน",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.บึงกาฬ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.บุรีรัมย์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ปทุมธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ประจวบคีรีขันธ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ปราจีนบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ปัตตานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.พระนครศรีอยุธยา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.พะเยา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.พังงา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.พัทลุง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.พิจิตร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.พิษณุโลก",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.เพชรบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.เพชรบูรณ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.แพร่",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ภูเก็ต",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.มหาสารคาม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.มุกดาหาร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.แม่ฮ่องสอน",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ยโสธร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ยะลา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ร้อยเอ็ด",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ระนอง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ระยอง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ราชบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ลพบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ลำปาง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ลำพูน",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.เลย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.ศรีสะเกษ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สกลนคร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สงขลา",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สตูล",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สมุทรปราการ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สมุทรสงคราม",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สมุทรสาคร",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สระแก้ว",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สระบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สิงห์บุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สุโขทัย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สุพรรณบุรี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สุราษฎร์ธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.สุรินทร์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.หนองคาย",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.หนองบัวลำภู",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.อ่างทอง",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.อำนาจเจริญ",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.อุดรธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.อุตรดิตถ์",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.อุทัยธานี",@"text", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"+  ขอบเขตอำเภอ  จ.อุบลราชธานี",@"text", nil],
                      nil];
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"ขอบเขตอำเภอ" options:_optionsAmphoe];
    lplv.delegate = self;
    //    lplv.isModal = NO;
    [lplv showInView:self.view animated:YES];
    
    (layer = LAYER_OPTIONS_AMPHOE);
}

#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if (self.qTree == nil) {
        self.qTree = [QTree new];
    } else {
        
    }
    
    if (layer == LAYER_OPTIONS) {
        if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.กระบี่"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_KrabiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.กาญจนบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_KanchanaburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.กาฬสินธุ์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_KalasinProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.กำแพงเพชร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_KamphaengPhetProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ขอนแก่น"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_KhonKaenProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.จันทบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChanthaburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ฉะเชิงเทรา"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChachoengsaoProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ชลบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChonburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ชัยนาท"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChainatProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ชัยภูมิ"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChaiyaphumProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+   ป่าสงวนแห่งชาติ  จ.ชุมพร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChumphonProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ตรัง"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_TrangProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ตราด"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_TratProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ตาก"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_TakProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.นครพนม"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NakhonPhanomProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.นครราชสีมา"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NakhonRatchasimaProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.นครศรีธรรมราช"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NakhonSiThammaratProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.นครสวรรค์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NakhonSawanProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.นราธิวาส"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NarathiwatProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.น่าน"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NanProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.บุรีรัมย์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_BuriramProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ประจวบคีรีขันธ์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PrachuapKhiriKhanProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ปราจีนบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PrachinburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ปัตตานี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PattaniProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.พะเยา"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhayaoProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.พังงา"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhangNgaProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.พัทลุง"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhatthalungProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.พิจิตร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhichitProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.พิษณุโลก"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhitsanulokProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ภูเก็ต"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhuketProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.มหาสารคาม"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_MahaSarakhamProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.มุกดาหาร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_MukdahanProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ยะลา"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_YalaProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ยโสธร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_YasothonProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ระนอง"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_RanongProvince.geojson";
            [self layer];
        }
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ระยอง"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_RayongProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ราชบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_RatchaburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ร้อยเอ็ด"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_RoiEtProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ลพบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_LopburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ลำปาง"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_LampangProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ลำพูน"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_LamphunProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.ศรีสะเกษ"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SisaketProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สกลนคร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SakonNakhonProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สงขลา"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SongkhlaProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สตูล"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SatunProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สมุทรสาคร"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SamutSakhonProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สระบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SaraburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สระแก้ว"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SaKaeoProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สุพรรณบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SuphanBuriProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สุราษฎร์ธานี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SuratThaniProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สุรินทร์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SurinProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.สุโขทัย"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_SukhothaiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.หนองคาย"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NongKhaiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.หนองบัวลำภู"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_NongBuaLamphuProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.อำนาจเจริญ"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_AmnatCharoenProvince.geojson";
            [self layer];
        }
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.อุดรธานี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_UdonThaniProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.อุตรดิตถ์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_UttaraditProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.อุทัยธานี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_UthaiThaniProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.อุบลราชธานี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_UbonRatchathaniProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.เชียงราย"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChiangRaiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.เชียงใหม่"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_ChiangMaiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.เพชรบุรี"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhetchaburiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.เพชรบูรณ์"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhetchabunProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.เลย"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_LoeiProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.แพร่"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_PhraeProvince.geojson";
            [self layer];
        }
        
        else if ([[[_options objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ป่าสงวนแห่งชาติ  จ.แม่ฮ่องสอน"])
        {
            _urlConnect = @"http://pirun.ku.ac.th/~b521030091/GeoJSON/NRF_MaeHongSonProvince.geojson";
            [self layer];
        }
    }
    //--------------------------------------------- Watershad
    if (layer == LAYER_OPTIONS_WATERSHAD) {
        if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.กระบี่"]) { _urlConnect = [NSString stringWithFormat:@"%@/KrabiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.กาญจนบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/KanchanaburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.กาฬสินธุ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/KalasinProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.กำแพงเพชร"]) { _urlConnect = [NSString stringWithFormat:@"%@/KamphaengPhetProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ขอนแก่น"]) { _urlConnect = [NSString stringWithFormat:@"%@/KhonKaenProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.จันทบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChanthaburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ฉะเชิงเทรา"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChachoengsaoProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชลบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChonburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชัยนาท"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChainatProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชัยภูมิ"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChaiyaphumProvince.geojson",kWatershadURL]; [self  otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ชุมพร"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChumphonProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.เชียงราย"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChiangRaiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.เชียงใหม่"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChiangMaiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ตรัง"]) { _urlConnect = [NSString stringWithFormat:@"%@/TrangProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ตราด"]) { _urlConnect = [NSString stringWithFormat:@"%@/TratProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ตาก"]) { _urlConnect = [NSString stringWithFormat:@"%@/TakProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครนายก"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonNayokProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครพนม"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonPhanomProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครราชสีมา"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonRatchasimaProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครศรีธรรมราช"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonSiThammaratProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.นครสวรรค์"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonSawanProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.นราธิวาส"]) { _urlConnect = [NSString stringWithFormat:@"%@/NarathiwatProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.น่าน"]) { _urlConnect = [NSString stringWithFormat:@"%@/NanProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.บึงกาฬ"]) { _urlConnect = [NSString stringWithFormat:@"%@/BuengKanProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.บุรีรัมย์"]) { _urlConnect = [NSString stringWithFormat:@"%@/BuriramProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ประจวบคีรีขันธ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/PrachuapKhiriKhanProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ปราจีนบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PrachinburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ปัตตานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PattaniProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.พะเยา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhayaoProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.พังงา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhangNgaProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.พัทลุง"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhatthalungProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.พิจิตร"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhichitProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.พิษณุโลก"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhitsanulokProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.เพชรบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhetchaburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.เพชรบูรณ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhetchabunProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.แพร่"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhraeProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ภูเก็ต"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhuketProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.มุกดาหาร"]) { _urlConnect = [NSString stringWithFormat:@"%@/MukdahanProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.แม่ฮ่องสอน"]) { _urlConnect = [NSString stringWithFormat:@"%@/MaeHongSonProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ยโสธร"]) { _urlConnect = [NSString stringWithFormat:@"%@/YasothonProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ยะลา"]) { _urlConnect = [NSString stringWithFormat:@"%@/YalaProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ร้อยเอ็ด"]) { _urlConnect = [NSString stringWithFormat:@"%@/RoiEtProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ระนอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/RanongProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ระยอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/RayongProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ราชบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/RatchaburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ลพบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/LopburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ลำปาง"]) { _urlConnect = [NSString stringWithFormat:@"%@/LampangProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ลำพูน"]) { _urlConnect = [NSString stringWithFormat:@"%@/LamphunProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.เลย"]) { _urlConnect = [NSString stringWithFormat:@"%@/LoeiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.ศรีสะเกษ"]) { _urlConnect = [NSString stringWithFormat:@"%@/SisaketProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สกลนคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/SakonNakhonProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สงขลา"]) { _urlConnect = [NSString stringWithFormat:@"%@/SongkhlaProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สตูล"]) { _urlConnect = [NSString stringWithFormat:@"%@/SatunProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สระแก้ว"]) { _urlConnect = [NSString stringWithFormat:@"%@/SaKaeoProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สระบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SaraburiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุโขทัย"]) { _urlConnect = [NSString stringWithFormat:@"%@/SukhothaiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุพรรณบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SuphanBuriProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุราษฎร์ธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SuratThaniProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.สุรินทร์"]) { _urlConnect = [NSString stringWithFormat:@"%@/SurinProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.หนองคาย"]) { _urlConnect = [NSString stringWithFormat:@"%@/NongKhaiProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.หนองบัวลำภู"]) { _urlConnect = [NSString stringWithFormat:@"%@/NongBuaLamphuProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.อำนาจเจริญ"]) { _urlConnect = [NSString stringWithFormat:@"%@/AmnatCharoenProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุดรธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UdonThaniProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุตรดิตถ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/UttaraditProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุทัยธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UthaiThaniProvince.geojson",kWatershadURL]; [self otherLayer]; }
        else if ([[[_optionsWatershad objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ชั้นคุณภาพลุ่มน้ำ  จ.อุบลราชธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UbonRatchathaniProvince.geojson",kWatershadURL]; [self otherLayer]; }
    }
    //------------------------------Forest55-56
    if (layer == LAYER_OPTIONS_FOREST) {
        if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.กระบี่"]) { _urlConnect = [NSString stringWithFormat:@"%@/KrabiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  กรุงเทพมหานคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/BangKokProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.กาญจนบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/KanchanaburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.กาฬสินธุ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/KalasinProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.กำแพงเพชร"]) { _urlConnect = [NSString stringWithFormat:@"%@/KamphaengPhetProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ขอนแก่น"]) { _urlConnect = [NSString stringWithFormat:@"%@/KhonKaenProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.จันทบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChanthaburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ฉะเชิงเทรา"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChachoengsaoProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ชลบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChonburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ชัยนาท"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChainatProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ชัยภูมิ"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChaiyaphumProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ชุมพร"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChumphonProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.เชียงราย"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChiangMaiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.เชียงใหม่"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChiangRaiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ตรัง"]) { _urlConnect = [NSString stringWithFormat:@"%@/TrangProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ตราด"]) { _urlConnect = [NSString stringWithFormat:@"%@/TratProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ตาก"]) { _urlConnect = [NSString stringWithFormat:@"%@/TakProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.นครนายก"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonNayokProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.นครพนม"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonPhanomProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.นครราชสีมา"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonRatchasimaProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.นครศรีธรรมราช"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonSiThammaratProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.นครสวรรค์"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonSawanProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.นราธิวาส"]) { _urlConnect = [NSString stringWithFormat:@"%@/NarathiwatProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.น่าน"]) { _urlConnect = [NSString stringWithFormat:@"%@/NanProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.บึงกาฬ"]) { _urlConnect = [NSString stringWithFormat:@"%@/BuengKanProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.บุรีรัมย์"]) { _urlConnect = [NSString stringWithFormat:@"%@/BuriramProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ประจวบคีรีขันธ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/PrachuapKhiriKhanProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ปราจีนบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PrachinburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ปัตตานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PattaniProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.พะเยา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhayaoProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.พังงา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhangNgaProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.พัทลุง"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhatthalungProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.พิจิตร"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhichitProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.พิษณุโลก"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhitsanulokProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.เพชรบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhetchaburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.เพชรบูรณ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhetchabunProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.แพร่"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhraeProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ภูเก็ต"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhuketProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.มหาสารคาม"]) { _urlConnect = [NSString stringWithFormat:@"%@/MahaSarakhamProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.มุกดาหาร"]) { _urlConnect = [NSString stringWithFormat:@"%@/MukdahanProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.แม่ฮ่องสอน"]) { _urlConnect = [NSString stringWithFormat:@"%@/MaeHongSonProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ยโสธร"]) { _urlConnect = [NSString stringWithFormat:@"%@/YasothonProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ยะลา"]) { _urlConnect = [NSString stringWithFormat:@"%@/YalaProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ร้อยเอ็ด"]) { _urlConnect = [NSString stringWithFormat:@"%@/RoiEtProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ระนอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/RanongProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ระยอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/RayongProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ราชบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/RatchaburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ลพบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/LopburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ลำปาง"]) { _urlConnect = [NSString stringWithFormat:@"%@/LampangProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ลำพูน"]) { _urlConnect = [NSString stringWithFormat:@"%@/LamphunProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.เลย"]) { _urlConnect = [NSString stringWithFormat:@"%@/LoeiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.ศรีสะเกษ"]) { _urlConnect = [NSString stringWithFormat:@"%@/SisaketProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สกลนคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/SakonNakhonProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สงขลา"]) { _urlConnect = [NSString stringWithFormat:@"%@/SongkhlaProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สตูล"]) { _urlConnect = [NSString stringWithFormat:@"%@/SatunProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สมุทรปราการ"]) { _urlConnect = [NSString stringWithFormat:@"%@/SamutPrakanProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สมุทรสงคราม"]) { _urlConnect = [NSString stringWithFormat:@"%@/SamutSongkhramProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สมุทรสาคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/SamutSakhonProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สระแก้ว"]) { _urlConnect = [NSString stringWithFormat:@"%@/SaKaeoProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สระบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SaraburiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สุโขทัย"]) { _urlConnect = [NSString stringWithFormat:@"%@/SukhothaiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สุพรรณบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SuphanBuriProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สุราษฎร์ธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SuratThaniProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.สุรินทร์"]) { _urlConnect = [NSString stringWithFormat:@"%@/SurinProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.หนองคาย"]) { _urlConnect = [NSString stringWithFormat:@"%@/NongKhaiProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.หนองบัวลำภู"]) { _urlConnect = [NSString stringWithFormat:@"%@/NongBuaLamphuProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.อำนาจเจริญ"]) { _urlConnect = [NSString stringWithFormat:@"%@/AmnatCharoenProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.อุดรธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UdonThaniProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.อุตรดิตถ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/UttaraditProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.อุทัยธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UthaiThaniProvince.geojson",kForestURL]; [self otherLayer]; }
        else if ([[[_optionsForest objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  พื้นที่คงสภาพป่า  จ.อุบลราชธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UbonRatchathaniProvince.geojson",kForestURL]; [self otherLayer]; }
    }
    //------------------------------Amphoe
    if (layer == LAYER_OPTIONS_AMPHOE) {
        if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.กระบี่"]) { _urlConnect = [NSString stringWithFormat:@"%@/KrabiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.กรุงเทพมหานคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/BangKokProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.กาญจนบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/KanchanaburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.กาฬสินธุ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/KalasinProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.กำแพงเพชร"]) { _urlConnect = [NSString stringWithFormat:@"%@/KamphaengPhetProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ขอนแก่น"]) { _urlConnect = [NSString stringWithFormat:@"%@/KhonKaenProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.จันทบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChanthaburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ฉะเชิงเทรา"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChachoengsaoProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ชลบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChonburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ชัยนาท"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChainatProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ชัยภูมิ"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChaiyaphumProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ชุมพร"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChumphonProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.เชียงราย"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChiangMaiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.เชียงใหม่"]) { _urlConnect = [NSString stringWithFormat:@"%@/ChiangRaiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ตรัง"]) { _urlConnect = [NSString stringWithFormat:@"%@/TrangProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ตราด"]) { _urlConnect = [NSString stringWithFormat:@"%@/TratProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ตาก"]) { _urlConnect = [NSString stringWithFormat:@"%@/TakProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นครนายก"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonNayokProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นครปฐม"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonPathomProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นครพนม"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonPhanomProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นครราชสีมา"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonRatchasimaProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นครศรีธรรมราช"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonSiThammaratProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นครสวรรค์"]) { _urlConnect = [NSString stringWithFormat:@"%@/NakhonSawanProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นนทบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/NonthaburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.นราธิวาส"]) { _urlConnect = [NSString stringWithFormat:@"%@/NarathiwatProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.น่าน"]) { _urlConnect = [NSString stringWithFormat:@"%@/NanProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.บึงกาฬ"]) { _urlConnect = [NSString stringWithFormat:@"%@/BuengKanProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.บุรีรัมย์"]) { _urlConnect = [NSString stringWithFormat:@"%@/BuriramProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ปทุมธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PathumThaniProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ประจวบคีรีขันธ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/PrachuapKhiriKhanProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ปราจีนบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PrachinburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ปัตตานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PattaniProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.พระนครศรีอยุธยา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhraNakhonSiAyutthayaProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.พะเยา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhayaoProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.พังงา"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhangNgaProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.พัทลุง"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhatthalungProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.พิจิตร"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhichitProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.พิษณุโลก"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhitsanulokProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.เพชรบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhetchaburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.เพชรบูรณ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhetchabunProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.แพร่"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhraeProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ภูเก็ต"]) { _urlConnect = [NSString stringWithFormat:@"%@/PhuketProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.มหาสารคาม"]) { _urlConnect = [NSString stringWithFormat:@"%@/MahaSarakhamProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.มุกดาหาร"]) { _urlConnect = [NSString stringWithFormat:@"%@/MukdahanProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.แม่ฮ่องสอน"]) { _urlConnect = [NSString stringWithFormat:@"%@/MaeHongSonProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ยโสธร"]) { _urlConnect = [NSString stringWithFormat:@"%@/YasothonProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ยะลา"]) { _urlConnect = [NSString stringWithFormat:@"%@/YalaProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ร้อยเอ็ด"]) { _urlConnect = [NSString stringWithFormat:@"%@/RoiEtProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ระนอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/RanongProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ระยอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/RayongProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ราชบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/RatchaburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ลพบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/LopburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ลำปาง"]) { _urlConnect = [NSString stringWithFormat:@"%@/LampangProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ลำพูน"]) { _urlConnect = [NSString stringWithFormat:@"%@/LamphunProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.เลย"]) { _urlConnect = [NSString stringWithFormat:@"%@/LoeiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.ศรีสะเกษ"]) { _urlConnect = [NSString stringWithFormat:@"%@/SisaketProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สกลนคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/SakonNakhonProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สงขลา"]) { _urlConnect = [NSString stringWithFormat:@"%@/SongkhlaProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สตูล"]) { _urlConnect = [NSString stringWithFormat:@"%@/SatunProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สมุทรปราการ"]) { _urlConnect = [NSString stringWithFormat:@"%@/SamutPrakanProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สมุทรสงคราม"]) { _urlConnect = [NSString stringWithFormat:@"%@/SamutSongkhramProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สมุทรสาคร"]) { _urlConnect = [NSString stringWithFormat:@"%@/SamutSakhonProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สระแก้ว"]) { _urlConnect = [NSString stringWithFormat:@"%@/SaKaeoProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สระบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SaraburiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สิงห์บุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SingBuriProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สุโขทัย"]) { _urlConnect = [NSString stringWithFormat:@"%@/SukhothaiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สุพรรณบุรี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SuphanBuriProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สุราษฎร์ธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/SuratThaniProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.สุรินทร์"]) { _urlConnect = [NSString stringWithFormat:@"%@/SurinProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.หนองคาย"]) { _urlConnect = [NSString stringWithFormat:@"%@/NongKhaiProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.หนองบัวลำภู"]) { _urlConnect = [NSString stringWithFormat:@"%@/NongBuaLamphuProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.อ่างทอง"]) { _urlConnect = [NSString stringWithFormat:@"%@/AngThongProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.อำนาจเจริญ"]) { _urlConnect = [NSString stringWithFormat:@"%@/AmnatCharoenProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.อุดรธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UdonThaniProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.อุตรดิตถ์"]) { _urlConnect = [NSString stringWithFormat:@"%@/UttaraditProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.อุทัยธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UthaiThaniProvince.geojson",kAmphoeURL]; [self otherLayer]; }
        else if ([[[_optionsAmphoe objectAtIndex:anIndex] objectForKey:@"text"] isEqual: @"+  ขอบเขตอำเภอ  จ.อุบลราชธานี"]) { _urlConnect = [NSString stringWithFormat:@"%@/UbonRatchathaniProvince.geojson",kAmphoeURL]; [self otherLayer]; }
    }
}

- (void)leveyPopListViewDidCancel {
}

/*-(void)connectURL_JSON {
 //     UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
     //activityView.center=self.view.center;
    // [activityView startAnimating];
    // [self.view addSubview:activityView];
    
    [self showLoadingMode];
    
   // SVBlurView *blurView = [[SVBlurView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_mapView addSubview:blurView];
    [self setTitle:@"Loading..."];
    
    NSURL *url = [NSURL URLWithString:_urlConnect];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",url);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if ([data length] >0 && error == nil)
                               {
                                   //  [activityView stopAnimating];
                                   
                                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSArray *areas = [responseDictionary objectForKey:@"items"];
                                   //  NSLog(@"%@",busStops);
                                   for (NSDictionary *areaDictionary in areas) {
                                       
                                       //connect details
                                       
                                       Annotation *area = [[Annotation alloc] init];
                                       area.title = [areaDictionary objectForKey:@"label"];
                                       area.subtitle = [areaDictionary objectForKey:@"type"];
                                       
                                       NSString * __autoreleasing coordinates = [areaDictionary objectForKey:@"latlng"];
                                       
                                       double realLatitude = [[[coordinates componentsSeparatedByString:@","] objectAtIndex:2] doubleValue];
                                       double realLongitude = [[[coordinates componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
                                       
                                       CLLocationCoordinate2D theCoordinate;
                                       theCoordinate.latitude = realLatitude;
                                       theCoordinate.longitude = realLongitude;
                                       
                                       
                                       area.coordinate=CLLocationCoordinate2DMake(realLatitude,realLongitude);
                                       
                                       
                                       area.nameThai = [areaDictionary objectForKey:@""];
                                       area.type = [areaDictionary objectForKey:@"type"];
                                       
                                       [_mapView addAnnotation:area];
                                       [__areas addObject:area];
                                       [self.qTree insertObject:area];
                                       [self reloadAnnotations];
                                       
                                       //connect polygon
                                       
                                       area.polygon = [areaDictionary objectForKey:@"polygon"];
                                       
                                       NSArray * pole  = [area.polygon componentsSeparatedByString:@";"];
                                       
                                       CLLocationCoordinate2D *coords = malloc([pole count] * sizeof(CLLocationCoordinate2D));
                                       
                                       for(int i = 0; i < [pole count]; i++)
                                       {
                                           NSString *  coordinates2 = [pole objectAtIndex:i];
                                           coords[i] = CLLocationCoordinate2DMake ([[[coordinates2 componentsSeparatedByString:@","] objectAtIndex:1] doubleValue],[[[coordinates2 componentsSeparatedByString:@","] objectAtIndex:0] doubleValue]);
                                           
                                           //                NSLog(@"พิกัด %f , %f ลำดับ %d ทั้งหมด %lu", realLatitude2, realLongitude2, idx,(unsigned long)[pole count]);
                                           //    NSLog(@"%d",[busStops count]);
                                           //     NSLog(@"%@",coordinates2);
                                       }
                                       MKPolygon* polygon = [MKPolygon polygonWithCoordinates:coords count:[pole count]];
                                       free(coords);
                                       
                                       [_mapView addOverlay:polygon];
                                   }
                                   
                                   __listViewController.areas = __areas;
                                   
                                   NSArray *pole = [_mapView overlays];
                                   
                                   NSArray *area = [_mapView annotations];
                                   
                                   MKMapRect flyTo = MKMapRectNull;
                                   for (id <MKOverlay> overlay in pole) {
                                       if (MKMapRectIsNull(flyTo)) {
                                           flyTo = [overlay boundingMapRect];
                                       } else {
                                           flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
                                       }
                                   }
                                   
                                   for (id <MKAnnotation> annotation in area) {
                                       MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                                       MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                                       if (MKMapRectIsNull(flyTo)) {
                                           flyTo = pointRect;
                                       } else {
                                           flyTo = MKMapRectUnion(flyTo, pointRect);
                                       }
                                   }
                                   _mapView.visibleMapRect = flyTo;
                                   
                                   [self hideLoadingMode];
                                   [blurView removeFromSuperview];
                                   
                                   self.elaserAreaButton.hidden = NO;
                                   self.mapChageButton.hidden = NO;
                                   self.listChageButton.hidden = NO;
                          
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleSuccess
                                                                    message:@"Download Complete"];
                               }
                               else if ([data length] == 0 && error == nil)
                               {
                                   NSLog(@"Nothing was downloaded.");
                                   [self hideLoadingMode];
                                   [blurView removeFromSuperview];
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleError
                                                                    message:@"Download Error!"];
                               }
                               else if (error != nil){
                                   NSLog(@"Error = %@", error);
                                   
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnected", nil) message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                                   [alertView show];
                                   
                                   [self hideLoadingMode];
                                   [blurView removeFromSuperview];
                                   
                                   [CSNotificationView showInViewController:self
                                                                      style:CSNotificationViewStyleError
                                                                    message:@"Download Error!"];
                               }
                               
                           }];
}*/

/*-(void)showLoadingMode {
    if (!loadingCircle) {
        loadingCircle = [[MZLoadingCircle alloc]initWithNibName:nil bundle:nil];
        loadingCircle.view.backgroundColor = [UIColor clearColor];
        
        //Colors for layers
        loadingCircle.colorCustomLayer = [UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f];
        loadingCircle.colorCustomLayer2 = [UIColor colorWithRed:0 green:122/255. blue:1 alpha:0.65f];
        loadingCircle.colorCustomLayer3 = [UIColor colorWithRed:0 green:122/255. blue:1 alpha:0.4f];
        
        int size = 100;
        
        CGRect frame = loadingCircle.view.frame;
        frame.size.width = size ;
        frame.size.height = size;
        frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
        loadingCircle.view.frame = frame;
        loadingCircle.view.layer.zPosition = MAXFLOAT;
        [self.view addSubview: loadingCircle.view];
    }
}
-(void)hideLoadingMode {
    if (loadingCircle) {
        [loadingCircle.view removeFromSuperview];
        loadingCircle = nil;
        [self setTitle:@"Map"];
    }
}*/
- (void)viewDidUnload {
    [super viewDidUnload];
}



@end

