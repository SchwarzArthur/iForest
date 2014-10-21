//
//  StepRouteViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 4/14/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import MapKit;

@interface StepRouteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MKRoute *route;


@end
