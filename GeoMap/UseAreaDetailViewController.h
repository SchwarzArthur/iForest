//
//  UseAreaDetailViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 9/11/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostURL @"http://schwarzarthur.bugs3.com/GeoHash/iForestJSONServe.php"

@interface UseAreaDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_sections;
    UIImage *image;
}

@property (weak, nonatomic) IBOutlet UITableView *__tableView;

@property (strong, nonatomic) NSString *AREAECHOR;
@property (strong, nonatomic) NSString *AREAGISR;
@property (strong, nonatomic) NSString *WATERSHAD;
@property (strong, nonatomic) NSString *FOREST55_56;
@property (strong, nonatomic) NSString *SURVEYAREA_PEOPLE;
@property (strong, nonatomic) NSString *SURVEYAREA_PLOT;
@property (strong, nonatomic) NSString *SURVEYAREA_AREA;
@property (strong, nonatomic) NSString *USEDAREA_PEOPLE;
@property (strong, nonatomic) NSString *USEDAREA_PLOT;
@property (strong, nonatomic) NSString *USEDAREA_AREA;
@property (strong, nonatomic) NSString *RELATEFOREST_PEOPLE;
@property (strong, nonatomic) NSString *RELATEFOREST_PLOT;
@property (strong, nonatomic) NSString *RELATEFOREST_AREA;
@property (strong, nonatomic) NSString *PERMANENTFOREST;
@property (strong, nonatomic) NSString *CRIME_PEOPLE;
@property (strong, nonatomic) NSString *CRIME_AREA;
@property (strong, nonatomic) NSString *COMMUNITYFOREST_PROJECT;
@property (strong, nonatomic) NSString *COMMUNITYFOREST_AREA;
@property (strong, nonatomic) NSString *INTERSECDNP;
@property (strong, nonatomic) NSString *INTERSECWLS;
@property (strong, nonatomic) NSString *INTERSECNHA;
@property (strong, nonatomic) NSString *INTERSECFP;
@property (strong, nonatomic) NSString *ALR_PEOPLE;
@property (strong, nonatomic) NSString *ALR_PLOT;
@property (strong, nonatomic) NSString *ALR_AREA;
@property (strong, nonatomic) NSString *ALR_FOREST55_56;
@property (strong, nonatomic) NSString *SELFCOLONY_PEOPLE;
@property (strong, nonatomic) NSString *SELFCOLONY_PLOT;
@property (strong, nonatomic) NSString *SELFCOLONY_AREA;
@property (strong, nonatomic) NSString *COOPERATIVECOLONY_PEOPLE;
@property (strong, nonatomic) NSString *COOPERATIVECOLONY_PLOT;
@property (strong, nonatomic) NSString *COOPERATIVECOLONY_AREA;
@property (strong, nonatomic) NSString *USED_STK_PEOPLE;
@property (strong, nonatomic) NSString *USED_STK_PLOT;
@property (strong, nonatomic) NSString *USED_STK_AREA;


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

@property (strong, nonatomic) NSString *SurveyArea;
@property (strong, nonatomic) NSString *UsedArea;
@property (strong, nonatomic) NSString *RelateForest;
@property (strong, nonatomic) NSString *Crime;
@property (strong, nonatomic) NSString *CommunityForest;
@property (strong, nonatomic) NSString *ALR;
@property (strong, nonatomic) NSString *SelfColony;
@property (strong, nonatomic) NSString *CooperativeColony;
@property (strong, nonatomic) NSString *Used_STK;

@end
