//
//  TDTextViewCtrl.h
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-3.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDProduceType.h"

@interface TDTextViewCtrl : UIViewController <UITextViewDelegate, UITextFieldDelegate>
{
    TDProduceType       _produceType;
}

@property (nonatomic, assign) TDProduceType produceType;

@end
