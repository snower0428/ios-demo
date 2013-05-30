//
//  BBAnimation.m
//  CommDemo
//
//  Created by leihui on 12-10-19.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "BBAnimation.h"

@implementation BBAnimation


/**
 *
 *  永久闪烁
 *  duration:闪烁一次的持续时间
 */
+ (CABasicAnimation *)opacityForever:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBackwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

/**
 *
 *  按次数闪烁
 *  repeatCount:闪烁次数
 *  duration:闪烁一次的持续时间
 */
+ (CABasicAnimation *)opacityCount:(CGFloat)repeatCount duration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

/**
 *
 *  按次数闪烁
 *  repeatCount:闪烁次数
 *  duration:闪烁一次的持续时间
 *  fromeValue:原始值
 *  toValue:目标值
 */
+ (CABasicAnimation *)opacityCount:(CGFloat)repeatCount duration:(CGFloat)duration fromValue:(NSNumber *)fromeValue toValue:(NSNumber *)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = fromeValue;
    animation.toValue = toValue;
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

/**
 *
 *  横向移动
 *  x:移动到的目标位置
 *  target:target
 *  duration:移动到目标位置的持续时间
 */
+ (CABasicAnimation *)moveX:(NSNumber *)x target:(id)target duration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue = x;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

/**
 *
 *  纵向移动
 *  y:移动到的目标位置
 *  target:target
 *  duration:移动到目标位置的持续时间
 */
+ (CABasicAnimation *)moveY:(NSNumber *)y target:(id)target duration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue = y;
    animation.delegate = target;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

/**
 *
 *  点移动
 *  point:从当前位置的偏移值
 *  duration:移动到目标位置的持续时间
 */
+ (CABasicAnimation *)movePoint:(CGPoint)point duration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    animation.toValue = [NSValue valueWithCGPoint:point];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

/**
 *
 *  缩放
 *  scale:放大的倍数
 *  origin:原始大小
 *  duration:放大一次效果的持续时间
 *  repeateCount:重复次数
 */
+ (CABasicAnimation *)scale:(NSNumber *)multiple origin:(NSNumber *)originMultiple duration:(CGFloat)duration repeateCount:(CGFloat)repeateCount
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = originMultiple;
    animation.toValue = multiple;
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = repeateCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

/**
 *
 *  组合动画
 *  animationArray:组合动画数组(存放CAAnimation对象)
 *  duration:一次动画组合效果的持续时间
 *  repeateCount:重复次数
 */
+ (CAAnimationGroup *)groupAnimation:(NSArray *)animationArray duration:(CGFloat)duration repeateCount:(CGFloat)repeateCount
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationArray;
    animation.duration = duration;
    animation.repeatCount = repeateCount;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

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
+ (CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path duration:(CGFloat)duration repeateCount:(CGFloat)repeateCount
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    animation.duration = duration;
    animation.autoreverses = NO;
    animation.repeatCount = repeateCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

/**
 *
 *  旋转动画
 *  degree:旋转度数(沿顺时针旋转)
 *  duration:旋转到指定度数所要的时间
 *  repeateCount:重复次数
 */
+ (CABasicAnimation *)rotation:(CGFloat)degree duration:(CGFloat)duration repeateCount:(NSInteger)repeateCount
{
    CATransform3D rotationTransfrom = CATransform3DMakeRotation(degree / 180.0 * M_PI, 0, 0, 1.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransfrom];
    animation.duration = duration;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeateCount;
    
    return animation;
}

/**
 *
 *  果冻动画效果
 *  target:
 *  duration:持续时间
 */
+ (CAKeyframeAnimation *)bounceAnimationWith:(id)target duration:(CGFloat)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = duration;
	animation.delegate = target;
	animation.fillMode = kCAFillModeForwards;
	
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	
	animation.values = values;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

@end
