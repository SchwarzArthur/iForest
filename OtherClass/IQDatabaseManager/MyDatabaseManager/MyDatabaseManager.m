//
//  MyDatabaseManager.m
//  DatabaseManager

#import "MyDatabaseManager.h"
#import "IQDatabaseManagerSubclass.h"

@implementation MyDatabaseManager

+(NSURL*)modelURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabasePin" withExtension:IQ_MODEL_EXTENSION_momd];
    
    if (modelURL == nil)    modelURL = [[NSBundle mainBundle] URLForResource:@"MyDatabasePin" withExtension:IQ_MODEL_EXTENSION_mom];

    return modelURL;
}

#pragma mark - RecordTable
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];

    return [self allObjectsFromTable:NSStringFromClass([RecordTables class]) sortDescriptor:sortDescriptor];
}

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];

    return [self allObjectsFromTable:NSStringFromClass([RecordTables class]) where:key contains:value sortDescriptor:sortDescriptor];
}

-(RecordTables*) insertRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTables*)[self insertRecordInTable:NSStringFromClass([RecordTables class]) withAttribute:recordAttribute];
}

- (RecordTables*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTables*)[self insertRecordInTable:NSStringFromClass([RecordTables class]) withAttribute:recordAttribute updateOnExistKey:kName equals:[recordAttribute objectForKey:kName]];
}

- (RecordTables*) updateRecord:(RecordTables*)record inRecordTable:(NSDictionary*)recordAttribute
{
    return (RecordTables*)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL) deleteTableRecord:(RecordTables*)record
{
    return [self deleteRecord:record];
}

-(BOOL) deleteAllTableRecord
{
    return [self flushTable:NSStringFromClass([RecordTables class])];
}

#pragma mark - Settings
- (Setting*) settings
{
    Setting *settings = (Setting*)[self firstObjectFromTable:NSStringFromClass([Setting class])];
    
    //No settings
    if (settings == nil)
    {
        //Inserting default settings
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kPassword, nil];
        
        settings = (Setting*)[self insertRecordInTable:NSStringFromClass([Setting class]) withAttribute:dict];
    }

    return settings;
}

- (Setting*) saveSettings:(NSDictionary*)settings
{
    Setting *mySettings = (Setting*)[self firstObjectFromTable:NSStringFromClass([Setting class]) createIfNotExist:YES];
    return (Setting*)[self updateRecord:mySettings withAttribute:settings];
}

@end
