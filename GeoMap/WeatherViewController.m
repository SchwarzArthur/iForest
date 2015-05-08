//
//  WeatherViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 9/21/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "WeatherViewController.h"
#import "GeodeticUTMConverter.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

static NSString *API_KEY = @"YOUR_API_KEY_HERE";

@interface WeatherViewController ()

@end

@implementation WeatherViewController {

    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"ข้อมูลอื่นๆ";
    
   /* //User location tracking
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];*/
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    _userLocation = [_locationManager.location copy];
    NSLog(@"%f %f User location", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    
    geocoder = [[CLGeocoder alloc] init];
    
    _location = [[CLLocation alloc] initWithLatitude:[_weatherLATITUDE doubleValue] longitude:[_weatherLONGITUDE doubleValue]];
    
    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            UILabel *subThoroughfare = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 0, 0)];
            if (placemark.subThoroughfare == nil) {
                subThoroughfare.text = nil;
            } else {
                subThoroughfare.text = [NSString stringWithFormat:@"%@",
                                        placemark.subThoroughfare];
            }
            subThoroughfare.font = [UIFont fontWithName:@"Avenir Next" size:13];
            subThoroughfare.backgroundColor = [UIColor clearColor];
            subThoroughfare.textColor = [UIColor blackColor];
            [subThoroughfare sizeToFit];
            [____tableView addSubview:subThoroughfare];
            
            UILabel *thoroughfare = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, 0, 0)];
            if (placemark.thoroughfare == nil) {
                thoroughfare.text = nil;
            } else {
                thoroughfare.text = [NSString stringWithFormat:@"%@",
                                     placemark.thoroughfare];
            }
            thoroughfare.font = [UIFont fontWithName:@"Avenir Next" size:13];
            thoroughfare.backgroundColor = [UIColor clearColor];
            thoroughfare.textColor = [UIColor blackColor];
            [thoroughfare sizeToFit];
            [____tableView addSubview:thoroughfare];
            
            UILabel *locality = [[UILabel alloc] initWithFrame:CGRectMake(60, 90, 0, 0)];
            if (placemark.locality == nil) {
                locality.text = nil;
            } else {
                locality.text = [NSString stringWithFormat:@"%@",
                                 placemark.locality];
            }
            locality.font = [UIFont fontWithName:@"Avenir Next" size:13];
            locality.backgroundColor = [UIColor clearColor];
            locality.textColor = [UIColor blackColor];
            [locality sizeToFit];
            [____tableView addSubview:locality];
            
            UILabel *administrativeArea = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 0, 0)];
            if (placemark.administrativeArea == nil) {
                administrativeArea.text = nil;
            } else {
                administrativeArea.text = [NSString stringWithFormat:@"%@",
                                           placemark.administrativeArea];
            }
            administrativeArea.font = [UIFont fontWithName:@"Avenir Next" size:12];
            administrativeArea.backgroundColor = [UIColor clearColor];
            administrativeArea.textColor = [UIColor blackColor];
            [administrativeArea sizeToFit];
            [____tableView addSubview:administrativeArea];
            
            UILabel *country = [[UILabel alloc] initWithFrame:CGRectMake(60, 130, 0, 0)];
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
            country.font = [UIFont fontWithName:@"Avenir Next" size:13];
            country.backgroundColor = [UIColor clearColor];
            country.textColor = [UIColor blackColor];
            [country sizeToFit];
            [____tableView addSubview:country];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    tableViewContents = [[NSMutableArray alloc]initWithCapacity:15];
    
    for (int i=0; i<15; i++) {
        [tableViewContents addObject:@"Loading"];
    }
    
    weatherManager = [[JFWeatherManager alloc]init];

    [self allow];
    //[self tableViewContents];
}

