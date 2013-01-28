//
//  CustomHeaderView.h
//  CommDemo
//
//  Created by leihui on 12-11-21.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeaderView : UIView
{
    UILabel             *_titleLabel;
    UIColor             *_lightColor;
    UIColor             *_darkColor;
    CGRect              _coloredBoxRect;
    CGRect              _paperRect;
}

@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UIColor *lightColor;
@property(nonatomic, retain) UIColor *darkColor;

@end
