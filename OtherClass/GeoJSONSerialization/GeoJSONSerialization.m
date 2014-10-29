// GeoJSONSerialization.m
// 
// Copyright (c) 2014 Mattt Thompson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GeoJSONSerialization.h"
#import "GeodeticUTMConverter.h"// converter
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#pragma mark - Geometry Primitives

NSString * const GeoJSONSerializationErrorDomain = @"com.geojson.serialization.error";

/*static inline double CLLocationCoordinateNormalizedLatitude(double latitude) {
    return fmod((latitude + 90.0f), 180.0f) - 90.0f;
}

static inline double CLLocationCoordinateNormalizedLongitude(double latitude) {
    return fmod((latitude + 180.0f), 360.0f) - 180.0f;
}*/

static inline CLLocationCoordinate2D CLLocationCoordinateFromCoordinates(NSArray *coordinates) {
    NSCParameterAssert(coordinates && [coordinates count] == 2);

/*    NSNumber *longitude = [coordinates objectAtIndex:0];//[coordinates firstObject];
    NSNumber *latitude = [coordinates objectAtIndex:1];

    return CLLocationCoordinate2DMake(CLLocationCoordinateNormalizedLatitude([latitude doubleValue]), CLLocationCoordinateNormalizedLongitude([longitude doubleValue]));
 // return CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);
}*/
    NSNumber *longitude = [coordinates objectAtIndex:0];//[coordinates firstObject];
    NSNumber *latitude = [coordinates objectAtIndex:1];
    
    UTMCoordinates originalCoord;
    originalCoord.gridZone = 47;
    originalCoord.northing = [latitude doubleValue];
    originalCoord.easting = [longitude doubleValue];
    originalCoord.hemisphere = kUTMHemisphereNorthern;
    
    GeodeticUTMConverter *converter = [[GeodeticUTMConverter alloc] init];
    CLLocationCoordinate2D convertCoordinate = [converter UTMCoordinatesToLatitudeAndLongitude:originalCoord];

    return CLLocationCoordinate2DMake(convertCoordinate.latitude, convertCoordinate.longitude);
 }

static inline CLLocationCoordinate2D * CLLocationCoordinatesFromCoordinatePairs(NSArray *coordinatePairs) {
    NSUInteger count = [coordinatePairs count];
    CLLocationCoordinate2D *locationCoordinates = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * count);
    for (NSUInteger idx = 0; idx < count; idx++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinateFromCoordinates(coordinatePairs[idx]);
        locationCoordinates[idx] = coordinate;
    }

    return locationCoordinates;
}

static MKPointAnnotation * MKPointAnnotationFromGeoJSONPointFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];

    NSCParameterAssert([geometry[@"type"] isEqualToString:@"Point"]);

    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinateFromCoordinates(geometry[@"coordinates"]);

    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    pointAnnotation.title = properties[@"title"];
    pointAnnotation.subtitle = properties[@"subtitle"];

    return pointAnnotation;
}

static MKPolyline * MKPolylineFromGeoJSONLineStringFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];

    NSCParameterAssert([geometry[@"type"] isEqualToString:@"LineString"]);

    NSArray *coordinatePairs = geometry[@"coordinates"];
    CLLocationCoordinate2D *polylineCoordinates = CLLocationCoordinatesFromCoordinatePairs(coordinatePairs);
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:polylineCoordinates count:[coordinatePairs count]];

    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    polyLine.title = properties[@"title"];
    polyLine.subtitle = properties[@"subtitle"];

    return polyLine;
}

static MKPolygon * MKPolygonFromGeoJSONPolygonFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:geometry
                                                       options:0 error:nil];//edit by me
    NSString* nsJson =  [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];//edit by me

    NSCParameterAssert([geometry[@"type"] isEqualToString:@"Polygon"]);

    NSArray *coordinateSets = geometry[@"coordinates"];

    NSMutableArray *mutablePolygons = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
    for (NSArray *coordinatePairs in coordinateSets) {
        CLLocationCoordinate2D *polygonCoordinates = CLLocationCoordinatesFromCoordinatePairs(coordinatePairs);
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:[coordinatePairs count]];
        [mutablePolygons addObject:polygon];
      //   NSLog(@"mutablePolygons = %@",polygon);
    }

    MKPolygon *polygon = nil;
    switch ([mutablePolygons count]) {
        case 0:
            return nil;
           //  NSLog(@"case 0");
        case 1:
            polygon = [mutablePolygons firstObject];
           //  NSLog(@"case 1 = %@",polygon);
            break;
        default: {
            MKPolygon *exteriorPolygon = [mutablePolygons firstObject];
            NSArray *interiorPolygons = [mutablePolygons subarrayWithRange:NSMakeRange(1, [mutablePolygons count] - 1)];
            polygon = [MKPolygon polygonWithPoints:exteriorPolygon.points count:exteriorPolygon.pointCount interiorPolygons:interiorPolygons];
            // NSLog(@"default = %@",polygon);
        }
            break;
    }

    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
 
    polygon.title = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",
                     properties[@"TYPE"],         //0
                     properties[@"NRF_NAME_T"],   //1
                     properties[@"NRF_NAME_E"],   //2
                     properties[@"NRF_PROVIN"],   //3
                     properties[@"LATITUDE"],     //4
                     properties[@"LONGITUDE"],    //5
                     properties[@"NRF_CODE"]      //6
];

    polygon.subtitle = nsJson;

    return polygon;
}

