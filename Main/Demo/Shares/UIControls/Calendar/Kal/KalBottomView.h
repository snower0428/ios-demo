//
//  KalBottomView.h
//  PandaHome
//
//  Created by leihui on 13-7-9.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KalBottomViewDelegate;

typedef enum
{
    KalBottomViewActionPreview  = 100,
    KalBottomViewActionTime,
    KalBottomViewActionStyle,
    KalBottomViewActionSolar,
    KalBottomViewActionLunar,
    KalBottomViewActionSolarAndLunar,
}KalBottomViewAction;

@interface KalBottomView : UIView
{
    id<KalBottomViewDelegate>   _delegate;
}

@property (nonatomic, assign) id<KalBottomViewDelegate> delegate;

@end

#pragma mark - KalBottomViewDelegate

@protocol KalBottomViewDelegate <NSObject>
@optional

- (void)bottomBarItemSelected:(id)sender;

@end
