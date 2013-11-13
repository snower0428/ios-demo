//
//  RichengResultParser.m
//  ZXing
//
//  Ported to Objective-C by George Nachman on 7/19/2011.
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
#import "RichengResultParser.h"
#import "CBarcodeFormat.h"
#import "RichengParsedResult.h"


@implementation RichengResultParser

+ (void)load {
    [ResultParser registerResultParserClass:self];
}

+ (ParsedResult *)parsedResultForString:(NSString *)rawText
                                 format:(BarcodeFormat)format {
    if (rawText == nil || (![rawText hasPrefix:@"BEGIN:VEVENT"])/*||(![rawText hasSuffix:@"END:VEVENT"])*/) {
        return nil;
    }    
	BOOL res = NO;
	RichengParsedResult *result = [[[RichengParsedResult alloc] init] autorelease];
	NSArray *richengArr = [rawText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];//[rawText componentsSeparatedByString:@":"];
	for (NSUInteger index = 0; index<[richengArr count]; index ++) {
		NSString *strItem = [richengArr objectAtIndex:index];
		strItem = [strItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSRange range = [strItem rangeOfString:@":"];
		NSRange range1;
		range1.location = range.location+range.length;
		range1.length = [strItem length] - range1.location;
		NSString *strItem1 = [strItem substringWithRange:range1];
		if (strItem1) {
			if ([strItem hasPrefix:@"SUMMARY"]) {
				result.summaryStr = strItem1;
				res = YES;
			}else if ([strItem hasPrefix:@"DTSTART"]) {
				result.dtStartStr = strItem1;
				res = YES;
			}else if ([strItem hasPrefix:@"DTEND"]) {
				result.dtEndStr = strItem1;
				res = YES;
			}else if ([strItem hasPrefix:@"LOCATION"]) {
				result.locationStr = strItem1;
				res = YES;
			}else if ([strItem hasPrefix:@"DESCRIPTION"]) {
				result.descriptionStr = strItem1;
				res = YES;
			}
		}			
		
	}		
	if (res) {
		return result;
	}
	return nil;
}

@end

