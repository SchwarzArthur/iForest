//
//  addPinDetailViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 2/21/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "AddPinDetailViewController.h"
#import "ViewController.h"
#import "GeodeticUTMConverter.h"

static NSString *API_KEY = @"YOUR_API_KEY_HERE";
static CGFloat kImageOriginHight = 190.f;

@interface AddPinDetailViewController ()

{
    //  __weak IBOutlet UILabel *_titleLabel;
}

@end

@implementation AddPinDetailViewController {
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@synthesize record;

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
    self.navigationItem.title = @"Find Location";//[NSString stringWithFormat:@"%@",self.pin.title];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:116.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  
    [____mapView setShowsUserLocation:TRUE];
    
    //User location tracking
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    
    _userLocation = [_locationManager.location copy];
    NSLog(@"%f %f User location", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    
    geocoder = [[CLGeocoder alloc] init];
    
    // ___tableView.backgroundColor = [UIColor clearColor];
    [self._mapTypeSegmentedControl setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:0];
    [self._mapTypeSegmentedControl setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:1];
    [self._mapTypeSegmentedControl setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:2];
    
    ____tableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [____tableView addSubview:____mapView];
    
    self._mapTypeSegmentedControl.frame = CGRectMake(60, 5, 200, 25);//1213
    [____tableView addSubview:__mapTypeSegmentedControl];
    
    _div = [UIView new];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        _div.frame = CGRectMake(0, self.view.frame.size.height - 40.0f, self.view.frame.size.width,self.view.frame.size.height +20);
    } else {
        _div.frame = CGRectMake(0, 390.0f, self.view.frame.size.width,self.view.frame.size.height +20);
    }
    _div.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    _div.layer.cornerRadius = 6.0f;
    [____mapView addSubview:_div];
    
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
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.pin.coordinate.latitude longitude:self.pin.coordinate.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            UILabel *subThoroughfare = [[UILabel alloc] initWithFrame:CGRectMake(60, 160, 0, 0)];
            if (placemark.subThoroughfare == nil) {
                subThoroughfare.text = nil;
            } else {
                subThoroughfare.text = [NSString stringWithFormat:@"%@",
                                        placemark.subThoroughfare];
            }
            subThoroughfare.font = [UIFont systemFontOfSize:13];
            subThoroughfare.backgroundColor = [UIColor clearColor];
            subThoroughfare.textColor = [UIColor blackColor];
            [subThoroughfare sizeToFit];
            [____tableView addSubview:subThoroughfare];
            
            UILabel *thoroughfare = [[UILabel alloc] initWithFrame:CGRectMake(60, 180, 0, 0)];
            if (placemark.thoroughfare == nil) {
                thoroughfare.text = nil;
            } else {
                thoroughfare.text = [NSString stringWithFormat:@"%@",
                                     placemark.thoroughfare];
            }
            thoroughfare.font = [UIFont systemFontOfSize:13];
            thoroughfare.backgroundColor = [UIColor clearColor];
            thoroughfare.textColor = [UIColor blackColor];
            [thoroughfare sizeToFit];
            [____tableView addSubview:thoroughfare];
            
            UILabel *locality = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 0, 0)];
            if (placemark.locality == nil) {
                locality.text = nil;
            } else {
                locality.text = [NSString stringWithFormat:@"%@",
                                 placemark.locality];
            }
            locality.font = [UIFont systemFontOfSize:13];
            locality.backgroundColor = [UIColor clearColor];
            locality.textColor = [UIColor blackColor];
            [locality sizeToFit];
            [____tableView addSubview:locality];
            
            UILabel *administrativeArea = [[UILabel alloc] initWithFrame:CGRectMake(60, 220, 0, 0)];
            if (placemark.administrativeArea == nil) {
                administrativeArea.text = nil;
            } else {
                administrativeArea.text = [NSString stringWithFormat:@"%@",
                                           placemark.administrativeArea];
            }
            administrativeArea.font = [UIFont systemFontOfSize:12];
            administrativeArea.backgroundColor = [UIColor clearColor];
            administrativeArea.textColor = [UIColor blackColor];
            [administrativeArea sizeToFit];
            [____tableView addSubview:administrativeArea];
            
            UILabel *country = [[UILabel alloc] initWithFrame:CGRectMake(60, 240, 0, 0)];
            if (placemark.country == nil && placemark.postalCode == nil) {
                country.text = nil;
            } else if (placemark.country == nil) {
                country.text = [NSString stringWithFormat:@"%@",
                                placemark.postalCode];
            } else if (placemark.postalCode == nil) {
                country.text = [NSString stringWithFormat:@"%@",
                                placemark.country];
            } else {
                country.text = [NSString stringWithFormat:@"%@,  %@",
                                placemark.country,placemark.postalCode];
            }
            country.font = [UIFont systemFontOfSize:13];
            country.backgroundColor = [UIColor clearColor];
            country.textColor = [UIColor blackColor];
            [country sizeToFit];
            [____tableView addSubview:country];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    ____tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 90.0f)];
        
        UIView *div3 = [UIView new];
        div3.frame = CGRectMake(10, 35, ____tableView.frame.size.width - 2*10, 1.0f);//60
        div3.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
        [view addSubview:div3];
        
        UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonOne.frame = CGRectMake(20, 40, 40, 40);
        //[buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
        [buttonOne setTitle:@"Share" forState:UIControlStateNormal];
        buttonOne.titleLabel.font = [UIFont systemFontOfSize:11];
        buttonOne.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0];
        buttonOne.layer.backgroundColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
        buttonOne.layer.cornerRadius = 20.0f;
        buttonOne.layer.borderWidth = 1.0f;
        buttonOne.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
        [buttonOne addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonTwo.frame = CGRectMake(100, 40, 40, 40);
        //[buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
        [buttonTwo setTitle:@"Share" forState:UIControlStateNormal];
        buttonTwo.titleLabel.font = [UIFont systemFontOfSize:11];
        buttonTwo.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0];
        buttonTwo.layer.backgroundColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
        buttonTwo.layer.cornerRadius = 20.0f;
        buttonTwo.layer.borderWidth = 1.0f;
        buttonTwo.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
        [buttonTwo addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *buttonThree = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonThree.frame = CGRectMake(180, 40, 40, 40);
        //[buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
        [buttonThree setTitle:@"Share" forState:UIControlStateNormal];
        buttonThree.titleLabel.font = [UIFont systemFontOfSize:11];
        buttonThree.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0];
        buttonThree.layer.backgroundColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
        buttonThree.layer.cornerRadius = 20.0f;
        buttonThree.layer.borderWidth = 1.0f;
        buttonThree.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
        [buttonThree addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *buttonFour = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonFour.frame = CGRectMake(260, 40, 40, 40);
        //[buttonPost setImage:[UIImage imageNamed:@"btn_post"] forState:UIControlStateNormal];
        [buttonFour setTitle:@"Share" forState:UIControlStateNormal];
        buttonFour.titleLabel.font = [UIFont systemFontOfSize:11];
        buttonFour.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0];
        buttonFour.layer.backgroundColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:28.0/255.0 green:134.0/255.0 blue:238.0/255.0 alpha:1].CGColor;
        buttonFour.layer.cornerRadius = 20.0f;
        buttonFour.layer.borderWidth = 1.0f;
        buttonFour.layer.borderColor = [UIColor colorWithRed:0/255.0 green:161/225.0 blue:0/255.0 alpha:1.0].CGColor;
        [buttonFour addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        /*[view addSubview:buttonOne];
        [view addSubview:buttonTwo];
        [view addSubview:buttonThree];
        [view addSubview:buttonFour];*/
        
        view;
    });
    [____mapView setShowsUserLocation:NO];
    
    MKPointAnnotation *centerPinMap = [[MKPointAnnotation alloc]init];
    centerPinMap.coordinate = self.pin.coordinate;
    centerPinMap.title = @"This Here!";//[NSString stringWithFormat:@"%@",self.pin.title];
    [____mapView addAnnotation:centerPinMap];
    
    
    NSArray *area = [____mapView annotations];
    
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
    ____mapView.visibleMapRect = flyTo;
    
	tableViewContents = [[NSMutableArray alloc]initWithCapacity:15];
    
    for (int i=0; i<15; i++) {
        [tableViewContents addObject:@"Loading"];
    }
    
    weatherManager = [[JFWeatherManager alloc]init];
    [self tableViewContents];
    
    // _titleLabel.text = self.area.title;
    [self addGestureRecogniserToImage];
    
}

