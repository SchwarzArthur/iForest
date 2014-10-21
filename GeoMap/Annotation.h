//
//  Annotation.h
//  GeoMap
//
//  Created by SchwarzArthur on 12/10/2556 BE.
//  Copyright (c) 2556 SchwarzArthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"

@interface Annotation : NSObject <MKAnnotation, QTreeInsertable>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *nameThai;
@property (nonatomic, copy) NSString *nameEng;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *polygon;
@property (nonatomic, copy) NSArray *multiPolygon;

@end


