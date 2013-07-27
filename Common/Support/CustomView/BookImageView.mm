//
//  BookImageView.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-1-18.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "BookImageView.h"



@implementation BookImageView


@synthesize bookInfo = m_bookInfo;


- (id)initWithImage:(UIImage *)image{
	if (self  = [super initWithImage:image]) {
		self.exclusiveTouch = YES;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	if (self  = [super initWithFrame:frame]) {
		self.exclusiveTouch = YES;
	}
	
	return self;
}

- (void)addTarget:(id)target action:(SEL)action{
	m_target = target;
	m_action = action;
	
	self.userInteractionEnabled = YES;
}


- (void)animateMax{
	[UIView beginAnimations:@"animateMax" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformScale(self.transform,1.25, 1.25);
	self.transform = transform;
	[UIView commitAnimations];
	
	m_isAnmating = YES;
}

- (void)animateMin{
	[UIView beginAnimations:@"animateMin" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformScale(self.transform,0.8, 0.8);
	self.transform = transform;
	[UIView commitAnimations];
	
	m_isAnmating = YES;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if (![finished boolValue]) {
		return;
	}
	
	if ([animationID isEqualToString:@"animateMax"]){
		[self animateMin];
	}else if ([animationID isEqualToString:@"animateMin"]){
		m_isAnmating = NO;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (m_isAnmating) {
		return;
	}
	
	if (m_bookInfo && m_target){
		[self animateMax];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (m_bookInfo && m_target){
		UITouch *touch = [touches anyObject];
		CGPoint pt = [touch locationInView:self];
		
		//[self performSelector:@selector(animateMin) withObject:nil afterDelay:0];
		if (CGRectContainsPoint(self.bounds, pt)) {
			[m_target performSelector:m_action withObject:self];
		}
	}
}

- (void)dealloc {
	[m_bookInfo release];
    [super dealloc];
}


@end
