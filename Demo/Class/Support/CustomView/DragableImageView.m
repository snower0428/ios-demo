//
//  DragableImageView.m
//  ImageConnect
//
//  Created by Hui.Lei on 11-8-1.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "DragableImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface DragableImageView(privateMethods)
- (BOOL)isRect:(NSString *)rectString containsPoint:(CGPoint)point;
- (BOOL)isRects:(NSArray*)rects containsPoint:(CGPoint)point;
- (void)showAnimation:(CGPoint)fromPoint toPoint:(CGPoint)toPoint duration:(CGFloat)duration;
- (void)dragImageViewTapped;
- (void)playAudio:(NSString *)audioPath;
- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration curve:(int)curve degrees:(CGFloat)degrees;
@end

@implementation DragableImageView

@synthesize destImage = m_destImage;
@synthesize isRight=m_isRight;
@synthesize dragViewAudioPath = m_dragViewAudioPath;
@synthesize rightAudioPath = m_rightAudioPath;
@synthesize wrongAudioPath = m_wrongAudioPath;
@synthesize destRect = m_destRect;
@synthesize destRectExt = m_destRectExt;

@synthesize delegate=m_delegate;

@synthesize isShake = m_isShake;
@synthesize isLastObject = m_isLastObject;
@synthesize index = m_index;
@synthesize isDragableDisabled = m_isDragableDisabled;
@synthesize hasAnimation = m_hasAnimation;


- (void)setOriginalFrame:(CGRect)rt
{
	//[super setFrame:rt];
	if (CGRectIsEmpty(m_frameOriginal)) {
		m_frameOriginal=rt;
	}
	
}

- (id)initWithImage:(UIImage *)image
{
	if (self = [super initWithImage:image])
	{
		m_destRectExt = CGRectZero;
		self.exclusiveTouch = YES;
		
#ifdef TARGET_IPAD
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
																					action:@selector(dragImageViewTapped)];
		[self addGestureRecognizer:singleTap];
		[singleTap release];
#endif
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		m_frameOriginal=frame;
		m_destRectExt = CGRectZero;
		self.exclusiveTouch = YES;
		
#ifdef TARGET_IPAD
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
																					action:@selector(dragImageViewTapped)];
		[self addGestureRecognizer:singleTap];
		[singleTap release];
#endif
	}
	return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
	m_target = target;
	m_action = action;
	
	self.userInteractionEnabled = YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"DragableImageView touchesBegan......");
	if (m_isDragableDisabled)
	{
		return;
	}
	
	// Retrieve the touch point
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	m_startPoint = point;
	
	m_startFrame = self.frame.origin;
	
	[[self superview] bringSubviewToFront:self];
	
	if (m_delegate &&[m_delegate respondsToSelector:@selector(dragableImageStart:)]) {
		[m_delegate dragableImageStart:self];
	}
	
	if (m_hasAnimation)
	{
		[self stopAnimating];
	}
//	NSLog(@"m_startPoint.x = %.02f, m_startPoint.y = %.02f", m_startPoint.x, m_startPoint.y);
//	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"DragableImageView touchesMoved......");
//#ifdef NEW_HOME
	if (m_isDragableDisabled)
	{
		return;
	}
//#endif
	// Move relative to the original touch point
	CGPoint point = [[touches anyObject] locationInView:self];
	CGRect frame = [self frame];
	frame.origin.x += point.x - m_startPoint.x;
	frame.origin.y += point.y - m_startPoint.y;
	[self setFrame:frame];
	
//	[self.nextResponder touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//#ifdef NEW_HOME
	if (m_isDragableDisabled)
	{
		return;
	}
    if (CGPointEqualToPoint(m_startFrame, CGPointZero)) {
        // add by lh - 2012/01/10
        // 拖动会跑到左上角去
        // 跑到左上角是因为m_startFrame等于(0,0)
        m_startFrame = m_frameOriginal.origin;
    }
