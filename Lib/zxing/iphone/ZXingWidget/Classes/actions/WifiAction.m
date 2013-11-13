//
//  WifiAction.m
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

#import "WifiAction.h"



@implementation WifiAction

@synthesize SSID;
@synthesize TFormat;
@synthesize Password;

+ (id)actionWithSSID:(NSString *)SSID
        TFormat:(NSString *)TFormat
               Password:(NSString *)Password
{
  WifiAction *aWifi = [[[self alloc] init] autorelease];
  aWifi.SSID = SSID;
  aWifi.TFormat = TFormat;
  aWifi.Password = Password;

  return aWifi;
}

- (NSString *)title {
  return @"WIFI";
}

- (NSMutableArray *)propertys
{
	NSMutableArray *arrProperty = [NSMutableArray arrayWithCapacity:3];
	ItemAction *itemAction;
	if (SSID) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"wifiNameIcon.png";
		itemAction.nameStr = @"WifiActionSSID";
		itemAction.itemData = SSID;
		[arrProperty addObject:itemAction];
	}
	if (Password) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"passwordIcon.png";
		itemAction.nameStr = @"WifiActionPassword";
		itemAction.itemData = Password;
		[arrProperty addObject:itemAction];
	}
	if (TFormat) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"division.png";
		itemAction.nameStr = @"WifiActionTFormat";
		itemAction.itemData = TFormat;
		[arrProperty addObject:itemAction];
	}
	
	
	return arrProperty;
}
- (NSInteger)propertyCounts{
	return [[self propertys] count];
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
@end
