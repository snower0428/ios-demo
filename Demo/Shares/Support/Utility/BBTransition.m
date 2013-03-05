//
//  BBTransition.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-10-12.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "BBTransition.h"


@implementation BBTransition

+ (id)transition{
	return [[[self alloc] init] autorelease];
}

- (BOOL)startTransitionOnView:(UIView*)container 
					 delegate:(id)delegate 
				  animationID:(NSString*)animationID 
					 userInfo:(NSDictionary*)userInfo 
						 type:(TransitionType)transitionType 
					  direction:(TransitionDirection)direction{
	if (transitionType == TransitionTypeNone) {//无动画
		return NO;
	}
	
	if (delegate) {
		m_delegate = delegate;
		m_userInfo = [userInfo retain];
		m_animationID = [animationID retain];
	}
	
	if (transitionType == TransitionTypePageCurl) {//UIViewAnimation
		UIViewAnimationTransition t = (direction==TransitionDirectionFromRight ? UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlDown);
		[UIView beginAnimations:@"transition" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:t forView:container cache:YES];
		[UIView commitAnimations];
		
//		[[SoundEffect sharedInstance] playSound:sound_pageFlip];
	}else {//CATransition
		NSString *type = nil;
		
		switch (transitionType) {
			case TransitionTypePush:{
				type = kCATransitionPush;//推动
			}break;
				
			case TransitionTypeFade:{
				type = kCATransitionFade;//直接消失,新的直接显示
			}break;
				
			case TransitionTypeMoveIn:{
				type = kCATransitionMoveIn;//新的移出来
			}break;
				
			case TransitionTypeReveal:{//移走旧的
				type = kCATransitionReveal;
			}break;
			default:
				break;
		}
		
		NSString *subtype = nil;
		switch (direction) {
			case TransitionDirectionFromTop:{
				subtype = kCATransitionFromTop;
			}break;
				
			case TransitionDirectionFromBottom:{
				subtype = kCATransitionFromBottom;
			}break;
				
			case TransitionDirectionFromLeft:{
				subtype = kCATransitionFromLeft;
			}break;
				
			case TransitionDirectionFromRight:{
				subtype = kCATransitionFromRight;
			}break;
			default:
				break;
		}
	
		//滑出动画
		CATransition *animation = [CATransition animation];
		animation.type = type;
		animation.subtype = subtype;
		animation.duration = 0.8;
		animation.delegate = self;
		animation.fillMode = kCAFillModeForwards;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		[container.layer addAnimation:animation forKey:@"transition"];
	}
	
	return YES;
}

//////////////CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	if (m_delegate && [m_delegate respondsToSelector:@selector(BBTransitionDidStop:finished:userInfo:)]) {
		[m_delegate BBTransitionDidStop:m_animationID finished:flag userInfo:m_userInfo];
		m_delegate = nil;
	}
	
	if (m_userInfo) {
		[m_userInfo release];
		m_userInfo = nil;
	}
	
	if (m_animationID) {
		[m_animationID release];
		m_animationID = nil;
	}
}

//////////////UIViewAnimationDelegate
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if (m_delegate && [m_delegate respondsToSelector:@selector(BBTransitionDidStop:finished:userInfo:)]) {
		[m_delegate BBTransitionDidStop:m_animationID finished:[finished boolValue] userInfo:m_userInfo];
		m_delegate = nil;
	}
	
	if (m_userInfo) {
		[m_userInfo release];
		m_userInfo = nil;
	}
	
	if (m_animationID) {
		[m_animationID release];
		m_animationID = nil;
	}
}

@end
