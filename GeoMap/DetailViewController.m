//
//  DetailViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "DetailViewController.h"
#import "CurlViewController.h"
#import "ViewController.h"
#import "GeodeticUTMConverter.h"
#import "TableViewCell.h"
#import "WebPDFViewController.h"
#import "AHKActionSheet.h"
#import "UseAreaDetailViewController.h"
#import "WeatherViewController.h"
#import "ZoningDetailViewController.h"
#import "MATableViewSection.h"
#import "MAActionCell.h"
#import "PinViewNRF.h"
#import "AGPhotoBrowserView.h"

static inline CLLocationCoordinate2D CLLocationCoordinateFromCoordinates(NSArray *coordinates) {
    NSCParameterAssert(coordinates && [coordinates count] == 2);
    /*    NSNumber *longitude = [coordinates objectAtIndex:0];//[coordinates firstObject];
     NSNumber *latitude = [coordinates objectAtIndex:1];
     
     return CLLocationCoordinate2DMake(CLLocationCoordinateNormalizedLatitude([latitude doubleValue]), CLLocationCoordinateNormalizedLongitude([longitude doubleValue]));
     // return CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
     }*/
    NSNumber *longitude = [coordinates objectAtIndex:0];//[coordinates firstObject];
    NSNumber *latitude = [coordinates objectAtIndex:1];
    
    UTMCoordinates originalCoord;
    originalCoord.gridZone = 47;
    originalCoord.northing = [latitude doubleValue];
    originalCoord.easting = [longitude doubleValue];
    originalCoord.hemisphere = kUTMHemisphereNorthern;
    
    GeodeticUTMConverter *converter = [[GeodeticUTMConverter alloc] init];
    CLLocationCoordinate2D convertCoordinate = [converter UTMCoordinatesToLatitudeAndLongitude:originalCoord];
    
    return CLLocationCoordinate2DMake(convertCoordinate.latitude, convertCoordinate.longitude);
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

static CGFloat kImageOriginHight = 190.f;

@interface DetailViewController ()<AGPhotoBrowserDelegate, AGPhotoBrowserDataSource>

@property (nonatomic, strong) AGPhotoBrowserView *browserView;

@property (strong, nonatomic) NSURL *url;

@property (nonatomic) BOOL modal;

@end

@implementation DetailViewController {
 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Attribute";
    
    //self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar.png"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //Button--- self.navigationItem.rightBarButtonItem  =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadObject)];

    [___mapView setShowsUserLocation:TRUE];
    
 
    ___tableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [___tableView addSubview:___mapView];
    
    self.mapTypeSegmentedControl.frame = CGRectMake(60, 3, 200, 25);//1213
    [___tableView addSubview:_mapTypeSegmentedControl];
    
    _div = [UIView new];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _div.frame = CGRectMake(0, self.view.frame.size.height - 40.0f, self.view.frame.size.width,self.view.frame.size.height +20);
    } else {
        _div.frame = CGRectMake(0, 390.0f, self.view.frame.size.width,self.view.frame.size.height +20);
    }
    _div.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    _div.layer.cornerRadius = 6.0f;
    [___mapView addSubview:_div];
    
    UILabel *slice = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 11)];
    slice.text = @"Slice";
    slice.font = [UIFont systemFontOfSize:11];
    slice.backgroundColor = [UIColor clearColor];
    slice.textColor = [UIColor whiteColor];
    slice.textAlignment = NSTextAlignmentCenter;
    // [sliceUp sizeToFit];
    [_div addSubview:slice];
    
    UIImageView *arrowUp = [[UIImageView alloc] initWithFrame:CGRectMake(145, 2.0f, 30, 12)];
    arrowUp.image = [UIImage imageNamed:@"ArrowUp.png"];
    arrowUp.layer.masksToBounds = YES;
    arrowUp.layer.rasterizationScale = [UIScreen mainScreen].scale;
    arrowUp.layer.shouldRasterize = YES;
    arrowUp.clipsToBounds = YES;
    [_div addSubview:arrowUp];
    
    UIImageView *arrowDown = [[UIImageView alloc] initWithFrame:CGRectMake(145, 28.0f, 30, 12)];
    arrowDown.image = [UIImage imageNamed:@"ArrowDown.png"];
    arrowDown.layer.masksToBounds = YES;
    arrowDown.layer.rasterizationScale = [UIScreen mainScreen].scale;
    arrowDown.layer.shouldRasterize = YES;
    arrowDown.clipsToBounds = YES;
    [_div addSubview:arrowDown];
    
    
    ___tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100.0f)];
       // CGSize size = [UIScreen mainScreen].bounds.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( ___tableView.frame.size.width - 59, 32, 45, 52)];//255
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        imageView.image = [UIImage imageNamed:@"Logo.png"];//who96.png
        
        //imageView.layer.masksToBounds = YES;
        //imageView.layer.cornerRadius = 25.0;
        //imageView.layer.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.7].CGColor;
        //imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 52, 0, 0)];
        label.text = @"ป่าสงวนแห่งชาติ";
        label.font = [UIFont systemFontOfSize:20];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        
        [view addSubview:label];
        [view addSubview:imageView];
        
        view;
    });
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    [___mapView setShowsUserLocation:YES];
    [___mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
 /*   NSArray * pole  = [self.area.polygon componentsSeparatedByString:@";"];
    
    CLLocationCoordinate2D *coords = malloc([pole count] * sizeof(CLLocationCoordinate2D));
    
    for(int i = 0; i < [pole count]; i++)
    {
        
        NSString *  coordinates2 = [pole objectAtIndex:i];
        
        coords[i] = CLLocationCoordinate2DMake ([[[coordinates2 componentsSeparatedByString:@","] objectAtIndex:1] doubleValue],[[[coordinates2 componentsSeparatedByString:@","] objectAtIndex:0] doubleValue]);
    }
    
    MKPolygon* polygon = [MKPolygon polygonWithCoordinates:coords count:[pole count]];
    free(coords);
    
    [___mapView addOverlay:polygon];*/
    
    if (_area.multiPolygon == nil) {
        
        NSString *jsonString = _area.polygon;
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *geometry = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
       // NSLog(@"%@",geometry);
        
        NSArray *coordinateSets = geometry[@"coordinates"];
        
        NSMutableArray *mutablePolygons = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
        for (NSArray *coordinatePairs in coordinateSets) {
            CLLocationCoordinate2D *polygonCoordinates = CLLocationCoordinatesFromCoordinatePairs(coordinatePairs);
            MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:[coordinatePairs count]];
            [mutablePolygons addObject:polygon];
        }
        
        MKPolygon *polygon = nil;
        switch ([mutablePolygons count]) {
            case 0:
                // return nil;
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
        [___mapView addOverlay:polygon];
        
    } else if (_area.polygon == nil) {
        
        NSLog(@"!!!");
        NSArray *array = _area.multiPolygon;
     
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
                                // return ;
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
                        [___mapView addOverlay:polygon];
                         NSLog(@"polygon = %@",polygon);
                    }
        }
    }
 
       /*             NSString *jsonString = _area.polygon;
      
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
                    [___mapView addOverlay:polygon];

    }*/
    [self setMapRegion];
    
    [self loadObject];

    [self addGestureRecogniserToImage];
    
}
- (void)setMapRegion {
    
    NSArray *pole = [___mapView overlays];
    
    NSArray *area = [___mapView annotations];
    
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
    ___mapView.visibleMapRect = flyTo;
}

