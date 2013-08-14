//
//  FailedBankDatabase.m
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import "FailedBankDatabase.h"
#import "FailedBankInfo.h"
#import "FailedBankDetails.h"

static FailedBankDatabase *kDatabase;

@implementation FailedBankDatabase

+ (FailedBankDatabase *)database
{
    if (kDatabase == nil) {
        kDatabase = [[FailedBankDatabase alloc] init];
    }
    return kDatabase;
}

- (id)init
{
    if (self = [super init]) {
        NSString *sqliteDb = [[NSBundle mainBundle] pathForResource:@"banklist" ofType:@"sqlite3"];
        if (sqlite3_open([sqliteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (NSArray *)failedBankInfos
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = @"SELECT id, name, city, state FROM failed_banks ORDER BY close_date DESC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *nameChars = (char *)sqlite3_column_text(statement, 1);
            char *cityChars = (char *)sqlite3_column_text(statement, 2);
            char *stateChars = (char *)sqlite3_column_text(statement, 3);
            
            NSString *name = [NSString stringWithUTF8String:nameChars];
            NSString *city = [NSString stringWithUTF8String:cityChars];
            NSString *state = [NSString stringWithUTF8String:stateChars];
            
            FailedBankInfo *info = [[FailedBankInfo alloc] initWithUniqueId:uniqueId name:name city:city state:state];
            [retval addObject:info];
            [info release];
        }
        sqlite3_finalize(statement);
    }

    return retval;
}

- (FailedBankDetails *)failedBankDetails:(int)uniqueId
{
    FailedBankDetails *retval = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT id, name, city, state, zip, close_date, updated_date FROM failed_banks WHERE id=%d", uniqueId];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
       while (sqlite3_step(statement) == SQLITE_ROW) {
           int uniqueId = sqlite3_column_int(statement, 0);
           char *nameChars = (char *) sqlite3_column_text(statement, 1);
           char *cityChars = (char *) sqlite3_column_text(statement, 2);
           char *stateChars = (char *) sqlite3_column_text(statement, 3);
           int zip = sqlite3_column_int(statement, 4);
           char *closeDateChars = (char *) sqlite3_column_text(statement, 5);
           char *updatedDateChars = (char *) sqlite3_column_text(statement, 6);
           
           NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
           NSString *city = [[NSString alloc] initWithUTF8String:cityChars];
           NSString *state = [[NSString alloc] initWithUTF8String:stateChars];
           NSString *closeDateString = [[NSString alloc] initWithUTF8String:closeDateChars];
           NSString *updatedDateString = [[NSString alloc] initWithUTF8String:updatedDateChars];
           
           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
           [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
           NSDate *closeDate = [formatter dateFromString:closeDateString];
           NSDate *updateDate = [formatter dateFromString:updatedDateString];
           
           retval = [[[FailedBankDetails alloc] initWithUniqueId:uniqueId name:name
                                                            city:city state:state zip:zip closeDate:closeDate 
                                                     updatedDate:updateDate] autorelease];
           
           [name release];
           [city release];
           [state release];
           [closeDateString release];
           [updatedDateString release];
           [formatter release];            
           break;            
       }
       sqlite3_finalize(statement);
    }
    
    return retval;
}

- (void)dealloc
{
    sqlite3_close(_database);
    
    [super dealloc];
}

@end
