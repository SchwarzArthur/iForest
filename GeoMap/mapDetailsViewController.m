//
//  mapDetailsViewController.m
//  GeoMap
//
//  Created by SchwarzArthur on 12/16/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import "mapDetailsViewController.h"

@interface mapDetailsViewController ()

@end

@implementation mapDetailsViewController

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
    
    [self._mapView setShowsUserLocation:NO];
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance ( self.area.coordinate, 25000, 25000 );
    [self._mapView setRegion:region animated:NO];
    
    MKPointAnnotation *centerPinMap = [[MKPointAnnotation alloc]init];
    centerPinMap.coordinate = self.area.coordinate;
    centerPinMap.title = [NSString stringWithFormat:@"%@",self.area.title];
    [self._mapView addAnnotation:centerPinMap];
    
    NSArray * pole  = [self.area.polygon componentsSeparatedByString:@";"];
    
    CLLocationCoordinate2D *coords = malloc([pole count] * sizeof(CLLocationCoordinate2D));
    
    for(int i = 0; i < [pole count]; i++)
    {
        
        NSString *  coordinates2 = [pole objectAtIndex:i];
        
        coords[i] = CLLocationCoordinate2DMake ([[[coordinates2 componentsSeparatedByString:@","] objectAtIndex:1] doubleValue],[[[coordinates2 componentsSeparatedByString:@","] objectAtIndex:0] doubleValue]);
    }
    
    MKPolygon* polygon = [MKPolygon polygonWithCoordinates:coords count:[pole count]];
    free(coords);
    
    [self._mapView addOverlay:polygon];
    
     [self setNeedsStatusBarAppearanceUpdate];
	
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
    polygonRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];//[UIColor blackColor];
    polygonRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];//[[UIColor alloc] initWithRed:0.0 green:1.0 blue:5.0 alpha:0.5];//[UIColor redColor];
    polygonRenderer.lineWidth = 0.5f;
    
    
    return polygonRenderer;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
