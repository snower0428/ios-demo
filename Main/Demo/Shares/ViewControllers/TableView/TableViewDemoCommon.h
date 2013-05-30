//
//  TableViewDemoCommon.h
//  CommDemo
//
//  Created by leihui on 12-11-20.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// 线性渐变
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

// 一像素的矩形
CGRect rectFor1PxStroke(CGRect rect);

// 画一像素的线
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

// 添加光泽效果的线性渐变
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

// 转换度数值为弧度值
static inline double radians(double degrees) { return degrees * M_PI/180; }

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);

