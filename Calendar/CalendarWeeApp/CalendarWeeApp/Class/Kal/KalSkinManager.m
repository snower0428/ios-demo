//
//  KalSkinManager.m
//  91Home
//
//  Created by leihui on 13-11-8.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "KalSkinManager.h"
#import "UIColor+Expanded.h"

#define PHCalendarSkinPlistPath     [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"] stringByAppendingPathComponent:@"Configuration/Calendar/Skin.plist"]

static KalSkinManager *kKalSkinManager = nil;

@interface KalSkinManager ()

- (void)skinColorWithType:(KalSkinType)skinType;

@end

@implementation KalSkinManager

@synthesize skinType = _skinType;
@synthesize headerBgColor = _headerBgColor;
@synthesize headerTitleColor = _headerTitleColor;
@synthesize weekdayBgColor = _weekdayBgColor;
@synthesize weekdayColor = _weekdayColor;
@synthesize monthBgColor = _monthBgColor;
@synthesize solarColor = _solarColor;
@synthesize lunarColor = _lunarColor;
@synthesize specialDayColor = _specialDayColor;

+ (KalSkinManager *)shareInstance
{
    @synchronized(self)
    {
        if (nil == kKalSkinManager) {
            kKalSkinManager = [[KalSkinManager alloc] init];
        }
    }
    return kKalSkinManager;
}

+ (void)exitInstance
{
    @synchronized(self)
    {
        if (kKalSkinManager != nil) {
            [kKalSkinManager release];
            kKalSkinManager = nil;
        }
    }
}

- (id)init
{
    if (self = [super init]) {
        // Init
        _skinType = KalSkinTypeDefault;
        [self skinColorWithType:KalSkinTypeDefault];
    }
    return self;
}

- (void)setSkinType:(KalSkinType)skinType
{
    _skinType = skinType;
    [self skinColorWithType:skinType];
}

- (void)skinColorWithType:(KalSkinType)skinType
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:PHCalendarSkinPlistPath]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:PHCalendarSkinPlistPath];
        int index = (int)skinType;
        if (index < [array count]) {
            NSDictionary *dict = [array objectAtIndex:index];
            
            NSString *headerBgColor = [dict objectForKey:@"header_bg_color"];
            NSString *headerTitleColor = [dict objectForKey:@"header_title_color"];
            NSString *weekdayBgColor = [dict objectForKey:@"weekday_bg_color"];
            NSString *weekdayColor = [dict objectForKey:@"weekday_color"];
            NSString *monthBgColor = [dict objectForKey:@"month_bg_color"];
            NSString *solarColor = [dict objectForKey:@"solar_color"];
            NSString *lunarColor = [dict objectForKey:@"lunar_color"];
            NSString *specialDayColor = [dict objectForKey:@"special_day_color"];
            
            self.headerBgColor = [UIColor colorWithString2:headerBgColor];
            self.headerTitleColor = [UIColor colorWithString2:headerTitleColor];
            self.weekdayBgColor = [UIColor colorWithString2:weekdayBgColor];
            self.weekdayColor = [UIColor colorWithString2:weekdayColor];
            self.monthBgColor = [UIColor colorWithString2:monthBgColor];
            self.solarColor = [UIColor colorWithString2:solarColor];
            self.lunarColor = [UIColor colorWithString2:lunarColor];
            self.specialDayColor = [UIColor colorWithString2:specialDayColor];
        }
    }
    else {
        NSString *headerBgColor = @"{0.0, 0.0, 0.0, 0.7}";
        NSString *headerTitleColor = @"{255.0, 255.0, 255.0, 1.0}";
        NSString *weekdayBgColor = @"{0.0, 0.0, 0.0, 0.25}";
        NSString *weekdayColor = @"{212.0, 212.0, 212.0, 1.0}";
        NSString *monthBgColor = @"{0.0, 0.0, 0.0, 0.25}";
        NSString *solarColor = @"{255.0, 255.0, 255.0, 1.0}";
        NSString *lunarColor = @"{255.0, 255.0, 255.0, 1.0}";
        NSString *specialDayColor = @"{206.0, 27.0, 27.0, 1.0}";
        
        self.headerBgColor = [UIColor colorWithString2:headerBgColor];
        self.headerTitleColor = [UIColor colorWithString2:headerTitleColor];
        self.weekdayBgColor = [UIColor colorWithString2:weekdayBgColor];
        self.weekdayColor = [UIColor colorWithString2:weekdayColor];
        self.monthBgColor = [UIColor colorWithString2:monthBgColor];
        self.solarColor = [UIColor colorWithString2:solarColor];
        self.lunarColor = [UIColor colorWithString2:lunarColor];
        self.specialDayColor = [UIColor colorWithString2:specialDayColor];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [KalSkinManager exitInstance];
    
    self.headerBgColor = nil;
    self.headerTitleColor = nil;
    self.weekdayBgColor = nil;
    self.weekdayColor = nil;
    self.monthBgColor = nil;
    self.solarColor = nil;
    self.lunarColor = nil;
    self.specialDayColor = nil;
    
    [super dealloc];
}

@end
