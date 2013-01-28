//
//  BabySelectViewController.h
//  CommDemo
//
//  Created by leihui on 12-10-18.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// 按钮响应消息
typedef enum
{
    BabySelectActionTypePregnancy   = 200,  // 怀孕期
    BabySelectActionTypeHasBaby     = 201,  // 有宝宝
    BabySelectActionTypeNext        = 202,  // 下一步
}BabySelectActionType;

@interface BabySelectViewController : UIViewController
{
    UIImageView         *_imageViewTitle;
    UIImageView         *_imageViewBottom;
    UIImageView         *_imageViewSun;
    UIButton            *_btnPregnancy;
    UIButton            *_btnHasBaby;
    UIButton            *_btnNext;
    
    BOOL                _hasBaby;
}

@end
