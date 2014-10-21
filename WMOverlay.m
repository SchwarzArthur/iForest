//
//  WMOverlay.m
//  WorldMap
//
//  Created by kishikawa katsumi on 2012/09/26.
//  Copyright (c) 2012 kishikawa katsumi. All rights reserved.
//

#import "WMOverlay.h"

@implementation WMOverlay

- (id)initWithMapType:(MKMapType)mapType
{
    if (self = [super init]) {
        _mapType = mapType;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(MKMapRectWorld), MKMapRectGetMidY(MKMapRectWorld)));
}

- (MKMapRect)boundingMapRect {
    return MKMapRectWorld;
}

- (NSURL *)imageURLWithTilePath:(NSString *)path {
    u_int32_t random = arc4random_uniform(2);
    NSString *s = nil;
    switch (_mapType) {
        case MKMapTypeStandard:
            s = [NSString stringWithFormat:@"http://mt%d.google.com/vt/%@", random, path];
            break;
            
        case MKMapTypeSatellite:
            //s = [NSString stringWithFormat:@"http://khm%d.google.com/kh/v=58&%@", random, path];//@"http://khm%d.google.com/kh/v=117&%@"
            s = [NSString stringWithFormat:@"http://rfdgeoinfo.servebeer.com/geoserver/ortho/wms?service=WMS&version=1.1.0&request=GetMap&layers=ortho:f4010_wws&styles=&bbox=104.0809166471348,16.45962410965946,104.26929075842386,16.67730165557326&width=443&height=512&srs=EPSG:4326&format=application/openlayers"];
            break;
            
        case MKMapTypeHybrid:
            s = [NSString stringWithFormat:@"http://mt%d.google.com/vt/lyrs=y&%@", random, path];
            break;
            
        default:
            break;
    }
    
    return [NSURL URLWithString:s];
}

@end
