//
//  UniversalResultParser.m
//  ZXingWidget
//
//  Created by Romain Pechayre on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UniversalResultParser.h"
#import "SMSTOResultParser.h"
#import "URLResultParser.h"
#import "TelResultParser.h"
#import "URLTOResultParser.h"
#import "SMSResultParser.h"
#import "PlainEmailResultParser.h"
#import "MeCardParser.h"
#import "EmailDoCoMoResultParser.h"
#import "BookmarkDoCoMoResultParser.h"
#import "GeoResultParser.h"
#import "TextResultParser.h"
#import "CBarcodeFormat.h"
#import "ProductResultParser.h"
#import "BizcardResultParser.h"
#import "AddressBookAUResultParser.h"
#import "VCardResultParser.h"
#import "SMTPResultParser.h"
#import "ISBNResultParser.h"
#import "EmailAddressResultParser.h"

#import "RichengResultParser.h"
#import "WifiFormatResultParser.h"
#import "OpenURLResultParser.h"

@implementation UniversalResultParser
static NSMutableArray *sTheResultParsers = nil;
//@synthesize parsers;

+(void) load {
  [self initWithDefaultParsers];
}

+ (void)addParserClass:(Class)klass {
  [sTheResultParsers addObject:klass];
}

+ (void) initWithDefaultParsers {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  @synchronized(self) {
    if (!sTheResultParsers) {
      sTheResultParsers = [[NSMutableArray alloc] init];
    }
  }
  [pool release];
	//added by ygf 
  [self addParserClass:[OpenURLResultParser class]];
  [self addParserClass:[BookmarkDoCoMoResultParser class]];
  [self addParserClass:[MeCardParser class]];
  [self addParserClass:[EmailDoCoMoResultParser class]];
  [self addParserClass:[AddressBookAUResultParser class]];
  [self addParserClass:[VCardResultParser class]];
  [self addParserClass:[BizcardResultParser class]];
  [self addParserClass:[EmailAddressResultParser class]];
  [self addParserClass:[PlainEmailResultParser class]];
  [self addParserClass:[SMTPResultParser class]];
  [self addParserClass:[TelResultParser class]];
  [self addParserClass:[SMSResultParser class]];
  [self addParserClass:[SMSTOResultParser class]];
  [self addParserClass:[GeoResultParser class]];//show loaction map
  [self addParserClass:[URLTOResultParser class]];
  [self addParserClass:[URLResultParser class]];
  [self addParserClass:[ISBNResultParser class]];
  [self addParserClass:[ProductResultParser class]];
	//wifi format
    [self addParserClass:[RichengResultParser class]];
  [self addParserClass:[WifiFormatResultParser class]];
  [self addParserClass:[TextResultParser class]];//nothing to do here
}

+ (ParsedResult *)parsedResultForString:(NSString *)s
                                 format:(BarcodeFormat)format {
#ifdef DEBUG
  NSLog(@"parsing result:\n<<<\n%@\n>>>\n", s);
#endif
  for (Class c in sTheResultParsers) {
#ifdef DEBUG
    NSLog(@"trying %@", NSStringFromClass(c));
#endif
    ParsedResult *result = [c parsedResultForString:s format:format];
    if (result != nil) {
#ifdef DEBUG
      NSLog(@"parsed as %@ %@", NSStringFromClass([result class]), result);
#endif
      return result;
    }
  }
  return nil;
}

+ (ParsedResult *)parsedResultForString:(NSString *)theString {
  return [self parsedResultForString:theString format:BarcodeFormat_NONE];
}

@end
