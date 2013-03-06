//
//  CarouselViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHBaseViewController.h"
#import "iCarousel.h"

@interface CarouselViewCtrl : LHBaseViewController <iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate>
{
    iCarousel           *_iCarousel;
    NSMutableArray      *_items;
    BOOL                _wrap;
}

@end
