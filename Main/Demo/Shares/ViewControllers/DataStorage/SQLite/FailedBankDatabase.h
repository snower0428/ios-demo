//
//  FailedBankDatabase.h
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class FailedBankDetails;

@interface FailedBankDatabase : NSObject
{
    sqlite3     *_database;
}

+ (FailedBankDatabase *)database;
- (NSArray *)failedBankInfos;
- (FailedBankDetails *)failedBankDetails:(int)uniqueId;

@end
