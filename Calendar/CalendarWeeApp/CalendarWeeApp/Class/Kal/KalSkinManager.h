//
//  KalSkinManager.h
//  91Home
//
//  Created by leihui on 13-11-8.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    KalSkinTypeDefault  = 0, //默认黑色调
    KalSkinTypePink,    //粉色调
    KalSkinTypeBlue,    //蓝色调
    KalSkinTypeBrown,   //咖啡色调
}KalSkinType;

@interface KalSkinManager : NSObject
{
    KalSkinType     _skinType;
    UIColor     *_headerBgColor;
    UIColor     *_headerTitleColor;
    UIColor     *_weekdayBgColor;
    UIColor     *_weekdayColor;
    UIColor     *_monthBgColor;
    UIColor     *_solarColor;
    UIColor     *_lunarColor;
    UIColor     *_specialDayColor;
}

@property (nonatomic, assign) KalSkinType skinType;
@property (nonatomic, retain) UIColor *headerBgColor;
@property (nonatomic, retain) UIColor *headerTitleColor;
@property (nonatomic, retain) UIColor *weekdayBgColor;
@property (nonatomic, retain) UIColor *weekdayColor;
@property (nonatomic, retain) UIColor *monthBgColor;
@property (nonatomic, retain) UIColor *solarColor;
@property (nonatomic, retain) UIColor *lunarColor;
@property (nonatomic, retain) UIColor *specialDayColor;

+ (KalSkinManager *)shareInstance;
+ (void)exitInstance;

@end
