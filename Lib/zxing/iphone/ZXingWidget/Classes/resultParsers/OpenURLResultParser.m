//
//  URIResultParser.m
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

#import "OpenURLResultParser.h"
#import "OpenURIParsedResult.h"
#import "CBarcodeFormat.h"

#define PREFIX_ITMS @"itms-"//@"itms-services"
#define PREFIX_HTTP @"http"//http or https
#define PREFIX_WWW @"www"

@implementation OpenURLResultParser

+ (void)load {
  [ResultParser registerResultParserClass:self];
}

+ (ParsedResult *)parsedResultForString:(NSString *)s
                                 format:(BarcodeFormat)format {
  
  NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
  ParsedResult *result = nil;
  
  NSRange prefix1Range = [s rangeOfString:PREFIX_ITMS options:NSCaseInsensitiveSearch];
  NSRange prefix2Range = [s rangeOfString:PREFIX_HTTP options:NSCaseInsensitiveSearch];
  NSRange prefix3Range = [s rangeOfString:PREFIX_WWW options:NSCaseInsensitiveSearch];
  if (prefix1Range.location == 0) {
    result = [[OpenURIParsedResult alloc] initWithURLString:s]; 
  } else if (prefix2Range.location == 0){
	  result = [[OpenURIParsedResult alloc] initWithURLString:s];
  }else if (prefix3Range.location == 0){
	  result = [[OpenURIParsedResult alloc] initWithURLString:s];
  }
	
  [myPool release];
  return [result autorelease];
}


@end
