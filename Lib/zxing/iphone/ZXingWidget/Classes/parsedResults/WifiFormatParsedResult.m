//
//  WifiFormatParsedResult.m
//  ZXing
//
//  Created by Christian Brunschen on 29/05/2008.
/*
 * Copyright 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "WifiFormatParsedResult.h"
#import "WifiAction.h"

@implementation WifiFormatParsedResult

@synthesize SSID;
@synthesize TFormat;
@synthesize Password;

- (void)populateActions {
    [actions addObject:[WifiAction actionWithSSID:self.SSID
                                           TFormat:self.TFormat
                                                  Password:self.Password
                                                    ]];
}

- (void)dealloc {
    [SSID release];
	SSID = nil;
    [TFormat release];
	TFormat = nil;
    [Password release];
	Password = nil;
    
    [super dealloc];
}

+ (NSString *)typeName {
    return NSLocalizedString(@"wifi Result Type Name", @"wifi");
}

- (UIImage *)icon {
    return [[UIImageManager shareInstance] imageWithFileName:@"TwoDimension/wifi.png"];
}

@end
