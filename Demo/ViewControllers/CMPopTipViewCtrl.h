//
//  CMPopTipViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@interface CMPopTipViewCtrl : UIViewController <CMPopTipViewDelegate>
{
    NSMutableArray      *_visiblePopTipViews;
    NSDictionary        *_contents;
    NSDictionary        *_titles;
    NSArray             *_colorSchemes;
    id                  _currentPopTipViewTarget;
}

@end
