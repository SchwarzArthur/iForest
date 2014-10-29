//
//  AboutViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 4/20/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWParallaxScrollView.h"

@interface AboutViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *___tableView;

@end
