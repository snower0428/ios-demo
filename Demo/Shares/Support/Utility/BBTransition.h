//
//  BBTransition.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-10-12.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//-------------页面切换辅助类----------------
//

#import <Foundation/Foundation.h>


@protocol BBTransitionDelegate;

////////BBTransition
@interface BBTransition : NSObject {
	id			m_delegate;
	NSDictionary *m_userInfo;
	NSString	*m_animationID;
}

+ (id)transition;

- (BOOL)startTransitionOnView:(UIView*)container 
					 delegate:(id)delegate 
				  animationID:(NSString*)animationID
					  userInfo:(NSDictionary*)userInfo 
						 type:(TransitionType)transitionType 
					  direction:(TransitionDirection)direction;

@end

///////BBTransitionDelegate
@protocol BBTransitionDelegate <NSObject>
- (void)BBTransitionDidStop:(NSString *)animationID finished:(BOOL)finish userInfo:(NSDictionary*)userInfo;
@end


