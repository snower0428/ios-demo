//
//  BBAnimation.h
//  CommDemo
//
//  Created by leihui on 12-10-19.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BBAnimation : NSObject
{
    
}

/**
 *
 *  永久闪烁
 *  duration:闪烁一次的持续时间
 */
+ (CABasicAnimation *)opacityForever:(CGFloat)duration;

/**
 *
 *  按次数闪烁
 *  repeatCount:闪烁次数
 *  duration:闪烁一次的持续时间
 */
+ (CABasicAnimation *)opacityCount:(CGFloat)repeatCount duration:(CGFloat)duration;

/**
 *
 *  按次数闪烁
 *  repeatCount:闪烁次数
 *  duration:闪烁一次的持续时间
 *  fromeValue:原始值
 *  toValue:目标值
 */
+ (CABasicAnimation *)opacityCount:(CGFloat)repeatCount duration:(CGFloat)duration fromValue:(NSNumber *)fromeValue toValue:(NSNumber *)toValue;

/**
 *
 *  横向移动
 *  x:移动到的目标位置
 *  target:target
 *  duration:移动到目标位置的持续时间
 */
+ (CABasicAnimation *)moveX:(NSNumber *)x target:(id)target duration:(CGFloat)duration;

/**
*
*  纵向移动
*  y:移动到的目标位置
*  target:target
*  duration:移动到目标位置的持续时间
*/
+ (CABasicAnimation *)moveY:(NSNumber *)y target:(id)target duration:(CGFloat)duration;

/**
 *
 *  点移动
 *  point:从当前位置的偏移值
 *  duration:移动到目标位置的持续时间
 */
+ (CABasicAnimation *)movePoint:(CGPoint)point duration:(CGFloat)duration;

/**
 *
 *  缩放
 *  scale:放大的倍数
 *  origin:原始大小
 *  duration:放大一次效果的持续时间
 *  repeateCount:重复次数
 */
+ (CABasicAnimation *)scale:(NSNumber *)multiple origin:(NSNumber *)originMultiple duration:(CGFloat)duration repeateCount:(CGFloat)repeateCount;

/**
 *
 *  组合动画
 *  animationArray:组合动画数组(存放CAAnimation对象)
 *  duration:一次动画组合效果的持续时间
 *  repeateCount:重复次数
 */
+ (CAAnimationGroup *)groupAnimation:(NSArray *)animationArray duration:(CGFloat)duration repeateCount:(CGFloat)repeateCount;

/**
 *
 *  路径动画
 *  path:动画路径
 *  duration:一次动画路径效果的持续时间
 *  repeateCount:重复次数
 
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.view.bounds.size.width/2, 0.0);
    CGPathAddLineToPoint(path, NULL, self.view.bounds.size.width/2, self.view.bounds.size.height);
    CGPathMoveToPoint(path, NULL, 0, self.view.bounds.size.height/2);
    CGPathAddLineToPoint(path, NULL, self.view.bounds.size.width, self.view.bounds.size.height/2);
    CGPathRelease(path);
 */
+ (CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path duration:(CGFloat)duration repeateCount:(CGFloat)repeateCount;

/**
 *
 *  旋转动画
 *  degree:旋转度数(沿顺时针旋转)
 *  duration:旋转到指定度数所要的时间
 *  repeateCount:重复次数
 */
+ (CABasicAnimation *)rotation:(CGFloat)degree duration:(CGFloat)duration repeateCount:(NSInteger)repeateCount;

/**
 *
 *  果冻动画效果
 *  target:
 *  duration:持续时间
 */
+ (CAKeyframeAnimation *)bounceAnimationWith:(id)target duration:(CGFloat)duration;

@end
