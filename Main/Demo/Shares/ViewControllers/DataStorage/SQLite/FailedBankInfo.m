//
//  FailedBankInfo.m
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import "FailedBankInfo.h"

@implementation FailedBankInfo

@synthesize uniqueId = _uniqueId;
@synthesize name = _name;
@synthesize city = _city;
@synthesize state = _state;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name city:(NSString *)city state:(NSString *)state
{
    if (self = [super init]) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.city = city;
        self.state = state;
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.city = nil;
    self.state = nil;
    
    [super dealloc];
}

@end