static NSString * NSStringFromGeoJSONPolygonFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:geometry
                                                       options:0 error:nil];//edit by me
    NSString* nsJson =  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];//edit by me    
    return nsJson;
}

/*static Annotation * AnnotationFromGeoJSONPointFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:geometry
                                                       options:0 error:nil];//edit by me
    NSString* nsJson =  [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];//edit by me
    
   // NSDictionary *subFeature = [NSDictionary dictionaryWithDictionary:geometry[@"geometry"]];
    
  
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:geometry[@"properties"]];
    
    Annotation *annotation = [[Annotation alloc] init];
    
    annotation.title = properties[@"NRF_NAME_T"];
    annotation.subtitle = properties[@"NRF_PROVIN"];
    annotation.polygons = @[@"province"];
    annotation.polygon = nsJson;
    
  
    
    annotation.coordinate = CLLocationCoordinate2DMake([properties[@"Latitude"] doubleValue], [properties[@"Longitude"] doubleValue]);
    
    return annotation;
}*/



#pragma mark - Multipart Geometries

static NSArray * MKPointAnnotationsFromGeoJSONMultiPointFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];

    NSCParameterAssert([geometry[@"type"] isEqualToString:@"MultiPoint"]);

    NSArray *coordinatePairs = geometry[@"coordinates"];
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];

    NSMutableArray *mutablePointAnnotations = [NSMutableArray arrayWithCapacity:[coordinatePairs count]];
    for (NSArray *coordinates in coordinatePairs) {
        NSDictionary *subFeature = @{
                                     @"type": @"Feature",
                                     @"geometry": @{
                                             @"type": @"Point",
                                             @"coordinates": coordinates
                                             },
                                     @"properties": properties
                                     };

        [mutablePointAnnotations addObject:MKPointAnnotationFromGeoJSONPointFeature(subFeature)];
    }

    return [NSArray arrayWithArray:mutablePointAnnotations];
}

static NSArray * MKPolylinesFromGeoJSONMultiLineStringFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];

    NSCParameterAssert([geometry[@"type"] isEqualToString:@"MultiLineString"]);

    NSArray *coordinateSets = geometry[@"coordinates"];
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];

    NSMutableArray *mutablePolylines = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
    for (NSArray *coordinatePairs in coordinateSets) {
        NSDictionary *subFeature = @{
                                     @"type": @"Feature",
                                     @"geometry": @{
                                             @"type": @"LineString",
                                             @"coordinates": coordinatePairs
                                             },
                                     @"properties": properties
                                     };

        [mutablePolylines addObject:MKPolylineFromGeoJSONLineStringFeature(subFeature)];
    }

    return [NSArray arrayWithArray:mutablePolylines];
}

static NSArray * MKPolygonsFromGeoJSONMultiPolygonFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];
    
    NSCParameterAssert([geometry[@"type"] isEqualToString:@"MultiPolygon"]);
    
    NSArray *coordinateGroups = geometry[@"coordinates"];
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    
    NSMutableArray *mutablePolylines = [NSMutableArray arrayWithCapacity:[coordinateGroups count]];
    for (NSArray *coordinateSets in coordinateGroups) {
        NSDictionary *subFeature = @{
                                     @"type": @"Feature",
                                     @"geometry": @{
                                             @"type": @"Polygon",
                                             @"coordinates": coordinateSets
                                             },
                                     @"properties": properties
                                     };
        
        [mutablePolylines addObject:NSStringFromGeoJSONPolygonFeature(subFeature)];
      //  [mutablePolylines addObject:AnnotationFromGeoJSONPointFeature(subFeature)];
    }
    
    return [NSArray arrayWithArray:mutablePolylines];
}


