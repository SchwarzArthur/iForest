//
//  addAnnotation.h
//  GeoMap
//
//  Created by SchwarzArthur on 2/23/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"

@interface AddAnnotation : NSObject <MKAnnotation, QTreeInsertable>

//@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

//-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@property (strong, nonatomic) NSString *weather;
@property (strong, nonatomic) NSString *interModalTransfer;

#pragma mark - MKAnnotation delegate properties
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
