//
//  NotQTree.h
//  GeoMap
//
//  Created by SchwarzArthur on 3/23/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "QTreeInsertable.h"

@interface NotQTree : NSObject

-(void)insertObject:(id<QTreeInsertable>)insertableObject;

@property(nonatomic, readonly) NSUInteger count;

-(NSArray*)getObjectsInRegion:(MKCoordinateRegion)region minNonClusteredSpan:(CLLocationDegrees)span;
// Returned array is sorted from the least to the most distant
-(NSArray*)neighboursForLocation:(CLLocationCoordinate2D)location limitCount:(NSUInteger)limit;

@end
