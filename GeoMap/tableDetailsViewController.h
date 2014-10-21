//
//  tableDetailsViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/16/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"
#import "Annotation.h"

@interface tableDetailsViewController : UIViewController<QMBParallaxScrollViewHolder, UITableViewDataSource, UITableViewDelegate>
{
    JFWeatherManager *weatherManager;
    NSMutableArray *tableViewContents;
}

@property (strong, nonatomic) Annotation *area;

@property (nonatomic, strong) IBOutlet UITableView *__tableView;
@property (nonatomic, strong) IBOutlet UIScrollView *_scrollView;

@end
