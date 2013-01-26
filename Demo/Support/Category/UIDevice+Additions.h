//
//  UIDevice+Additions.h
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice(Additions)

- (NSString *)udid;//所有的设备都要用这个接口获取设备id
- (NSString *)macaddress;//获取wifi地址

@property(readonly) double availableMemory;

@end
