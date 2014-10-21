//
//  AddAnnotationView.m
//  GeoMap
//
//  Created by SchwarzArthur on 2/28/2557 BE.
//  Copyright (c) 2557 SchwarzArthur. All rights reserved.
//

#import "AddAnnotationView.h"

@implementation AddAnnotationView

+(NSString*)reuseIdPin;
{
    return NSStringFromClass(self);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
