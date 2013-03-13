//
//  FlipEffectsViewCtrl.h
//  Demo
//
//  Created by leihui on 13-3-13.
//
//

#import <UIKit/UIKit.h>
#import "PageFlipper.h"

@interface FlipEffectsViewCtrl : UIViewController <PageFlipperDelegate>
{
    PageFlipper     *_pageFlipper;
    UILabel         *_targetView;
    NSInteger       _pageIndex;
    BOOL            _isFlipping;
}

@end
