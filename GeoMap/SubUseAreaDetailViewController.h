//
//  SubUseAreaDetailViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 9/22/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubUseAreaDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *__tableView;

@property (strong, nonatomic) NSString *LAW_A_PEOPLE;
@property (strong, nonatomic) NSString *LAW_A_AREA;
@property (strong, nonatomic) NSString *LAW_B_PEOPLE;
@property (strong, nonatomic) NSString *LAW_B_AREA;
@property (strong, nonatomic) NSString *LAW_C_PEOPLE;
@property (strong, nonatomic) NSString *LAW_C_AREA;
@property (strong, nonatomic) NSString *LAW_D_PEOPLE;
@property (strong, nonatomic) NSString *LAW_D_AREA;
@property (strong, nonatomic) NSString *LAW_E_PEOPLE;
@property (strong, nonatomic) NSString *LAW_E_AREA;
@property (strong, nonatomic) NSString *LAW_F_PEOPLE;
@property (strong, nonatomic) NSString *LAW_F_AREA;
@property (strong, nonatomic) NSString *LAW_G_PEOPLE;
@property (strong, nonatomic) NSString *LAW_G_AREA;
@property (strong, nonatomic) NSString *LAW_H_PEOPLE;
@property (strong, nonatomic) NSString *LAW_H_AREA;

@end
