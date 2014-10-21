//
//  AddAnnotationView.h
//  GeoMap
//
//  Created by SchwarzArthur on 2/28/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

@import MapKit;
@class AddAnnotation;

@interface AddAnnotationView : MKPinAnnotationView

+(NSString*)reuseIdPin;

@property(nonatomic, strong) AddAnnotation* addPin;
@end
