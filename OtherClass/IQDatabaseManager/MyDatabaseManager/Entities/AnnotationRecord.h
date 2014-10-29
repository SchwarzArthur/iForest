//
//  AnnotationRecord.h
//  GeoMap
//
//  Created by SchwarzArthur on 3/24/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"
#import "RecordTables.h"

@interface AnnotationRecord : NSObject <MKAnnotation, QTreeInsertable>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * coordinate_x;
@property (nonatomic, retain) NSString * coordinate_y;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
