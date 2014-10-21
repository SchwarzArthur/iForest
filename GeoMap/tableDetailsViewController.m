//
//  tableDetailsViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/16/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "tableDetailsViewController.h"

static NSString *API_KEY = @"YOUR_API_KEY_HERE";

@interface tableDetailsViewController ()

@end

@implementation tableDetailsViewController

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
    
	tableViewContents = [[NSMutableArray alloc]initWithCapacity:15];
    
    for (int i=0; i<15; i++) {
        [tableViewContents addObject:@"Loading"];
    }
    
    weatherManager = [[JFWeatherManager alloc]init];
    [self tableViewContents];
    
    
    [self setNeedsStatusBarAppearanceUpdate];

}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Attributes";
    else
        return  @"Weather Attributes";
    
    //  return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 10;
    else
        return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Name"];
                [cell.detailTextLabel setText:self.area.title];
                break;
                
            case 1:
                [cell.textLabel setText:@"Type"];
                [cell.detailTextLabel setText:self.area.interModalTransfer];
                break;
                
            case 2:
                [cell.textLabel setText:@"A"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 3:
                [cell.textLabel setText:@"B"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 4:
                [cell.textLabel setText:@"C"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 5:
                [cell.textLabel setText:@"D"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 6:
                [cell.textLabel setText:@"E"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 7:
                [cell.textLabel setText:@"F"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 8:
                [cell.textLabel setText:@"G"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
            case 9:
                [cell.textLabel setText:@"H"];
                [cell.detailTextLabel setText:@"?"];
                break;
                
        }
    } else if (indexPath.section == 1) {
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Center Area Latitude"];
                break;
                
            case 1:
                [cell.textLabel setText:@"Center Area Longitude"];
                break;
                
            case 2:
                [cell.textLabel setText:@"Conditions"];
                break;
                
            case 3:
                [cell.textLabel setText:@"Temperature (°C)"];
                break;
                
            case 4:
                [cell.textLabel setText:@"Sunrise"];
                break;
                
            case 5:
                [cell.textLabel setText:@"Sunset"];
                break;
                
            case 6:
                [cell.textLabel setText:@"Hours of Day Light"];
                break;
                
            case 7:
                [cell.textLabel setText:@"Humidity"];
                break;
                
            case 8:
                [cell.textLabel setText:@"Pressure (hPA)"];
                break;
                
            case 9:
                [cell.textLabel setText:@"Wind Speed (MPH)"];
                break;
                
            case 10:
                [cell.textLabel setText:@"Wind Direction"];
                break;
                
            case 11:
                [cell.textLabel setText:@"Cloud Coverage"];
                break;
                
            case 12:
                [cell.textLabel setText:@"Rain"];
                break;
                
            case 13:
                [cell.textLabel setText:@"Snow"];
                break;
                
            case 14:
                [cell.textLabel setText:@"Country"];
                break;
        }
        [cell.detailTextLabel setText:[tableViewContents objectAtIndex:[indexPath row]]];
    }
    
    return cell;
}
-(void)tableViewContents
{
    [weatherManager fetchWeatherDataForLatitude:_area.coordinate.latitude andLongitude:_area.coordinate.longitude withAPIKeyOrNil:API_KEY :^(JFWeatherData *returnedWeatherData) {
        
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
        
        [___tableView reloadData];
        
    }];
}

- (UIScrollView *)scrollViewForParallexController{
    return self.__tableView;
}

@end