- (void)loadPhoto {
    
    NSString *strURL = [[[NSString alloc]initWithFormat:@"%@?NRFCODE=%@",kPostPhotoURL,_area.code]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url = %@",strURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if ([data length] >0 && error == nil) {

                                   NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   
                                   for (NSMutableDictionary *dictionary in jsonObjects) {
                                       
                                       PhotoAnnotation *photo = [[PhotoAnnotation alloc] init];
                                       photo.title = [dictionary objectForKey:@"USETYPE"];
                                       photo.subtitle = [dictionary objectForKey:@"NRFNAME"];
                                       
                                       double realLatitude = [[dictionary objectForKey:@"LATITUDEPHOTO"] doubleValue];
                                       double realLongitude = [[dictionary objectForKey:@"LONGITUDEPHOTO"] doubleValue];
                                       
                                       CLLocationCoordinate2D theCoordinate;
                                       theCoordinate.latitude = realLatitude;
                                       theCoordinate.longitude = realLongitude;
                                       
                                       photo.coordinate=CLLocationCoordinate2DMake(realLatitude,realLongitude);
                                       
                                       photo.useType = [dictionary objectForKey:@"USETYPE"];
                                       photo.namePhoto = [dictionary objectForKey:@"NAMEPHOTO"];
                                       photo.NRFCode = [dictionary objectForKey:@"NRFCODE"];
                                       photo.NRFName = [dictionary objectForKey:@"NRFNAME"];
                                       photo.NRFProvince = [dictionary objectForKey:@"NRFPROVINCE"];
                                       photo.URLPhoto = [dictionary objectForKey:@"URLPHOTO"];
                                       
                                       [___mapView addAnnotation:photo];
                                   }
                               }
                               else if ([data length] == 0 && error == nil)
                               {
                                   NSLog(@"Nothing was downloaded.");
                                  // [self loadPhoto];
                               }
                               else if (error != nil){
                                   NSLog(@"Error = %@", error);
                                  // [self loadPhoto];
                               }
                           }];
    
}

