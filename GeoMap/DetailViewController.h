//
//  DetailViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "PhotoAnnotation.h"

#define kPostURL @"http://schwarzarthur.bugs3.com/GeoHash/iForestJSONServe.php"

#define kPostPhotoURL @"http://schwarzarthur.bugs3.com/GeoHash/iForestJSONServePhoto.php"

#define kPDFURL @"http://pirun.ku.ac.th/~b521030091/PDF/NRF"

@interface DetailViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_sections;
    UIImage *image;
}

@property (strong, nonatomic) Annotation *area;
@property (weak, nonatomic) IBOutlet UITableView *__tableView;
@property (weak, nonatomic) IBOutlet MKMapView *__mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

@property (nonatomic, strong) IBOutlet UIView *div;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *PDF;


@property (strong, nonatomic) NSString *NAMET;
@property (strong, nonatomic) NSString *NAMEE;
@property (strong, nonatomic) NSString *PROVINCE;
@property (strong, nonatomic) NSString *CODE;
@property (strong, nonatomic) NSString *DEFENCEUNIT;
@property (strong, nonatomic) NSString *OFFICE;

@property (strong, nonatomic) NSString *ECHODATE_I;
@property (strong, nonatomic) NSString *ECHODATE_II;
@property (strong, nonatomic) NSString *ECHODATE_III;
@property (strong, nonatomic) NSString *ECHODATE_IV;
@property (strong, nonatomic) NSString *ECHODATE_V;
@property (strong, nonatomic) NSString *PDFURL_I;
@property (strong, nonatomic) NSString *PDFURL_II;
@property (strong, nonatomic) NSString *PDFURL_III;
@property (strong, nonatomic) NSString *PDFURL_IV;
@property (strong, nonatomic) NSString *PDFURL_V;

@property (strong, nonatomic) NSString *ECHOORDINAL;
@property (strong, nonatomic) NSString *ECHODATE;
@property (strong, nonatomic) NSString *PDFLastedURL;

@property (strong, nonatomic) NSString *NRFPAR;
@property (strong, nonatomic) NSString *LOGICECHO;

@property (strong, nonatomic) NSString *AREAECHOR;
@property (strong, nonatomic) NSString *AREAGISR;

@property (strong, nonatomic) NSString *SURVEYBOOK;
@property (strong, nonatomic) NSString *NRFDOCUMENT;

@property (strong, nonatomic) NSString *DATEUPDATE;

@property (strong, nonatomic) NSString *GEOHASH;
@property (strong, nonatomic) NSString *LATITUDE;
@property (strong, nonatomic) NSString *LONGITUDE;
@property (strong, nonatomic) NSString *MLS;

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

@property (strong, nonatomic) NSString *ZONEC;
@property (strong, nonatomic) NSString *ZONEE;
@property (strong, nonatomic) NSString *ZONEA;

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


@property (strong, nonatomic) PhotoAnnotation *photoObject;

@end
