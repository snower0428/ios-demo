//
//  OpenAPPUrlAction.m
//  ZXing
//
//  Created by Christian Brunschen on 28/05/2008.
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

#import "OpenAPPUrlAction.h"
#import <UIKit/UIKit.h>

@implementation OpenAPPUrlAction

@synthesize URL;

- (BOOL)linkURL
{	
	//[[UIApplication sharedApplication] openURL:self.URL];
	BOOL res = NO;
	res = [[UIApplication sharedApplication] canOpenURL:self.URL];
    if (res) {
        [[UIApplication sharedApplication] openURL:self.URL];
    }
    return res;
}
- (id)initWithURL:(NSURL *)url {
  if ((self = [super init]) != nil) {
    self.URL = url;
  }
  return self;
}

+ (id)actionWithURL:(NSURL *)URL {
  return [[[self alloc] initWithURL:URL] autorelease];
}

- (NSString *)title {
  return @"OpenUrlActionURL";
}

- (NSString *)alertTitle {
  return NSLocalizedString(@"OpenURLAction alert title", @"Open URL");
}

- (NSString *)alertMessage {
  return [NSString localizedStringWithFormat:NSLocalizedString(@"OpenURLAction alert message", @"Open URL <%@>?"), self.URL];
}

- (NSString *)alertButtonTitle {
  return NSLocalizedString(@"OpenURLAction alert button title", @"Open");
}
- (NSMutableArray *)propertys
{
	NSMutableArray *arrProperty = [NSMutableArray arrayWithCapacity:1];
	if ([self.URL absoluteString]) {
		ItemAction *itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = OpenURLType;
		itemAction.iconImage = @"td_openLink.png";
		itemAction.nameStr = @"OpenUrlActionURL";
		itemAction.itemData = [self.URL absoluteString];
		
		[arrProperty addObject:itemAction];
	}
	return arrProperty;
}
- (NSInteger)propertyCounts{
	if(self.URL)
	{
		return 1;
	}else{
		return 0;
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		// perform the action
		[self linkURL];
	}
}
@end