- (void)loadObject {

    NSString *strURL = [[[NSString alloc]initWithFormat:@"%@?CODE=%@",kPostURL,_area.code]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url = %@",strURL);
    
   /* NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
                               if ([data length] >0 && error == nil) {*/
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSError *error;
    
    if ([data length] >0 && error == nil) {
        
        NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
                                   for (NSMutableDictionary *dictionary in jsonObjects) {
                                       
                                       _NAMET = [dictionary objectForKey:@"NAMET"];
                                       _NAMEE = [dictionary objectForKey:@"NAMEE"];
                                       _PROVINCE = [dictionary objectForKey:@"PROVINCE"];
                                       _CODE = [dictionary objectForKey:@"CODE"];
                                       _DEFENCEUNIT = [dictionary objectForKey:@"DEFENCEUNIT"];
                                       _OFFICE = [dictionary objectForKey:@"OFFICE"];
                                       _ECHODATE_I = [dictionary objectForKey:@"ECHODATE_I"];
                                       _ECHODATE_II = [dictionary objectForKey:@"ECHODATE_II"];
                                       _ECHODATE_III = [dictionary objectForKey:@"ECHODATE_III"];
                                       _ECHODATE_IV = [dictionary objectForKey:@"ECHODATE_IV"];
                                       _ECHODATE_V = [dictionary objectForKey:@"ECHODATE_V"];
                                       _PDFURL_I = [dictionary objectForKey:@"PDFURL_I"];
                                       _PDFURL_II = [dictionary objectForKey:@"PDFURL_II"];
                                       _PDFURL_III = [dictionary objectForKey:@"PDFURL_III"];
                                       _PDFURL_IV = [dictionary objectForKey:@"PDFURL_IV"];
                                       _PDFURL_V = [dictionary objectForKey:@"PDFURL_V"];
                                       _NRFPAR = [dictionary objectForKey:@"NRFPAR"];
                                       _LOGICECHO = [dictionary objectForKey:@"LOGICECHO"];
                                       _AREAECHOR = [dictionary objectForKey:@"AREAECHOR"];
                                       _AREAGISR = [dictionary objectForKey:@"AREAGISR"];
                                       _SURVEYBOOK = [dictionary objectForKey:@"SURVEYBOOK"];
                                       _NRFDOCUMENT = [dictionary objectForKey:@"NRFDOCUMENT"];
                                       _DATEUPDATE = [dictionary objectForKey:@"DATEUPDATEDATA"];
                                       
                                     // UseAreaDetailViewController
                                       _WATERSHAD = [dictionary objectForKey:@"WATERSHAD"];
                                       _FOREST55_56 = [dictionary objectForKey:@"FOREST55_56"];
                                       _SURVEYAREA_PEOPLE = [dictionary objectForKey:@"SURVEYAREA_PEOPLE"];
                                       _SURVEYAREA_PLOT = [dictionary objectForKey:@"SURVEYAREA_PLOT"];
                                       _SURVEYAREA_AREA = [dictionary objectForKey:@"SURVEYAREA_AREA"];
                                       _USEDAREA_PEOPLE = [dictionary objectForKey:@"USEDAREA_PEOPLE"];
                                       _USEDAREA_PLOT = [dictionary objectForKey:@"USEDAREA_PLOT"];
                                       _USEDAREA_AREA = [dictionary objectForKey:@"USEDAREA_AREA"];
                                       _RELATEFOREST_PEOPLE = [dictionary objectForKey:@"RELATEFOREST_PEOPLE"];
                                       _RELATEFOREST_PLOT = [dictionary objectForKey:@"RELATEFOREST_PLOT"];
                                       _RELATEFOREST_AREA = [dictionary objectForKey:@"RELATEFOREST_AREA"];
                                       _PERMANENTFOREST = [dictionary objectForKey:@"PERMANENTFOREST"];
                                       _CRIME_PEOPLE = [dictionary objectForKey:@"CRIME_PEOPLE"];
                                       _CRIME_AREA = [dictionary objectForKey:@"CRIME_AREA"];
                                       _COMMUNITYFOREST_PROJECT = [dictionary objectForKey:@"COMMUNITYFOREST_PROJECT"];
                                       _COMMUNITYFOREST_AREA = [dictionary objectForKey:@"COMMUNITYFOREST_AREA"];
                                       _INTERSECDNP = [dictionary objectForKey:@"INTERSECDNP"];
                                       _INTERSECWLS = [dictionary objectForKey:@"INTERSECWLS"];
                                       _INTERSECNHA = [dictionary objectForKey:@"INTERSECNHA"];
                                       _INTERSECFP = [dictionary objectForKey:@"INTERSECFP"];
                                       _ALR_PEOPLE = [dictionary objectForKey:@"ALR_PEOPLE"];
                                       _ALR_PLOT = [dictionary objectForKey:@"ALR_PLOT"];
                                       _ALR_AREA = [dictionary objectForKey:@"ALR_AREA"];
                                       _ALR_FOREST55_56 = [dictionary objectForKey:@"ALR_FOREST55_56"];
                                       _SELFCOLONY_PEOPLE = [dictionary objectForKey:@"SELFCOLONY_PEOPLE"];
                                       _SELFCOLONY_PLOT = [dictionary objectForKey:@"SELFCOLONY_PLOT"];
                                       _SELFCOLONY_AREA = [dictionary objectForKey:@"SELFCOLONY_AREA"];
                                       _COOPERATIVECOLONY_PEOPLE = [dictionary objectForKey:@"COOPERATIVECOLONY_PEOPLE"];
                                       _COOPERATIVECOLONY_PLOT = [dictionary objectForKey:@"COOPERATIVECOLONY_PLOT"];
                                       _COOPERATIVECOLONY_AREA = [dictionary objectForKey:@"COOPERATIVECOLONY_AREA"];
                                       _USED_STK_PEOPLE = [dictionary objectForKey:@"USED_STK_PEOPLE"];
                                       _USED_STK_PLOT = [dictionary objectForKey:@"USED_STK_PLOT"];
                                       _USED_STK_AREA = [dictionary objectForKey:@"USED_STK_AREA"];
                                       _LAW_A_PEOPLE = [dictionary objectForKey:@"LAW_A_PEOPLE"];
                                       _LAW_A_AREA = [dictionary objectForKey:@"LAW_A_AREA"];
                                       _LAW_B_PEOPLE = [dictionary objectForKey:@"LAW_B_PEOPLE"];
                                       _LAW_B_AREA = [dictionary objectForKey:@"LAW_B_AREA"];
                                       _LAW_C_PEOPLE = [dictionary objectForKey:@"LAW_C_PEOPLE"];
                                       _LAW_C_AREA = [dictionary objectForKey:@"LAW_C_AREA"];
                                       _LAW_D_PEOPLE = [dictionary objectForKey:@"LAW_D_PEOPLE"];
                                       _LAW_D_AREA = [dictionary objectForKey:@"LAW_D_AREA"];
                                       _LAW_E_PEOPLE = [dictionary objectForKey:@"LAW_E_PEOPLE"];
                                       _LAW_E_AREA= [dictionary objectForKey:@"LAW_E_AREA"];
                                       _LAW_F_PEOPLE = [dictionary objectForKey:@"LAW_F_PEOPLE"];
                                       _LAW_F_AREA = [dictionary objectForKey:@"LAW_F_AREA"];
                                       _LAW_G_PEOPLE = [dictionary objectForKey:@"LAW_G_PEOPLE"];
                                       _LAW_G_AREA = [dictionary objectForKey:@"LAW_G_AREA"];
                                       _LAW_H_PEOPLE = [dictionary objectForKey:@"LAW_H_PEOPLE"];
                                       _LAW_H_AREA = [dictionary objectForKey:@"LAW_H_AREA"];

                                       //ZoningDetailViewController
                                       _ZONEC = [dictionary objectForKey:@"ZONEC"];
                                       _ZONEE = [dictionary objectForKey:@"ZONEE"];
                                       _ZONEA = [dictionary objectForKey:@"ZONEA"];
                                       
                                       //WeatherDetailViewController
                                       _GEOHASH = [dictionary objectForKey:@"GEOHASH"];
                                       _MLS = [dictionary objectForKey:@"MLS"];
                                       _LATITUDE = [dictionary objectForKey:@"LATITUDE"];
                                       _LONGITUDE = [dictionary objectForKey:@"LONGITUDE"];
                                       double realLatitude = [_LATITUDE doubleValue];
                                       double realLongitude = [_LONGITUDE doubleValue];
                                       
                                       CLLocationCoordinate2D theCoordinate;
                                       theCoordinate.latitude = realLatitude;
                                       theCoordinate.longitude = realLongitude;
                                       
                                       MKPointAnnotation *centerPinMap = [[MKPointAnnotation alloc]init];
                                       
                                       centerPinMap.coordinate = CLLocationCoordinate2DMake(realLatitude,realLongitude);
                                       
                                       centerPinMap.title = [NSString stringWithFormat:@"%@",_NAMET];
                                       
                                       [___mapView addAnnotation:centerPinMap];
             
                                       [self generateTableView:_CODE];
                                       
                                       NSLog(@"_code.code = %@",_CODE);
                                   }
                               }
                               else if ([data length] == 0 && error == nil)
                               {
                                   NSLog(@"Nothing was downloaded.");
                                 //  [self loadObject];
                               }
                               else if (error != nil){
                                   NSLog(@"Error = %@", error);
                                  // [self loadObject];
                               }
                          // }];
    [self loadPhoto];
    
    [self setMapRegion];
}

- (void)generateTableView:(NSString *)codeObject {

    MAActionCell *nameTCell = [MAActionCell actionCellWithTitle:@"ชื่อป่าสงวนแห่งชาติ ( ภาษาไทย )" subtitle:_NAMET accessory:nil action:^{
    }];
    
    MAActionCell *nameECell = [MAActionCell actionCellWithTitle:@"ชื่อป่าสงวนแห่งชาติ ( ภาษาอังกฤษ )" subtitle:_NAMEE accessory:nil action:^{
    }];
    
    MAActionCell *provinceCell = [MAActionCell actionCellWithTitle:@"จังหวัด" subtitle:_PROVINCE accessory:nil action:^{
    }];
    
    MAActionCell *codeCell = [MAActionCell actionCellWithTitle:@"รหัสป่า" subtitle:_CODE accessory:nil action:^{
    }];
    
    if ([_DEFENCEUNIT isEqualToString:@"(null)"] || [_DEFENCEUNIT isEqualToString:@"-"] || [_DEFENCEUNIT isEqualToString:@""] || [_DEFENCEUNIT isEqualToString:nil]){
        
        _DEFENCEUNIT = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
        
    }
    MAActionCell *defenceUnitCell = [MAActionCell actionCellWithTitle:@"หน่วยป้องกันรักษาป่าที่ดูแล" subtitle:_DEFENCEUNIT accessory:nil action:^{
    }];
    
    MAActionCell *officeCell = [MAActionCell actionCellWithTitle:@"หน่วยงานรับผิดชอบ" subtitle:_OFFICE accessory:@"button" action:^{
        [self pushSafari];
    }];
    
    MAActionCell *echoCell = [MAActionCell actionCellWithTitle:nil subtitle:@"ประกาศท้ายกฏกระทรวง" accessory:@"button" action:^{
        
        NSLog(@"codeObject = %@",codeObject);
        [self reloadPDF];
    }];
    
    
    if ([_ECHODATE_V isEqualToString:@"(null)"] || [_ECHODATE_V isEqualToString:@"-"] || [_ECHODATE_V isEqualToString:@""] || [_ECHODATE_V isEqualToString:nil]){
        if ([_ECHODATE_IV isEqualToString:@"(null)"] || [_ECHODATE_IV isEqualToString:@"-"] || [_ECHODATE_IV isEqualToString:@""] || [_ECHODATE_IV isEqualToString:nil]){
            if ([_ECHODATE_III isEqualToString:@"(null)"] || [_ECHODATE_III isEqualToString:@"-"] || [_ECHODATE_III isEqualToString:@""] || [_ECHODATE_III isEqualToString:nil]){
                if ([_ECHODATE_II isEqualToString:@"(null)"] || [_ECHODATE_II isEqualToString:@"-"] || [_ECHODATE_II isEqualToString:@""] || [_ECHODATE_II isEqualToString:nil]){
                    _ECHOORDINAL = [NSString stringWithFormat:@"1 ครั้ง"];
                    _ECHODATE = [NSString stringWithFormat:@"%@", _ECHODATE_I];
                    _PDFLastedURL = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_I];
                } else {
                    _ECHOORDINAL = [NSString stringWithFormat:@"2 ครั้ง"];
                    _ECHODATE = [NSString stringWithFormat:@"%@", _ECHODATE_II];
                    _PDFLastedURL = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_II];
                }
            } else {
                _ECHOORDINAL = [NSString stringWithFormat:@"3 ครั้ง"];
                _ECHODATE = [NSString stringWithFormat:@"%@", _ECHODATE_III];
                _PDFLastedURL = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_III];
            }
        } else {
            _ECHOORDINAL = [NSString stringWithFormat:@"4 ครั้ง"];
            _ECHODATE = [NSString stringWithFormat:@"%@", _ECHODATE_IV];
            _PDFLastedURL = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_IV];
        }
    } else {
        _ECHOORDINAL = [NSString stringWithFormat:@"5 ครั้ง"];
        _ECHODATE = [NSString stringWithFormat:@"%@", _ECHODATE_V];
        _PDFLastedURL = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_V];
    }

    
    MAActionCell *echoOrdinalCell = [MAActionCell actionCellWithTitle:@"จำนวนการประกาศ" subtitle:_ECHOORDINAL accessory:nil action:^{
    }];
    
    MAActionCell *echoDateCell = [MAActionCell actionCellWithTitle:@"ประกาศล่าสุด" subtitle:_ECHODATE accessory:@"button" action:^{

        [self reloadPDFLasted];
    }];
    
    MAActionCell *NRFParCell = [MAActionCell actionCellWithTitle:@"ประกาศท้ายกฏกระทรวงล่าสุด ฉบับที่ / ปี พ.ศ." subtitle:_NRFPAR accessory:nil action:^{
    }];
    
    
    if ([_LOGICECHO isEqualToString:@"(null)"] || [_LOGICECHO isEqualToString:@"-"] || [_LOGICECHO isEqualToString:@""] || [_LOGICECHO isEqualToString:nil]){
        
        _LOGICECHO = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
    } else {
    
    }
    MAActionCell *logicEchoCell = [MAActionCell actionCellWithTitle:@"หมายเหตุการประกาศ" subtitle:_LOGICECHO accessory:nil action:^{
    }];
    
    
    MAActionCell *useAreaCell = [MAActionCell actionCellWithTitle:nil subtitle:@"สรุปการใช้ประโยชน์พื้นที่" accessory:@"button" action:^{
        [self pushUseAreaDetail];
    }];
    
    MAActionCell *areaEchoRCell = [MAActionCell actionCellWithTitle:@"ขนาดพื้นที่ตามประกาศ" subtitle:[NSString stringWithFormat:@"%@  ไร่",_AREAECHOR] accessory:nil action:^{
    }];
    
    MAActionCell *areaGISRCell = [MAActionCell actionCellWithTitle:@"ขนาดพื้นที่ตามระบบภูมิสารสนเทศ (GIS)" subtitle:[NSString stringWithFormat:@"%@  ไร่",_AREAGISR] accessory:nil action:^{
    }];
    
    MAActionCell *zoningCell = [MAActionCell actionCellWithTitle:@"เขตการจำแนกการใช้ประโยชน์ที่ดิน" subtitle:@"Zoning" accessory:@"button" action:^{
        
        NSLog(@"codeObject = %@",codeObject);
        [self pushZoning];
    }];
    
    MAActionCell *surveyBookCell = [MAActionCell actionCellWithTitle:_SURVEYBOOK subtitle:@"สมุดจดรายการรังวัด" accessory:@"button" action:^{
        [self pushSurveyBook];
    }];
    
    MAActionCell *NRFDocumentCell = [MAActionCell actionCellWithTitle:_NRFDOCUMENT subtitle:@"แฟ้มประวัติป่า" accessory:@"button" action:^{
        [self pushNRFDocument];
    }];
    
    MAActionCell *etcCell = [MAActionCell actionCellWithTitle:nil subtitle:@"ข้อมูลอื่นๆ" accessory:@"button" action:^{
        [self pushWeather];
    }];
    
    MAActionCell *updateDateCell = [MAActionCell actionCellWithTitle:@"บันทึกข้อมูลเมื่อ" subtitle:_DATEUPDATE accessory:nil action:^{
    }];
    

    MATableViewSection *firstSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[nameTCell, nameECell, provinceCell, codeCell, defenceUnitCell, officeCell]];
    MATableViewSection *secondSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[echoCell, echoOrdinalCell, echoDateCell, NRFParCell, logicEchoCell]];
    MATableViewSection *thirdSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[useAreaCell, areaEchoRCell, areaGISRCell]];
    MATableViewSection *fourthSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[zoningCell]];
    MATableViewSection *fifthSection = [MATableViewSection sectionWithTitle:@"PDF File" footer:@"" cells:@[surveyBookCell, NRFDocumentCell]];
    MATableViewSection *sixSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[etcCell]];
    MATableViewSection *sevenSection = [MATableViewSection sectionWithTitle:@"" footer:@"" cells:@[updateDateCell]];

    
   /* UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kittens.jpg"]];
    MATableViewSection *thirdSection = [MATableViewSection sectionWithView:headerImageView height:80 cells:@[fourthCell]];*/
   
    _sections = @[firstSection, secondSection, thirdSection, fourthSection, fifthSection, sixSection, sevenSection];
}


