//
//  RecordTable.m
//  DatabaseManager

#import "RecordTables.h"


@implementation RecordTables

@dynamic name;
@dynamic type;
@dynamic descriptions;
@dynamic coordinate_x;
@dynamic coordinate_y;
@dynamic date;
@dynamic editDate;
@dynamic photo;

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize description;
@synthesize image;
/*- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.coordinate_y doubleValue], [self.coordinate_x doubleValue]);
}

- (NSString *)title
{
    if ([self.name length] > 0) {
        return self.name;
    } else {
        return @"(No Description)";
    }
}

- (NSString *)subtitle
{
    return self.type;
}*/



@end
