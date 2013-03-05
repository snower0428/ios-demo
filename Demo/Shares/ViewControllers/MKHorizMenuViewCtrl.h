//
//  MKHorizMenuViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHorizMenu.h"

@interface MKHorizMenuViewCtrl : UIViewController <MKHorizMenuDataSource, MKHorizMenuDelegate>
{
    NSArray         *_items;
    UILabel         *_label;
    MKHorizMenu     *_horizMenu;
}

@end
