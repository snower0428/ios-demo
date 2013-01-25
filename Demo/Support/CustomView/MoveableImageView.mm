//
//  MoveableImageView.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MoveableImageView.h"


@interface MoveableImageView(PrivateMethod)
- (CABasicAnimation*)createAnimation;
- (void)movement;
@end



@implementation MoveableImageView

@synthesize  repeatCountValue = m_repeatCount;
@synthesize  durationValue = m_duration;
@synthesize  autoReversesValue = m_autoReverses;
@synthesize  timingFunctionValue = m_timingFunction;
@synthesize  fromValue = m_fromValue;
@synthesize  toValue = m_toValue;
@synthesize  delayTime = m_delayTime;
@synthesize  movableImageViewAudioPath = m_movableImageViewAudioPath;


- (id)initWithImage:(UIImage *)image
{
	if (self = [super initWithImage:image])
	{
		self.exclusiveTouch = YES;
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.exclusiveTouch = YES;
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([m_movableImageViewAudioPath isFile])
	{
		if (m_movableImageViewPlayer)
		{
			[m_movableImageViewPlayer stop];
			[m_movableImageViewPlayer release];
			m_movableImageViewPlayer = nil;
		}
		m_movableImageViewPlayer = [[BBAudioPlayer alloc] initWithContentsOfFile:m_movableImageViewAudioPath];
		[m_movableImageViewPlayer play];
	}
}

- (CABasicAnimation*)createAnimation{
	//timingfunction
	CAMediaTimingFunction *timingFunction = nil;
	switch (m_timingFunction) {
		case 0:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		}break;
			
		case 1:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		}break;
			
		case 2:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		}break;
			
		case 3:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		}break;
		default:
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
			break;
	}
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.timingFunction = timingFunction;
	animation.fromValue = [NSValue valueWithCGPoint:m_fromValue];
	animation.toValue = [NSValue valueWithCGPoint:m_toValue];
	animation.duration = m_duration;
	animation.autoreverses = m_autoReverses;
	animation.repeatCount = m_repeatCount>=0 ? m_repeatCount:100e+10;
//	animation.removedOnCompletion = YES;
//	animation.delegate = nil;
//	animation.cumulative = YES;
//	animation.fillMode = kCAFillModeForwards;
	
	
	return animation;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	if (flag) {
		[CATransaction begin];
		self.center = m_fromValue;
		CABasicAnimation *animation = [self createAnimation];
		animation.delegate = nil;
		[self.layer addAnimation:animation forKey:@"loopAnimation"];
		[CATransaction commit];
	}
}

- (void)startMovement{
	if (CGPointEqualToPoint(m_fromValue, m_toValue)) {
		return;
	}
	
    if (m_delayTime > 0) {
        [self performSelector:@selector(movement) withObject:nil afterDelay:m_delayTime];
    } else {
        [self movement];
    }
}

- (void)stopMovement{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self stopAnimating];
	[self.layer removeAllAnimations];
}

- (void)movement
{
    [self stopMovement];
	
	[CATransaction begin];
	CABasicAnimation *animation = [self createAnimation];
    
	if (!CGPointEqualToPoint(self.center, m_fromValue)) {
		animation.delegate = self;
		animation.fromValue = [NSValue valueWithCGPoint:self.center];
		animation.repeatCount = 0;
		animation.duration = fabs(self.center.x-m_toValue.x)/fabs(m_fromValue.x-m_toValue.x)*m_duration;
	}
	
	[self.layer addAnimation:animation forKey:@"firstAnimation"];
    self.layer.position = m_toValue;
	
	[CATransaction commit];
	[self startAnimating];
}

- (void)dealloc {
	[self stopMovement];
	[m_movableImageViewAudioPath release];
	[m_movableImageViewPlayer release];
    [super dealloc];
}

@end