- (void)addGestureRecogniserToImage{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(imageFullScreen:)];
    lpgr.minimumPressDuration = 0.5;
    [____mapView addGestureRecognizer:lpgr];
}

- (void)imageFullScreen:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    // CGSize size = [UIScreen mainScreen].bounds.size;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        ____mapView.frame = CGRectMake(0, -kImageOriginHight -63, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        ____mapView.frame = CGRectMake(0, -kImageOriginHight, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [____tableView bringSubviewToFront:____mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    ____mapView.frame = CGRectMake(0, -kImageOriginHight, ____tableView.frame.size.width, kImageOriginHight);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = ____mapView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        ____mapView.frame = f;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        return 40;
    } else if (indexPath.row == 0 && indexPath.section == 0) {
        return 20;
    } else if (indexPath.row == 2 && indexPath.section == 0) {
        return 115;
    } else {
        return 40;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    /*  if (section == 0)
     return @"Attributes";
     else
     return  @"Weather Attributes";*/
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 6;
    else if (section == 1)
        return 15;
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  //  NSAssert([self.pin isKindOfClass:[AddAnnotation class]], @"DataSource must provide array of PDLocations");
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.pin.coordinate.latitude longitude:self.pin.coordinate.longitude];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = self.pin.coordinate.latitude;
    coordinates.longitude = self.pin.coordinate.longitude;
    
    GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
    UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:coordinates];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Attributes"];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                [cell.detailTextLabel setText:nil];
                // cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.backgroundColor = [UIColor darkGrayColor];
                break;

            case 1:
            {
                [cell.textLabel setText:@"ระยะทางจากที่นี่ถึงหมุด :"];
                
                CLLocationDistance distance = [_userLocation distanceFromLocation:location];
                
                if (distance == 0) {
                    
                } else {
                    
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.01f Km", distance/1000]];
                    
                }
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //[cell.detailTextLabel setTextColor:[UIColor grayColor]];
                cell.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
            }
                break;
                
            case 2:
                [cell.textLabel setText:@"ที่อยู่ :"];
                [cell.detailTextLabel setText:nil];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            
                
            case 3:
                [cell.textLabel setText:@"X (easting) [UTM]"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",utmCoordinates.easting]];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 4:
                [cell.textLabel setText:@"Y (northing) [UTM]"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",utmCoordinates.northing]];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 5:
                [cell.textLabel setText:@"Zone"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%u",utmCoordinates.gridZone]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
        }
    } else if (indexPath.section == 1) {
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Latitude"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:4.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"Longitude"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:4.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 2:
                [cell.textLabel setText:@"Conditions"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 3:
                [cell.textLabel setText:@"Temperature (°C)"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 4:
                [cell.textLabel setText:@"Sunrise"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 5:
                [cell.textLabel setText:@"Sunset"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 6:
                [cell.textLabel setText:@"Hours of Day Light"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 7:
                [cell.textLabel setText:@"Humidity"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 8:
                [cell.textLabel setText:@"Pressure (hPA)"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 9:
                [cell.textLabel setText:@"Wind Speed (MPH)"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 10:
                [cell.textLabel setText:@"Wind Direction"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 11:
                [cell.textLabel setText:@"Cloud Coverage"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 12:
                [cell.textLabel setText:@"Rain"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 13:
                [cell.textLabel setText:@"Snow"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 14:
                [cell.textLabel setText:@"Country"];
                [cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
        [cell.detailTextLabel setText:[tableViewContents objectAtIndex:[indexPath row]]];
    }
    
    return cell;
}
-(void)tableViewContents
{
    [weatherManager fetchWeatherDataForLatitude:_pin.coordinate.latitude andLongitude:_pin.coordinate.longitude withAPIKeyOrNil:API_KEY :^(JFWeatherData *returnedWeatherData) {
        
        NSLog(@"Latitude %.3f",[returnedWeatherData latitudeCoordinateOfRequest]);
        NSLog(@"Longitude %.3f",[returnedWeatherData longitudeCoordinateOfRequest]);
        NSLog(@"Country %@",[returnedWeatherData countryCode]);
        NSLog(@"Conditions are %@",[returnedWeatherData currentConditionsTextualDescription]);
        NSLog(@"Temperature is %f",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]);
        NSLog(@"Sunrise is %@",[returnedWeatherData sunriseTime]);
        NSLog(@"Sunset is %@",[returnedWeatherData sunsetTime]);
        NSLog(@"Hours of Day Light are %@",[returnedWeatherData dayLightHours]);
        NSLog(@"Humidity is %@",[returnedWeatherData humidityPercentage]);
        NSLog(@"Pressure is %0.1f",[returnedWeatherData pressureInUnitFormat:kPressureHectopascal]);
        NSLog(@"Wind Speed is %0.1f",[returnedWeatherData windSpeedInUnitFormat:kWindSpeedMPH]);
        NSLog(@"Wind Direction is %@",[returnedWeatherData windDirectionInGeographicalDirection]);
        NSLog(@"Cloud Coverage %@",[returnedWeatherData cloudCovergePercentage]);
        NSLog(@"Rainfall Over Next 3h is %0.1fmm",[returnedWeatherData rainFallVolumeOver3HoursInMillimeters]);
        NSLog(@"SnowFall Over Next 3h is %0.1fmm",[returnedWeatherData snowFallVolumeOver3HoursInMillimeters]);
        
        [tableViewContents removeAllObjects];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.4f",[returnedWeatherData latitudeCoordinateOfRequest]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.4f",[returnedWeatherData longitudeCoordinateOfRequest]]];
        [tableViewContents addObject:[returnedWeatherData currentConditionsTextualDescription]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1f°",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]]];
        [tableViewContents addObject:[returnedWeatherData sunriseTime]];
        [tableViewContents addObject:[returnedWeatherData sunsetTime]];
        [tableViewContents addObject:[returnedWeatherData dayLightHours]];
        [tableViewContents addObject:[returnedWeatherData humidityPercentage]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1f",[returnedWeatherData pressureInUnitFormat:kPressureHectopascal]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1f",[returnedWeatherData windSpeedInUnitFormat:kWindSpeedMPH]]];
        [tableViewContents addObject:[returnedWeatherData windDirectionInGeographicalDirection]];
        [tableViewContents addObject:[returnedWeatherData cloudCovergePercentage]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1fmm",[returnedWeatherData rainFallVolumeOver3HoursInMillimeters]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%.1fmm",[returnedWeatherData snowFallVolumeOver3HoursInMillimeters]]];
        [tableViewContents addObject:[NSString stringWithFormat:@"%@",[returnedWeatherData countryCode]]];
        
        [____tableView reloadData];
        
    }];
}
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    _userLocation = newLocation;
    
    [____tableView reloadData];
}
- (IBAction)mapTypeChage:(id)sender {
    
    switch (self._mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            ____mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            ____mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            ____mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        NSString *toAddIdentifier = @"Identifier";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:toAddIdentifier];
        
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:toAddIdentifier];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}

-(void)share {
}

@end
