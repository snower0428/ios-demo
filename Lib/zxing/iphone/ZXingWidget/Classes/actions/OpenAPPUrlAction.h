//
//  OpenAPPUrlAction.h
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

#import <UIKit/UIKit.h>
#import "ResultAction.h"

@interface OpenAPPUrlAction : ResultAction <UIAlertViewDelegate> {
  NSURL *URL;
}

@property(nonatomic, retain) NSURL *URL;

- (id)initWithURL:(NSURL *)URL;
+ (id)actionWithURL:(NSURL *)URL;
- (BOOL)linkURL;

- (NSString *)alertTitle;
- (NSString *)alertMessage;
- (NSString *)alertButtonTitle;

// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end