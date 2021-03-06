//
//  RichengParsedResult.m
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

#import "RichengParsedResult.h"
#import "RichengAction.h"

@implementation RichengParsedResult

@synthesize summaryStr;
@synthesize dtStartStr;
@synthesize dtEndStr;
@synthesize locationStr;
@synthesize descriptionStr;


- (void)populateActions {
    [actions addObject:[RichengAction actionWithSummary:self.summaryStr
                                           dtStart:self.dtStartStr
                                                  dtEnd:self.dtEndStr
											location:self.locationStr
										 description:self.descriptionStr
                                                    ]];
}

- (void)dealloc {
    [summaryStr release];
	summaryStr = nil;
    [dtStartStr release];
	dtStartStr = nil;
    [dtEndStr release];
	dtEndStr = nil;
	[locationStr release];
	locationStr = nil;
	[descriptionStr release];
	descriptionStr = nil;
    
    [super dealloc];
}

+ (NSString *)typeName {
    return NSLocalizedString(@"richeng Result Type Name", @"richeng");
}

- (UIImage *)icon {
    return [[UIImageManager shareInstance] imageWithFileName:@"TwoDimension/type_rc.png"];
}

@end