-(void)allow
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Allow ''iForest TH'' to access your location data?"
                                                      message:@"Your location data is used to show local weather in the ''iForest TH'' app"
                                                     delegate:self
                                            cancelButtonTitle:@"Don't Allow"
                                            otherButtonTitles:@"Allow", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Allow"]) {
        [self tableViewContents];
        NSLog(@"allow Weather");
    }
    else if([title isEqualToString:@"Don't Allow"]) {
        NSLog(@"Cancel was selected.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && indexPath.section == 0) {
        return 115;
    } else {
        return 45;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //  if (section == 0)
    //      return @"Attributes";
    //  else
    //      return  @"Weather Attributes";
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 7;
    else if (section == 1)
        return 15;
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
 
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_weatherLATITUDE doubleValue] longitude:[_weatherLONGITUDE doubleValue]];
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [_weatherLATITUDE doubleValue];
    coordinates.longitude = [_weatherLONGITUDE doubleValue];
    
    GeodeticUTMConverter *utmConverter = [[GeodeticUTMConverter alloc] init];
    UTMCoordinates utmCoordinates = [utmConverter latitudeAndLongitudeToUTMCoordinates:coordinates];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
            
            case 0:
            {
                [cell.textLabel setText:@"ระยะทางขจัดถึงจุดกึ่งกลางพื้นที่ :"];//≃
                
                CLLocationDistance distance = [_userLocation distanceFromLocation:location];
                
                if (distance == 0) {
                    
                } else {
                    
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f Km.", distance/1000]];
                    
                }
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
            }
            case 1:
                
                [cell.textLabel setText:@"ที่ตั้ง :"];
                [cell.detailTextLabel setText:nil];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 2:
                
                if ([_weatherMLS isEqualToString:@"(null)"] || [_weatherMLS isEqualToString:@"-"] || [_weatherMLS isEqualToString:@""] || [_weatherMLS isEqualToString:nil]){
                    
                    _weatherMLS = [NSString stringWithFormat:@"( รอการเพิ่มเติมข้อมูล )"];
                } else {
                    
                }
                [cell.textLabel setText:@"ความสูงระดับนํ้าทะเล (MLS)"];
                [cell.detailTextLabel setText:_weatherMLS];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 3:
                [cell.textLabel setText:@"GeoHash"];
                [cell.detailTextLabel setText:_weatherGEOHASH];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 4:
                [cell.textLabel setText:@"X Coordinate of Centroid [UTM]"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",utmCoordinates.easting]];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 5:
                [cell.textLabel setText:@"Y Coordinate of Centroid [UTM]"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.1f",utmCoordinates.northing]];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 6:
                [cell.textLabel setText:@"Zone"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%u",utmCoordinates.gridZone]];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        
        }
        
    } else if (indexPath.section == 1) {
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Latitude of Centroid"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:4.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 1:
                [cell.textLabel setText:@"Longitude of Centroid"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:4.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 2:
                [cell.textLabel setText:@"Conditions"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 3:
                [cell.textLabel setText:@"Temperature (°C)"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 4:
                [cell.textLabel setText:@"Sunrise"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 5:
                [cell.textLabel setText:@"Sunset"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 6:
                [cell.textLabel setText:@"Hours of Day Light"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 7:
                [cell.textLabel setText:@"Humidity"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 8:
                [cell.textLabel setText:@"Pressure (hPA)"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 9:
                [cell.textLabel setText:@"Wind Speed (MPH)"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 10:
                [cell.textLabel setText:@"Wind Direction"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 11:
                [cell.textLabel setText:@"Cloud Coverage"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 12:
                [cell.textLabel setText:@"Rain"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 13:
                [cell.textLabel setText:@"Snow"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
                
            case 14:
                [cell.textLabel setText:@"Country"];
                //[cell.textLabel setTextColor:[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1.0f]];
                //cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                cell.backgroundColor = [UIColor whiteColor];
                break;
        }
        [cell.detailTextLabel setText:[tableViewContents objectAtIndex:[indexPath row]]];
    }
    
    return cell;
}
-(void)tableViewContents
{
    [weatherManager fetchWeatherDataForLatitude:[_weatherLATITUDE doubleValue] andLongitude:[_weatherLONGITUDE doubleValue] withAPIKeyOrNil:API_KEY :^(JFWeatherData *returnedWeatherData) {
        
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
@end
