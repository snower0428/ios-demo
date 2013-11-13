//
//  RichengAction.m
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

#import "RichengAction.h"



@implementation RichengAction

@synthesize summaryStr;
@synthesize dtStartStr;
@synthesize dtEndStr;
@synthesize locationStr;
@synthesize descriptionStr;

+ (id)actionWithSummary:(NSString *)summary
				dtStart:(NSString *)dtStart
				  dtEnd:(NSString *)dtEnd
			   location:(NSString *)location
			description:(NSString *)description
{
  RichengAction *aRicheng = [[[self alloc] init] autorelease];
  aRicheng.summaryStr = summary;
  aRicheng.dtStartStr = dtStart;
  aRicheng.dtEndStr = dtEnd;
  aRicheng.locationStr = location;
  aRicheng.descriptionStr = description;
  return aRicheng;
}

- (NSString *)title {
  return @"Richeng";
}

- (NSMutableArray *)propertys
{
	NSMutableArray *arrProperty = [NSMutableArray arrayWithCapacity:5];
	ItemAction *itemAction;
	if (summaryStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"type_rcbt.png";
		itemAction.nameStr = @"RichengActionSummary";
		itemAction.itemData = summaryStr;
		[arrProperty addObject:itemAction];
	}
	if (dtStartStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"type_rckssj.png";
		itemAction.nameStr = @"RichengActionDTStart";
		itemAction.itemData = dtStartStr;
		[arrProperty addObject:itemAction];
	}
	if (dtEndStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"type_rcjssj.png";
		itemAction.nameStr = @"RichengActionDTEnd";
		itemAction.itemData = dtEndStr;
		[arrProperty addObject:itemAction];
	}
	if (locationStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"richeng_dizhi.png";
		itemAction.nameStr = @"RichengActionLocation";
		itemAction.itemData = locationStr;
		[arrProperty addObject:itemAction];
	}
	if (descriptionStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"richeng_shuoming.png";
		itemAction.nameStr = @"RichengActionDescription";
		itemAction.itemData = descriptionStr;
		[arrProperty addObject:itemAction];
	}
	
	
	return arrProperty;
}
- (NSInteger)propertyCounts{
	return [[self propertys] count];
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
@end