static Annotation * AnnotationFromMultiPolygonFeature(NSDictionary *feature) {
    
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    
    Annotation *annotation = [[Annotation alloc] init];
    
    annotation.title = [NSString stringWithFormat:@"%@", properties[@"NRF_NAME_T"]];
    annotation.subtitle = [NSString stringWithFormat: @"%@ / %@ / จ.%@", properties[@"NRF_CODE"] ,properties[@"TYPE"], properties[@"NRF_PROVIN"]];
    
    annotation.nameThai = [NSString stringWithFormat:@"%@", properties[@"NRF_NAME_T"]];
    annotation.province = [NSString stringWithFormat:@"%@", properties[@"NRF_PROVIN"]];
    annotation.code = [NSString stringWithFormat:@"%@", properties[@"NRF_CODE"]];
    annotation.nameEng = [NSString stringWithFormat:@"%@", properties[@"NRF_NAME_E"]];
    annotation.type = [NSString stringWithFormat:@"%@",properties[@"TYPE"]];

    annotation.multiPolygon = MKPolygonsFromGeoJSONMultiPolygonFeature(feature);

    annotation.coordinate = CLLocationCoordinate2DMake([properties[@"LATITUDE"] doubleValue], [properties[@"LONGITUDE"] doubleValue]);
    
    return annotation;
}

#pragma mark -

static id MKShapeFromGeoJSONFeature(NSDictionary *feature) {
    NSCParameterAssert([feature[@"type"] isEqualToString:@"Feature"]);

    NSDictionary *geometry = feature[@"geometry"];
    NSString *type = geometry[@"type"];
    if ([type isEqualToString:@"Point"]) {
        return MKPointAnnotationFromGeoJSONPointFeature(feature);
    } else if ([type isEqualToString:@"LineString"]) {
        return MKPolylineFromGeoJSONLineStringFeature(feature);
    } else if ([type isEqualToString:@"Polygon"]) {
        return MKPolygonFromGeoJSONPolygonFeature(feature);
    } else if ([type isEqualToString:@"MultiPoint"]) {
        return MKPointAnnotationsFromGeoJSONMultiPointFeature(feature);
    } else if ([type isEqualToString:@"MultiLineString"]) {
        return MKPolylinesFromGeoJSONMultiLineStringFeature(feature);
    } else if ([type isEqualToString:@"MultiPolygon"]) {
        //return MKPolygonsFromGeoJSONMultiPolygonFeature(feature);
        return AnnotationFromMultiPolygonFeature(feature);
    }

    return nil;
}

static NSArray * MKShapesFromGeoJSONFeatureCollection(NSDictionary *featureCollection) {
    NSCParameterAssert([featureCollection[@"type"] isEqualToString:@"FeatureCollection"]);

    NSMutableArray *mutableShapes = [NSMutableArray array];
    for (NSDictionary *feature in featureCollection[@"features"]) {
        id shape = MKShapeFromGeoJSONFeature(feature);
        if (shape) {
            [mutableShapes addObject:shape];
        }
    }
    
    return [NSArray arrayWithArray:mutableShapes];
}

#pragma mark -

static inline NSDictionary * GeoJSONPropertiesForShape(MKShape *shape) {
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionary];
    if (shape.title) {
        mutableProperties[@"title"] = shape.title;
    }

    if (shape.subtitle) {
        mutableProperties[@"subtitle"] = shape.subtitle;
    }

    return [NSDictionary dictionaryWithDictionary:mutableProperties];
}

static NSDictionary * GeoJSONPointFeatureGeometryFromPointAnnotation(MKPointAnnotation *pointAnnotation) {
    NSArray *coordinates = @[
                             @(pointAnnotation.coordinate.longitude),
                             @(pointAnnotation.coordinate.latitude)
                             ];

    return @{
             @"type": @"Point",
             @"coordinates": coordinates
             };
}

static NSDictionary * GeoJSONLineStringFeatureGeometryFromPolyline(MKPolyline *polyline) {
    NSMutableArray *mutableCoordinatePairs = [NSMutableArray arrayWithCapacity:[polyline pointCount]];
    for (NSUInteger idx = 0; idx < [polyline pointCount]; idx++) {
        MKMapPoint point = polyline.points[idx];
        [mutableCoordinatePairs addObject:@[@(point.x), @(point.y)]];
    }

    return @{
             @"type": @"LineString",
             @"coordinates": mutableCoordinatePairs
             };
}

