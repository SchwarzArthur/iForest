//
//  ZoningDetailViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 9/22/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoningDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *__tableView;

@property (strong, nonatomic) NSString *ZONEC;
@property (strong, nonatomic) NSString *ZONEE;
@property (strong, nonatomic) NSString *ZONEA;

@end