//#endif
	CGRect frame = self.frame;
	
	CGPoint fromPoint = frame.origin;
	fromPoint.x = frame.origin.x + frame.size.width/2;
	fromPoint.y = frame.origin.y + frame.size.height/2;
	
	CGPoint toPoint = m_startFrame;
	toPoint.x = m_startFrame.x + frame.size.width/2;
	toPoint.y = m_startFrame.y + frame.size.height/2;
	
	CGRect containRect;
	if (CGRectEqualToRect(m_destRectExt, CGRectZero))
	{
		containRect = m_destRect;
	}
	else
	{
		containRect = m_destRectExt;
	}
	
	if (CGRectContainsPoint(containRect, fromPoint))
	{
		frame = m_destRect;
		toPoint.x = frame.origin.x + frame.size.width/2;
		toPoint.y = frame.origin.y + frame.size.height/2;
		
		[self showAnimation:fromPoint toPoint:toPoint duration:0.5];
		
		[self setFrame:frame];
		self.userInteractionEnabled = NO;
		
		[self playAudio:m_rightAudioPath];

		
		if ([m_target respondsToSelector:m_action])
		{
			m_isRight=YES;
			[m_target performSelector:m_action withObject:self];
		}
		
		//czg replaceImage
		if (!m_imageOriginal) {
			m_imageOriginal=[self.image retain];
		}
		
		if (self.destImage) {
			self.image=self.destImage;
		}
	}
	else
	{
		[self showAnimation:fromPoint toPoint:toPoint duration:0.8];
		
		frame.origin.x = m_startFrame.x;
		frame.origin.y = m_startFrame.y;
		[self setFrame:frame];
		
		[self playAudio:m_wrongAudioPath];
		
		if ([m_target respondsToSelector:m_action])
		{
			m_isRight=NO;
			[m_target performSelector:m_action withObject:self];
		}
	}
//	[self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
	[self dragImageViewTapped];
//	[self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)dragImageViewTapped
{
	if (m_delegate &&[m_delegate respondsToSelector:@selector(dragableImageViewClicked:)])
	{
		// 在父窗口里处理点击事件
		[m_delegate dragableImageViewClicked:self];
		return;
	}
	
	[self playAudio:m_dragViewAudioPath];
}

- (void)sound
{
	[self playAudio:m_dragViewAudioPath];
}

- (void)onTimer
{
	CGFloat degrees = 10;
	degrees = -degrees;
	[self rotateImage:self duration:0.1 curve:UIViewAnimationCurveEaseIn degrees:degrees];
}

- (void)playAudio:(NSString *)audioPath
{
	if ([audioPath isFile])
	{
		if (m_dragViewPlayer)
		{
			[m_dragViewPlayer stop];
			[m_dragViewPlayer release];
			m_dragViewPlayer = nil;
		}
		m_dragViewPlayer = [[BBAudioPlayer alloc] initWithContentsOfFile:audioPath];
		[m_dragViewPlayer play];
	}
}

- (void)stopAudio
{
	if (m_dragViewPlayer && m_dragViewPlayer.playing)
	{
		[m_dragViewPlayer stop];
	}
}

- (void)showAnimation:(CGPoint)fromPoint toPoint:(CGPoint)toPoint duration:(CGFloat)duration
{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
	animation.toValue = [NSValue valueWithCGPoint:toPoint];
	animation.duration = duration;
	animation.delegate = self;
	[self.layer addAnimation:animation forKey:@"dragAnimation"];
}

// 上下移动动画
- (void)moveUpAndDown
{
	CGPoint fromPoint, toPoint;
	fromPoint.x = self.frame.origin.x + self.frame.size.width/2;
	fromPoint.y = self.frame.origin.y + self.frame.size.height/2;
	toPoint.x = self.frame.origin.x + self.frame.size.width/2;
	toPoint.y = self.frame.origin.y;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
	animation.toValue = [NSValue valueWithCGPoint:toPoint];
	animation.duration = 0.5;
	animation.repeatCount = 1;
	animation.autoreverses = YES;
	animation.delegate = self;
	[self.layer addAnimation:animation forKey:@"dragAnimation"];
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration curve:(int)curve degrees:(CGFloat)degrees
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	// The transform matrix
	CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
	image.transform = transform;
	
	// Commit the changes
	[UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

}

- (void)replaceImage:(UIImage *)destImage
{
	if (self.destImage) {
		self.image=self.destImage;
	}else {
		//self.image=destImage;
	}
}


- (BOOL)isRects:(NSArray*)rects containsPoint:(CGPoint)point
{
	BOOL ret = NO;
	for (NSString *rectString in rects)
	{
		CGRect rect = CGRectFromString(rectString);
		if (CGRectContainsPoint(rect, point))
		{
			ret = YES;
			break;
		}
	}
	
	return ret;
}
//czg
- (void)reset
{
	if (m_imageOriginal) {
		self.image=m_imageOriginal;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		self.frame=m_frameOriginal;
		[UIView commitAnimations];
		
	}
	self.userInteractionEnabled = YES;
}
- (void) dealloc
{
	self.destImage=nil;
	
	SAFE_DELETE(m_imageOriginal);
	[m_dragViewAudioPath release];
	[m_rightAudioPath release];
	[m_wrongAudioPath release];
	[m_dragViewPlayer release];
	
	[super dealloc];
}

@end