static NSDictionary * GeoJSONPolygonFeatureGeometryFromPolygon(MKPolygon *polygon) {
    NSMutableArray *mutableCoordinateSets = [NSMutableArray arrayWithCapacity:[polygon.interiorPolygons count] + 1];

    NSMutableArray *mutablePolygons = [NSMutableArray arrayWithObject:polygon];
    if ([polygon.interiorPolygons count] > 0) {
        [mutablePolygons addObjectsFromArray:polygon.interiorPolygons];
    }

    for (MKPolygon *interiorOrExteriorPolygon in mutablePolygons) {
        NSMutableArray *mutableCoordinatePairs = [NSMutableArray arrayWithCapacity:[interiorOrExteriorPolygon pointCount]];
        for (NSUInteger idx = 0; idx < [interiorOrExteriorPolygon pointCount]; idx++) {
            MKMapPoint point = interiorOrExteriorPolygon.points[idx];
            [mutableCoordinatePairs addObject:@[@(point.x), @(point.y)]];
        }

        [mutableCoordinateSets addObject:mutableCoordinatePairs];
    }

    return @{
             @"type": @"Polygon",
             @"geometry": mutableCoordinateSets
             };
}

static NSDictionary * GeoJSONFeatureFromShape(MKShape *shape, NSDictionary *properties) {
    NSDictionary *geometry = nil;
    if ([shape isKindOfClass:[MKPolygon class]]) {
        geometry = GeoJSONPolygonFeatureGeometryFromPolygon((MKPolygon *)shape);
    } else if ([shape isKindOfClass:[MKPolyline class]]) {
        geometry = GeoJSONLineStringFeatureGeometryFromPolyline((MKPolyline *)shape);
    } else if ([shape isKindOfClass:[MKPointAnnotation class]]) {
        geometry = GeoJSONPointFeatureGeometryFromPointAnnotation((MKPointAnnotation *)shape);
    } else {
        return nil;
    }

    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    [mutableProperties addEntriesFromDictionary:GeoJSONPropertiesForShape(shape)];

    return @{
             @"type": @"Feature",
             @"geometry": geometry,
             @"properties": mutableProperties
             };
}

static NSDictionary * GeoJSONFeatureCollectionFromShapes(NSArray *shapes, NSArray *arrayOfProperties) {
    NSMutableArray *mutableFeatures = [NSMutableArray arrayWithCapacity:[shapes count]];

    [shapes enumerateObjectsUsingBlock:^(MKShape *shape, NSUInteger idx, __unused BOOL *stop) {
        NSDictionary *properties = arrayOfProperties[idx];
        NSDictionary *feature = GeoJSONFeatureFromShape(shape, properties);
        if (feature) {
            [mutableFeatures addObject:feature];
        }
    }];

    return @{
             @"type": @"FeatureCollection",
             @"features": mutableFeatures
             };
}

#pragma mark -


@implementation GeoJSONSerialization

+ (MKShape *)shapeFromGeoJSONFeature:(NSDictionary *)feature
                               error:(NSError * __autoreleasing *)error
{
    @try {
        return MKShapeFromGeoJSONFeature(feature);
    }
    @catch (NSException *exception) {
        if (error) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: exception.name,
                                       NSLocalizedFailureReasonErrorKey: exception.reason
                                       };

            *error = [NSError errorWithDomain:GeoJSONSerializationErrorDomain code:-1 userInfo:userInfo];
        }

        return nil;
    }
}

+ (NSArray *)shapesFromGeoJSONFeatureCollection:(NSDictionary *)featureCollection
                                          error:(NSError * __autoreleasing *)error
{
    @try {
        return MKShapesFromGeoJSONFeatureCollection(featureCollection);
    }
    @catch (NSException *exception) {
        if (error) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: exception.name,
                                       NSLocalizedFailureReasonErrorKey: exception.reason
                                       };

            *error = [NSError errorWithDomain:GeoJSONSerializationErrorDomain code:-1 userInfo:userInfo];
        }

        return nil;
    }
}

#pragma mark -

+ (NSDictionary *)GeoJSONFeatureFromShape:(MKShape *)shape
                               properties:(NSDictionary *)properties
                                    error:(NSError * __autoreleasing *)error
{
    return GeoJSONFeatureFromShape(shape, properties);
}

+ (NSDictionary *)GeoJSONFeatureCollectionFromShapes:(NSArray *)shapes
                                          properties:(NSArray *)arrayOfProperties
                                               error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(!arrayOfProperties || [shapes count] == [arrayOfProperties count]);

    return GeoJSONFeatureCollectionFromShapes(shapes, arrayOfProperties);
}

@end
