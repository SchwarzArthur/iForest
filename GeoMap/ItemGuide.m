//
//  ItemGuide.m
//  GeoMap
//
//  Created by SchwarzArthur on 6/4/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "ItemGuide.h"

@implementation ItemGuide

@synthesize typeOfAnnotation;


- (id)initWithName:(NSString*)name provinceE:(NSString*)provinceE code:(NSString*)code par:(NSString*)par type:(NSString*)type province:(NSString*)province date:(NSString*)date url:(NSString*)url date_no:(NSString*)date_no area:(NSString*)area area_rai:(NSString*)area_rai{
    
    if ((self = [super init])) {
        _name = [name copy];
        _provinceE = [provinceE copy];
        _code = [code copy];
        _par = [par copy];
        _type = [type copy];
        _province = [province copy];
        _date = [date copy];
        _url = [url copy];
        _date_no = [date_no copy];
        _area = [area copy];
        _area_rai = [area_rai copy];
    }
    return self;
}

@end
