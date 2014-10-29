//
//  MyDatabaseManager.h
//  DatabaseManager

#import "IQDatabaseManager.h"
#import "MyDatabaseConstants.h"

@interface MyDatabaseManager : IQDatabaseManager

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute;
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value;

- (RecordTables*) insertRecordInRecordTable:(NSDictionary*)recordAttributes;
- (RecordTables*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttributes;
- (RecordTables*) updateRecord:(RecordTables*)record inRecordTable:(NSDictionary*)recordAttributes;
- (BOOL) deleteTableRecord:(RecordTables*)record;


- (BOOL) deleteAllTableRecord;

- (Setting*) settings;
- (Setting*) saveSettings:(NSDictionary*)settings;

@end
