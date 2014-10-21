//
//  OtherLayerAnnotation.h
//  GeoMap
//
//  Created by SchwarzArthur on 10/5/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"

@interface OtherLayerAnnotation : NSObject <MKAnnotation, QTreeInsertable>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *nameThai;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *polygon;
@property (nonatomic, copy) NSArray *multiPolygon;

@end
