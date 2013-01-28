//
//  RotationImageView.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RotationImageView.h"
#import <QuartzCore/QuartzCore.h>


@implementation RotationImageView

@synthesize  repeatCountValue = m_repeatCount;
@synthesize  durationValue = m_duration;
@synthesize  autoReversesValue = m_autoReverses;
@synthesize  timingFunctionValue = m_timingFunction;
@synthesize  fillModeValue = m_fillModeValue;
@synthesize  removedOnCompletionValue = m_removedOnCompletionValue;
@synthesize  xAxis = m_xAxis;
@synthesize  yAxis = m_yAxis;
@synthesize  zAxis = m_zAxis;
@synthesize rotationFinished = m_rotationFinished;
@synthesize delegate = m_delegate;


- (void)startRotation{
	NSMutableArray *animations = [NSMutableArray array];
	
	if (m_xAxis) {//x轴
		int fromAngle = [[m_xAxis objectForKey:@"fromAngle"] intValue];
		int toAngle = [[m_xAxis objectForKey:@"toAngle"] intValue];
		double duration = [[m_xAxis objectForKey:@"duration"] floatValue];
		
		CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
		animation.fromValue = [NSNumber numberWithFloat:fromAngle/180.0f*M_PI];
		animation.toValue = [NSNumber numberWithFloat:toAngle/180.0f*M_PI];
		if (duration){
			animation.duration = duration;
		}
		
		[animations addObject:animation];
	}
	
	if (m_yAxis) {//y轴
		int fromAngle = [[m_yAxis objectForKey:@"fromAngle"] intValue];
		int toAngle = [[m_yAxis objectForKey:@"toAngle"] intValue];
		double duration = [[m_yAxis objectForKey:@"duration"] floatValue];
		
		CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
		animation.fromValue = [NSNumber numberWithFloat:fromAngle/180.0f*M_PI];
		animation.toValue = [NSNumber numberWithFloat:toAngle/180.0f*M_PI];
		if (duration){
			animation.duration = duration;
		}
		
		[animations addObject:animation];
	}
	
	if (m_zAxis) {//z轴
		int fromAngle = [[m_zAxis objectForKey:@"fromAngle"] intValue];
		int toAngle = [[m_zAxis objectForKey:@"toAngle"] intValue];
		double duration = [[m_zAxis objectForKey:@"duration"] floatValue];
		
		CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.fromValue = [NSNumber numberWithFloat:fromAngle/180.0f*M_PI];
		animation.toValue = [NSNumber numberWithFloat:toAngle/180.0f*M_PI];
		if (duration){
			animation.duration = duration;
		}
		
		[animations addObject:animation];
	}
	
	if ([animations count]==0) {
		return;
	}
	
	//timingfunction
	CAMediaTimingFunction *timingFunction = nil;
	switch (m_timingFunction) {
		case 0:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
		}break;
			
		case 1:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		}break;
			
		case 2:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		}break;
			
		case 3:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		}break;
			
		case 4:{
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		}break;
		default:
			timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
			break;
	}
	
	//fillMode
	NSString *fillMode = nil;
	switch (m_fillModeValue)
	{
		case 0:
			fillMode = kCAFillModeRemoved;
			break;
		case 1:
			fillMode = kCAFillModeForwards;
			break;
		case 2:
			fillMode = kCAFillModeBackwards;
			break;
		case 3:
			fillMode = kCAFillModeBoth;
			break;
		default:
			fillMode = kCAFillModeRemoved;
			break;
	}
	
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.delegate = self;
	theGroup.duration = m_duration;
	theGroup.autoreverses = m_autoReverses;
    theGroup.repeatCount =  (m_repeatCount>0 ? m_repeatCount: 100e+10);
	theGroup.timingFunction = timingFunction;
	theGroup.animations = animations;
	theGroup.removedOnCompletion = m_removedOnCompletionValue;	// removedOnCompletion默认为YES
	theGroup.fillMode = fillMode;
	[self.layer addAnimation:theGroup forKey:@"animation"];
    
    m_rotationFinished = NO;
}

- (void)stopRotation{
	[self.layer removeAllAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"RotationImageView ---- animationDidStop:finished");
    m_rotationFinished = YES;
    
    if (m_delegate && [m_delegate respondsToSelector:@selector(rotationImageViewFinished:)]) {
        [m_delegate rotationImageViewFinished:self];
    }
}

- (void)dealloc {
	[self stopRotation];
	[m_xAxis release];
	[m_yAxis release];
	[m_zAxis release];
    [super dealloc];
}


@end


