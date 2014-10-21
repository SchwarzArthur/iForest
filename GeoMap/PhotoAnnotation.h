//
//  PhotoAnnotation.h
//  GeoMap
//
//  Created by SchwarzArthur on 9/13/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PhotoAnnotation : NSObject < MKAnnotation >

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *useType;
@property (nonatomic, copy) NSString *namePhoto;
@property (nonatomic, copy) NSString *NRFCode;
@property (nonatomic, copy) NSString *NRFProvince;
@property (nonatomic, copy) NSString *NRFName;
@property (nonatomic, copy) NSString *URLPhoto;

@end