#pragma mark - Actions

- (void)pushSafari {
    NSURL *url = [NSURL URLWithString:@"http://www.forest.go.th"];
    
    [[UIApplication sharedApplication] openURL:url];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void)pushWeather {
    [self performSegueWithIdentifier:@"DetailTableToWeather" sender:self];
}

- (void)pushUseAreaDetail {
   // UIViewController *newVC = [UIViewController new];
   // newVC.view.backgroundColor = [UIColor whiteColor];
   // [self.navigationController pushViewController:newVC animated:YES];

    [self performSegueWithIdentifier:@"DetailTableToUseAreaDetail" sender:self];
}

- (void)pushZoning {
    [self performSegueWithIdentifier:@"DetailTableToZoning" sender:self];
}

- (void)pushSurveyBook {
    NSString *urlString = [NSString stringWithFormat:@"http://%@",_SURVEYBOOK];
    _url = [NSURL URLWithString:urlString];
    
    [self performSegueWithIdentifier:@"ModalPDF" sender:self];
}

- (void)pushNRFDocument {
    NSString *urlString = [NSString stringWithFormat:@"http://%@",_NRFDOCUMENT];
    _url = [NSURL URLWithString:urlString];
    
    [self performSegueWithIdentifier:@"ModalPDF" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.cells.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 0 && indexPath.section == 0) || (indexPath.row == 1 && indexPath.section == 0) || (indexPath.row == 4 && indexPath.section == 0)) {
        return 100;
    } else if (indexPath.row == 4 && indexPath.section == 1) {
        return 250;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.headerHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    MATableViewSection *mySection = _sections[section];
    return mySection.footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MATableViewSection *mySection = _sections[indexPath.section];
 
    return mySection.cells[indexPath.row];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:13];
    header.textLabel.textColor = [UIColor blackColor];
}


