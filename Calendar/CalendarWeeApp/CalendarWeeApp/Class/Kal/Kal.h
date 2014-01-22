//
//  Kal.h
//  PandaHome
//
//  Created by leihui on 13-7-8.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#ifndef PandaHome_Kal_h
#define PandaHome_Kal_h

#define kCalendarViewFrameKey           @"CalendarViewFrame"
#define kCalendarDateKey                @"CalendarDate"
#define kCalendarStyleKey               @"CalendarStyle"
#define kCalendarScaleFactorKey         @"CalendarScaleFactor"
#define kCalendarSkinKey                @"CalendarSkin"

//换肤通知
#define kChangeSkinNotification         @"kChangeSkinNotification"

typedef enum
{
    KalTileStyleSolar = 0,      //阳历
    KalTileStyleSolarAndLunar,  //阳历和阴历
    KalTileStyleLunar,          //阴历
}KalTileStyle;

extern CGFloat kScaleFactor;

#endif
