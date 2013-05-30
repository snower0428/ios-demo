//
//  CustomCellBackgroundView.h
//  CommDemo
//
//  Created by leihui on 12-11-20.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellBackgroundView : UIView
{
    BOOL            _lastCell;
    BOOL            _selected;
}

@property(nonatomic, assign) BOOL lastCell;
@property(nonatomic, assign) BOOL selected;

@end
