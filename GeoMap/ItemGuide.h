//
//  ItemGuide.h
//  GeoMap
//
//  Created by SchwarzArthur on 6/4/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemGuide : NSObject {
    NSString *_name;
    NSString *_provinceE;
    NSString *_code;
    NSString *_par;
    NSString *_type;
    NSString *_province;
    NSString *_date;
    NSString *_url;
    NSString *_date_no;
    NSString *_area;
    NSString *_area_rai;
}

@property(nonatomic, strong) NSString *typeOfAnnotation;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *provinceE;
@property (nonatomic, copy) NSString *par;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *date_no;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *area_rai;

- (id)initWithName:(NSString*)name provinceE:(NSString*)provinceE code:(NSString*)code par:(NSString*)par type:(NSString*)type province:(NSString*)province date:(NSString*)date url:(NSString*)url date_no:(NSString*)date_no area:(NSString*)area area_rai:(NSString*)area_rai;

@end