#pragma  mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MATableViewSection *mySection = _sections[indexPath.section];
    MAActionCell *selectedCell = mySection.cells[indexPath.row];
    selectedCell.actionBlock();
   
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
    polygonRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];//[UIColor blackColor];
    polygonRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
    polygonRenderer.lineWidth = 0.5f;
    
    
    return polygonRenderer;
}

- (void)addGestureRecogniserToImage{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(imageFullScreen:)];
    lpgr.minimumPressDuration = 0.5;
    [___mapView addGestureRecognizer:lpgr];
}

- (void)imageFullScreen:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    // CGSize size = [UIScreen mainScreen].bounds.size;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        ___mapView.frame = CGRectMake(0, -kImageOriginHight -63, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        ___mapView.frame = CGRectMake(0, -kImageOriginHight, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [___tableView bringSubviewToFront:___mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    ___mapView.frame = CGRectMake(0, -kImageOriginHight, ___tableView.frame.size.width, kImageOriginHight);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = ___mapView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        ___mapView.frame = f;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)mapTypeChage:(id)sender {
  
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            ___mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            ___mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            ___mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

- (void)reloadPDFLasted {
    _url = [NSURL URLWithString:_PDFLastedURL];
    
    [self performSegueWithIdentifier:@"ModalPDF" sender:self];
}

