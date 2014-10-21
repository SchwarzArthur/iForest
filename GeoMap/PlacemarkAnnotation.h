//
//  PlacemarkAnnotation.h
//  GeoMap
//
//  Created by SchwarzArthur on 4/13/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"

@interface PlacemarkAnnotation : MKPlacemark <MKAnnotation, QTreeInsertable, NSObject>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite, copy) NSDictionary *addressDictionary;

@end
