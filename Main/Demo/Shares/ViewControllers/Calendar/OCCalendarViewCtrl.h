//
//  OCCalendarViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-7-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCalendarViewController.h"

@interface OCCalendarViewCtrl : UIViewController <UIGestureRecognizerDelegate, OCCalendarDelegate>
{
    OCCalendarViewController *calVC;
    
    UILabel *toolTipLabel;
}

@end
