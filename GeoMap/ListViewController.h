//
//  ListViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ListViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CLLocationCoordinate2D setRegionList;

@property (strong, nonatomic) NSMutableArray *areas;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *_searchBar;
@property (strong, nonatomic) NSMutableArray* _filteredTableData;

@property (assign, nonatomic) bool _isFiltered;

@end
