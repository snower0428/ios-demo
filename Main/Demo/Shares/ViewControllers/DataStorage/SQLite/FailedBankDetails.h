//
//  FailedBankDetails.h
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import <Foundation/Foundation.h>

@interface FailedBankDetails : NSObject
{
    int         _uniqueId;
    NSString    *_name;
    NSString    *_city;
    NSString    *_state;
    int         _zip;
    NSDate      *_closeDate;
    NSDate      *_updatedDate;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) int zip;
@property (nonatomic, retain) NSDate *closeDate;
@property (nonatomic, retain) NSDate *updatedDate;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name city:(NSString *)city
                 state:(NSString *)state zip:(int)zip closeDate:(NSDate *)closeDate
           updatedDate:(NSDate *)updatedDate;

@end