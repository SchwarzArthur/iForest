//
//  CurlViewController.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/11/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WMOverlay.h"

typedef enum {
    MAPSOURCEAPPLE,
    MAPSOURCEGOOGLE
    
}MAP_TYPE;

@protocol CurlViewControllerDelegate;

@interface CurlViewController : UIViewController

@property (strong, nonatomic) id<CurlViewControllerDelegate> delegate;


@property (assign, nonatomic) MKMapType mapType;

@property (assign, nonatomic) WMMapSource mapSource;
@property (nonatomic, strong) IBOutlet UILabel *strandardMap;
@property (nonatomic, strong) IBOutlet UILabel *googleMap;

@property (assign, nonatomic) BOOL useClustering;

@property (strong, nonatomic) IBOutlet UISwitch *onOffCluster;

@end

@protocol CurlViewControllerDelegate <NSObject>

- (void)curlViewController:(CurlViewController *)controller mapSourceChanged:(WMMapSource)mapSource;

- (void)curlViewController:(CurlViewController *)controller mapTypeChanged:(MKMapType)mapType;

- (void)curlViewControllerWillClusterPin:(CurlViewController *)controller didCluster:(BOOL)onOffClusterPin;

@end
