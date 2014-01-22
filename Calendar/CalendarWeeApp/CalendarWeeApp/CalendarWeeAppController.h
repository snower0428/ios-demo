//
//  CalendarWeeAppController.h
//  CalendarWeeApp
//
//  Created by leihui on 14-1-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBWeeAppController.h"
#import "KalView.h"

@interface CalendarWeeAppController : NSObject <BBWeeAppController, KalViewDelegate>
{
    UIView *_view;
}

- (UIView *)view;

@end