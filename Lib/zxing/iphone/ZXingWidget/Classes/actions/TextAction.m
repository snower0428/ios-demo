//
//  TextAction.m
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

#import "TextAction.h"


@implementation TextAction

@synthesize textStr;



- (id)initWithText:(NSString *)content {
  if ((self = [super init]) != nil) {
    self.textStr = content;
  }
  return self;
}

+ (id)actionWithText:(NSString *)text {
	return [[[self alloc] initWithText:text] autorelease];
}

- (NSString *)title {
  return @"text";
}

- (NSString *)alertTitle {
  return NSLocalizedString(@"TextAction alert title", @"Compose");
}

- (NSString *)alertMessage {
  return [NSString localizedStringWithFormat:NSLocalizedString(@"TextAction alert message", @"Compose Text to %@?"), self.textStr];
}

- (NSString *)alertButtonTitle {
  return NSLocalizedString(@"TextAction alert button title", @"Compose");
}
- (NSInteger)propertyCounts{
	if (textStr) {
		return 1;
	}else{
		return 0;
	}
	
}
- (NSMutableArray *)propertys
{
	NSMutableArray *arrProperty = [NSMutableArray arrayWithCapacity:1];
	if (textStr) {
		ItemAction *itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"copyText.png";
		itemAction.nameStr = @"TextAction";
		itemAction.itemData = textStr;
		
		[arrProperty addObject:itemAction];
	}
	
	return arrProperty;
}
- (void) dealloc {
  [textStr release];
	
  [super dealloc];
}

@end
