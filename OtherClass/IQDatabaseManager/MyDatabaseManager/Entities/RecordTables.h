//
//  RecordTable.h
//  DatabaseManager

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "QTreeInsertable.h"

@interface RecordTables : NSManagedObject <MKAnnotation, QTreeInsertable>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * coordinate_x;
@property (nonatomic, retain) NSString * coordinate_y;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *editDate;
//@property (nonatomic, retain) NSString * photo;

@property(nonatomic, retain) NSData *photo;



@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) UIImage *image;

@end
