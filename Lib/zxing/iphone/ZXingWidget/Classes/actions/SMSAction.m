//
//  SMSAction.m
//  ZXing
//
//  Created by Christian Brunschen on 16/06/2008.
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

#import "SMSAction.h"

// currently, including a message body makes the iPhone not actually
// go to compose an SMS at all, just start the SMS app. Bummer.
//#ifdef SMS_URL_INCLUDE_BODY
//#undef SMS_URL_INCLUDE_BODY
//#endif
#define SMS_URL_INCLUDE_BODY 1//added by ygf

@implementation SMSAction

@synthesize body;

+ (NSURL *)urlForNumber:(NSString *)number withBody:(NSString *)body {
  NSString *urlString = 
#ifdef SMS_URL_INCLUDE_BODY
    (body && [body length]) ?
    [NSString stringWithFormat:@"sms:%@?body=%@", number, [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] :
#endif
    [NSString stringWithFormat:@"sms:%@", number];
  return [NSURL URLWithString:urlString];
}

- (id)initWithNumber:(NSString *)n body:(NSString *)b {
  if ((self = [super initWithURL:[[self class] urlForNumber:n withBody:b]]) != nil) {
    self.number = n;
    self.body = b;
  }
  return self;
}

- (id)initWithNumber:(NSString *)n {
  return [self initWithNumber:n body:nil];
}

+ (id)actionWithNumber:(NSString *)number body:(NSString *)body {
  return [[[self alloc] initWithNumber:number body:body] autorelease];
}

+ (id)actionWithNumber:(NSString *)number {
  return [self actionWithNumber:number body:nil];
}

- (NSString *)title {
  return @"sms";
}

- (NSString *)alertTitle {
  return NSLocalizedString(@"SMSAction alert title", @"Compose");
}

- (NSString *)alertMessage {
  return [NSString localizedStringWithFormat:NSLocalizedString(@"SMSAction alert message", @"Compose SMS to %@?"), self.number];
}

- (NSString *)alertButtonTitle {
  return NSLocalizedString(@"SMSAction alert button title", @"Compose");
}
- (NSInteger)propertyCounts{
	if (body&&number) {
		return 2;
	}else if (body||number) {
		return 1;
	}else{
		return 0;
	}
	
}
- (NSMutableArray *)propertys
{
	NSMutableArray *arrProperty = [NSMutableArray arrayWithCapacity:1];
	if (number&&!body) {
		ItemAction *itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = SMSNumberType;
		itemAction.iconImage = @"sendSMS.png";
		itemAction.nameStr = @"SMSActionNumber";
		itemAction.itemData = number;
		
		[arrProperty addObject:itemAction];
	}
	if (body&&!number) {
		ItemAction *itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = SMSBodyType;
		itemAction.iconImage = @"sendSMS.png";
		itemAction.nameStr = @"SMSActionBody";
		itemAction.itemData = body;
		
		[arrProperty addObject:itemAction];
	}
	if (body&&number) {
		ItemAction *itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = SMSNumberBodyType;
		itemAction.iconImage = @"sendSMS.png";
		itemAction.nameStr = @"SMSActionNumberBody";
		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
		
		if (number) {
			[arr addObject:number];
		}else{
			[arr addObject:[NSNull null]];
		}
		if (body) {
			[arr addObject:body];
		}else{
			[arr addObject:[NSNull null]];
		}
		itemAction.itemData = arr;
		
		[arrProperty addObject:itemAction];
	}
	return arrProperty;
}
- (void) dealloc {
  [body release];
  [super dealloc];
}

@end
