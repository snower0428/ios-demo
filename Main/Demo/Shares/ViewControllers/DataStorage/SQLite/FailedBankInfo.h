//
//  FailedBankInfo.h
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import <Foundation/Foundation.h>

@interface FailedBankInfo : NSObject
{
    int         _uniqueId;
    NSString    *_name;
    NSString    *_city;
    NSString    *_state;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name city:(NSString *)city state:(NSString *)state;

@end
