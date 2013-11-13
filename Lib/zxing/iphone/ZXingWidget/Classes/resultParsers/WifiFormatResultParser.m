//
//  WifiFormatResultParser.m
//  ZXing
//
//  Created by Christian Brunschen on 25/06/2008.
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

#import "WifiFormatResultParser.h"
#import "CBarcodeFormat.h"
#import "ArrayAndStringCategories.h"
#import "WifiFormatParsedResult.h"

#define PREFIX_WIFI @"wifi:"

@implementation WifiFormatResultParser

+ (void)load {
  [ResultParser registerResultParserClass:self];
}

+ (ParsedResult *)parsedResultForString:(NSString *)s
                                 format:(BarcodeFormat)format {
  ParsedResult *result = nil;  
  NSRange prefixRange = [s rangeOfString:PREFIX_WIFI options:NSCaseInsensitiveSearch];  
  if (prefixRange.location == 0) {
    //result = [[OpenURIParsedResult alloc] initWithURLString:s];
	  NSString *SSIDStr=[[s fieldWithPrefix:@"S:"] stringWithTrimmedWhitespace];
	  NSString *TFormat=[[s fieldWithPrefix:@"T:"] stringWithTrimmedWhitespace];
	  NSString *PassWordStr=[[s fieldWithPrefix:@"P:"] stringWithTrimmedWhitespace];
	  WifiFormatParsedResult *result = [[WifiFormatParsedResult alloc] init];
	  result.SSID = SSIDStr;
	  result.TFormat = TFormat;
	  result.Password = PassWordStr;
	  return [result autorelease];
  }else{
	  return result;
  }  
}


@end
