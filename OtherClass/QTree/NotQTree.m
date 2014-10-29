//
//  NotQTree.m
//  GeoMap
//
//  Created by SchwarzArthur on 3/23/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "NotQTree.h"
#import "QNode.h"

@interface NotQTree()

@property(nonatomic, strong) QNode* rootNode;

@end

@implementation NotQTree

-(id)init
{
	self = [super init];
	if( !self ) {
        return nil;
    }
	self.rootNode = [[QNode alloc] initWithRegion:MKCoordinateRegionForMapRect(MKMapRectWorld)];
	return self;
}

-(void)insertObject:(id<QTreeInsertable>)insertableObject
{
    [self.rootNode insertObject:insertableObject];
}

-(NSUInteger)count
{
    return self.rootNode.count;
}

-(NSArray*)getObjectsInRegion:(MKCoordinateRegion)region minNonClusteredSpan:(CLLocationDegrees)span
{
	return [self.rootNode getObjectsInRegion:region minNonClusteredSpan:span];
}

-(NSArray*)neighboursForLocation:(CLLocationCoordinate2D)location limitCount:(NSUInteger)limit
{
	return [self.rootNode neighboursForLocation:location limitCount:limit];
}

@end