- (void)reloadPDF {
    
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:NSLocalizedString(@"PDF", nil)];
    [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"ประกาศฯ เมื่อ: %@",_ECHODATE_I]
                              image:[UIImage imageNamed:@"Mreffer"]
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                
                                NSString *urlString = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_I];
                                _url = [NSURL URLWithString:urlString];
                                
                                [self performSegueWithIdentifier:@"ModalPDF" sender:self];
                            }];
    if ([_ECHODATE_II isEqualToString:@"-"]) {
        
    } else {
        if ([_ECHODATE_II isEqualToString:@"-"]) {
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"ประกาศฯ รับเพิ่มจากกรมป่าไม้"]
                                      image:[UIImage imageNamed:@"Mreffer"]
                                       type:AHKActionSheetButtonTypeDefault
                                    handler:^(AHKActionSheet *as) {
                                        
                                        NSString *urlString = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_II];
                                        _url = [NSURL URLWithString:urlString];
                                        
                                        [self performSegueWithIdentifier:@"ModalPDF" sender:self];
                                    }];
        } else {
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"ประกาศฯ เมื่อ: %@",_ECHODATE_II]
                                      image:[UIImage imageNamed:@"Mreffer"]
                                       type:AHKActionSheetButtonTypeDefault
                                    handler:^(AHKActionSheet *as) {
                                        
                                        NSString *urlString = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_II];
                                        _url = [NSURL URLWithString:urlString];
                                        
                                        [self performSegueWithIdentifier:@"ModalPDF" sender:self];
                                    }];
        }
    }
    if ([_ECHODATE_III isEqualToString:@"-"]) {
        
    } else {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"ประกาศฯ เมื่อ: %@",_ECHODATE_III]
                                  image:[UIImage imageNamed:@"Mreffer"]
                                   type:AHKActionSheetButtonTypeDefault
                                handler:^(AHKActionSheet *as) {
                                    
                                    NSString *urlString = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_III];
                                    _url = [NSURL URLWithString:urlString];
                                    
                                    [self performSegueWithIdentifier:@"ModalPDF" sender:self];
                                }];
    }
    if ([_ECHODATE_IV isEqualToString:@"-"]) {
        
    } else {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"ประกาศฯ เมื่อ: %@",_ECHODATE_IV]
                                  image:[UIImage imageNamed:@"Mreffer"]
                                   type:AHKActionSheetButtonTypeDefault
                                handler:^(AHKActionSheet *as) {
                                    
                                    NSString *urlString = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_IV];
                                    _url = [NSURL URLWithString:urlString];
                                    
                                    [self performSegueWithIdentifier:@"ModalPDF" sender:self];
                                }];
    }

    if ([_ECHODATE_V isEqualToString:@"-"]) {
        
    } else {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"ประกาศฯ เมื่อ: %@",_ECHODATE_V]
                                  image:[UIImage imageNamed:@"Mreffer"]
                                   type:AHKActionSheetButtonTypeDefault
                                handler:^(AHKActionSheet *as) {
                                    
                                    NSString *urlString = [NSString stringWithFormat: @"%@/%@",kPDFURL,_PDFURL_V];
                                    _url = [NSURL URLWithString:urlString];
                                    
                                    [self performSegueWithIdentifier:@"ModalPDF" sender:self];
                                }];
    }
    [actionSheet show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ModalPDF"]) {
        if ([segue.destinationViewController isKindOfClass:[WebPDFViewController class]]) {
            WebPDFViewController *webPDFViewController = (WebPDFViewController *)segue.destinationViewController;
            webPDFViewController.url = _url;
        }
    }
    
    if ([segue.identifier isEqualToString:@"DetailTableToUseAreaDetail"]) {
        UseAreaDetailViewController *controller = [segue destinationViewController];
        
        controller.AREAECHOR = _AREAECHOR;
        controller.AREAGISR = _AREAGISR;
        controller.WATERSHAD = _WATERSHAD;
        controller.FOREST55_56 = _FOREST55_56;
        controller.SURVEYAREA_PEOPLE = _SURVEYAREA_PEOPLE;
        controller.SURVEYAREA_PLOT = _SURVEYAREA_PLOT;
        controller.SURVEYAREA_AREA = _SURVEYAREA_AREA;
        controller.USEDAREA_PEOPLE = _USEDAREA_PEOPLE;
        controller.USEDAREA_PLOT = _USEDAREA_PLOT;
        controller.USEDAREA_AREA = _USEDAREA_AREA;
        controller.RELATEFOREST_PEOPLE = _RELATEFOREST_PEOPLE;
        controller.RELATEFOREST_PLOT = _RELATEFOREST_PLOT;
        controller.RELATEFOREST_AREA = _RELATEFOREST_AREA;
        controller.PERMANENTFOREST = _PERMANENTFOREST;
        controller.CRIME_PEOPLE = _CRIME_PEOPLE;
        controller.CRIME_AREA = _CRIME_AREA;
        controller.COMMUNITYFOREST_PROJECT = _COMMUNITYFOREST_PROJECT;
        controller.COMMUNITYFOREST_AREA = _COMMUNITYFOREST_AREA;
        controller.INTERSECDNP = _INTERSECDNP;
        controller.INTERSECWLS = _INTERSECWLS;
        controller.INTERSECNHA = _INTERSECNHA;
        controller.INTERSECFP = _INTERSECFP;
        controller.ALR_PEOPLE = _ALR_PEOPLE;
        controller.ALR_PLOT = _ALR_PLOT;
        controller.ALR_AREA = _ALR_AREA;
        controller.ALR_FOREST55_56 = _ALR_FOREST55_56;
        controller.SELFCOLONY_PEOPLE = _SELFCOLONY_PEOPLE;
        controller.SELFCOLONY_PLOT = _SELFCOLONY_PLOT;
        controller.SELFCOLONY_AREA = _SELFCOLONY_AREA;
        controller.COOPERATIVECOLONY_PEOPLE = _COOPERATIVECOLONY_PEOPLE;
        controller.COOPERATIVECOLONY_PLOT = _COOPERATIVECOLONY_PLOT;
        controller.COOPERATIVECOLONY_AREA = _COOPERATIVECOLONY_AREA;
        controller.USED_STK_PEOPLE= _USED_STK_PEOPLE;
        controller.USED_STK_PLOT = _USED_STK_PLOT;
        controller.USED_STK_AREA = _USED_STK_AREA;
        
        controller.LAW_A_PEOPLE = _LAW_A_PEOPLE;
        controller.LAW_A_AREA = _LAW_A_AREA;
        controller.LAW_B_PEOPLE = _LAW_B_PEOPLE;
        controller.LAW_B_AREA = _LAW_B_AREA;
        controller.LAW_C_PEOPLE = _LAW_C_PEOPLE;
        controller.LAW_C_AREA = _LAW_C_AREA;
        controller.LAW_D_PEOPLE = _LAW_D_PEOPLE;
        controller.LAW_D_AREA = _LAW_D_AREA;
        controller.LAW_E_PEOPLE = _LAW_E_PEOPLE;
        controller.LAW_E_AREA = _LAW_E_AREA;
        controller.LAW_F_PEOPLE = _LAW_F_PEOPLE;
        controller.LAW_F_AREA = _LAW_F_AREA;
        controller.LAW_G_PEOPLE = _LAW_G_PEOPLE;
        controller.LAW_G_AREA = _LAW_G_AREA;
        controller.LAW_H_PEOPLE = _LAW_H_PEOPLE;
        controller.LAW_H_AREA = _LAW_H_AREA;
    }
    
    if ([segue.identifier isEqualToString:@"DetailTableToWeather"]) {
        WeatherViewController *controller = [segue destinationViewController];
        controller.weatherGEOHASH = _GEOHASH;
        controller.weatherLATITUDE = _LATITUDE;
        controller.weatherLONGITUDE = _LONGITUDE;
        controller.weatherMLS = _MLS;
    }
    
    if ([segue.identifier isEqualToString:@"DetailTableToZoning"]) {
        ZoningDetailViewController *controller = [segue destinationViewController];
        controller.ZONEC = _ZONEC;
        controller.ZONEE = _ZONEE;
        controller.ZONEA = _ZONEA;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        NSString *ForestPinIdentifier = @"ForestPinIdentifier";
        PinViewNRF* annotationView = (PinViewNRF*)[mapView dequeueReusableAnnotationViewWithIdentifier:ForestPinIdentifier];
        
        if( !annotationView ) {
            annotationView = [[PinViewNRF alloc] initWithAnnotation:annotation reuseIdentifier:ForestPinIdentifier];
            
           //annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.canShowCallout = YES;
           // annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[PhotoAnnotation class]]) {
        NSString *photoPin = @"PhotoPin";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:photoPin];
        
        if( !annotationView ) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:photoPin];
            annotationView.pinColor = MKPinAnnotationColorPurple;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[PhotoAnnotation class]]) {
        
        [self.browserView show];
        
        // [self.browserView showFromIndex:indexPath.row];
    } else if ([view.annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dropped Pin"message:[NSString stringWithFormat:@""] delegate:self cancelButtonTitle:@"cancel"otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    return 1;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    PhotoAnnotation *selectedAnnotation = [___mapView selectedAnnotations][0];
    
    _photoObject = selectedAnnotation;
    
    NSURL *url = [NSURL URLWithString:_photoObject.URLPhoto];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    
    if ([data length] >0 && error == nil){
        image = [UIImage imageWithData:data];
    } else if ([data length] == 0 && error == nil){
        NSLog(@"Nothing was downloaded.");
        [self.browserView hideWithCompletion:^(BOOL finished){
            NSLog(@"Dismissed!");
        }];
    } else if (error != nil){
        NSLog(@"Error = %@", error);
        [self.browserView hideWithCompletion:^(BOOL finished){
            NSLog(@"Dismissed!");
        }];
    }
    return image;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
    PhotoAnnotation *selectedAnnotation = [___mapView selectedAnnotations][0];
    
    _photoObject = selectedAnnotation;
    return _photoObject.useType;
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
    PhotoAnnotation *selectedAnnotation = [___mapView selectedAnnotations][0];
    
    _photoObject = selectedAnnotation;
	return [NSString stringWithFormat:@"%@  จ.%@",_photoObject.NRFName, _photoObject.NRFProvince];
}

#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	// -- Dismiss
	NSLog(@"Dismiss the photo browser here");
	[self.browserView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
	}];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
	//[self action];
    [self.browserView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
	}];
}

#pragma mark - Getters

- (AGPhotoBrowserView *)browserView
{
	if (!_browserView) {
		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:self.view.bounds];
		_browserView.delegate = self;
		_browserView.dataSource = self;
	}
	
	return _browserView;
}

@end
