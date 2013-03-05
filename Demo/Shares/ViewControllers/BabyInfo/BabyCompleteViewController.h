//
//  BabyCompleteViewController.h
//  CommDemo
//
//  Created by leihui on 12-10-22.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    BabyCompleteActionTypeComplete      = 200,  // 完成
}BabyCompleteActionType;

@interface BabyCompleteViewController : UIViewController
{
    UIImageView         *_imageViewBg;
    UIImageView         *_imageViewPortrait;
    UIImageView         *_imageViewLove;
    
    AnimationView       *_animationBox;
    
    UIImageView         *_imageViewSun;
    UIButton            *_btnComplete;
}

@end
