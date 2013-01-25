//
//  BBPopoverView.m
//  Test
//
//  Created by zhangtianfu on 11-10-26.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "BBPopoverView.h"


@interface BBPopoverView()
- (void)displayPanel;
- (void)closePanel;
@end



@implementation BBPopoverView

@synthesize     images = m_images;
@synthesize     staticPanelImage = m_staticPanelImage;
@synthesize     dynamicPanelImage = m_dynamicPanelImage;
@synthesize     action  = m_action;
@synthesize     actions  = m_actions;



- (id)initWithFrame:(CGRect)frame superViewBounds:(CGRect)superViewBounds direction:(BOOL)isDown{
	if (self = [super initWithFrame:superViewBounds]) {
		m_dynamicPanel  = [[UIImageView alloc] initWithFrame:frame];
		m_dynamicPanel.userInteractionEnabled = YES;
		[self addSubview:m_dynamicPanel];
		[m_dynamicPanel release];
		
		m_staticPanel  = [[UIImageView alloc] initWithFrame:frame];
		m_staticPanel.userInteractionEnabled = YES;
		[self addSubview:m_staticPanel];
		[m_staticPanel release];
	
		m_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[m_btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
		[m_btn setFrame:frame];
		[self addSubview:m_btn];
		[m_btn setTag:m_index+1000];
		
		m_isPopover = NO;
		m_downDirection = isDown;
		m_action = -1;
		m_index = -1;
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (BOOL)initializeData{
	int actionCount = [m_actions count];
	int imagesCount = [m_images count];
	
	if (actionCount==imagesCount && actionCount>1) {
		m_count = actionCount;

		NSNumber *value = [NSNumber numberWithInt:m_action];
		m_index = [m_actions indexOfObject:value];
		m_action = [[m_actions objectAtIndex:m_index] intValue];
		
		UIImage *image = [m_images objectAtIndex:m_index];
		[m_btn setImage:image forState:UIControlStateNormal];
		[m_btn setTag:m_index+1000];
		
		return YES;
	}else {
		if (m_actions) {
			[m_actions release];
			m_actions = nil;
		}
		
		if (m_images) {
			[m_actions release];
			m_actions = nil;
		}
		
		m_action = -1;
		m_index = -1;
		
		return NO;
	}
}

- (void)setAction:(int)action{
	if (m_action != action) {
		m_action = action;
		
		if (m_action != -1) {
			NSNumber *value = [NSNumber numberWithInt:m_action];
			m_index = [m_actions indexOfObject:value];
			m_action = [[m_actions objectAtIndex:m_index] intValue];
			
			UIImage *image = [m_images objectAtIndex:m_index];
			[m_btn setImage:image forState:UIControlStateNormal];
			[m_btn setTag:m_index+1000];
		}
	}
}

- (void)setActions:(NSArray *)actions{
	if (actions != m_actions){
		[m_actions release];
		m_actions = [actions retain];
	}
}

- (void)setImages:(NSMutableArray*)images{
	if (images != m_images){
		[m_images release];
		m_images =[images retain];
	}
}


- (void)setStaticPanelImage:(UIImage *)image{
	if (m_staticPanelImage != image) {
		[m_staticPanelImage release];
		m_staticPanelImage = [image retain];
		
		m_staticPanel.image = image;
	}
}

- (void)addTarget:(id)target action:(SEL)selector{
	m_target = target;
	m_selector = selector;
}

- (void)clickBtn:(UIButton*)btn{
//	[[SoundEffect sharedInstance] playSound:sound_button];
	
	BOOL change = NO;
	
	int index = [btn tag] - 1000;
	if (index != m_index) {
		m_index = index;
		m_action = [[m_actions objectAtIndex:index] intValue];
		[m_btn setImage:[m_images objectAtIndex:index] forState:UIControlStateNormal];
		[m_btn setTag:m_index+1000];
		
		//[m_target performSelector:m_selector withObject:self];
		change = YES;
	}else {
		if (m_isPopover) {
			return;
		}
	}
	
	m_isPopover = !m_isPopover;
	
	if (m_isPopover) {
		[self displayPanel];
	}else {
		[self closePanel];
	}
	
	if (change) {
		[m_target performSelector:m_selector withObject:self];
	}
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:0.5];
	
}

- (void)displayPanel{
	[self.superview bringSubviewToFront:self];
	
	float width = CGRectGetWidth(m_btn.frame);
	float height = CGRectGetHeight(m_btn.frame);
	
	CGRect panelFrame = m_staticPanel.frame;
	if (m_downDirection) {
		panelFrame.size.height = height*m_count;
	}else {
		panelFrame.size.height = height*m_count;
		panelFrame.origin.y -= height*(m_count-1);
	}
	m_dynamicPanel.frame = panelFrame;
	m_dynamicPanel.image = m_dynamicPanelImage;
	
	for (int i = 0, j=0; i<m_count; i++) {
		if (i != m_index) {
			CGRect rect = CGRectZero;
			if (m_downDirection) {
				rect = CGRectMake(0, height+j*height, width, height);
			}else {
				rect = CGRectMake(0, j*height, width, height);
			}

			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			[btn setFrame:rect];
			[btn setTag:i+1000];
			[btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
			[btn setImage:[m_images objectAtIndex:i] forState:UIControlStateNormal];
			[m_dynamicPanel addSubview:btn];
			
			j++;
		}
	}
	
	m_dynamicPanel.frame = m_staticPanel.frame;
	m_dynamicPanel.frame = panelFrame;
}

- (void)closePanel{
	m_dynamicPanel.frame = m_staticPanel.frame;
	m_dynamicPanel.image = nil;
	[m_dynamicPanel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)animationWillStart:(NSString *)animationID context:(void *)context{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	if (m_isPopover) {
		if (!CGRectContainsPoint(m_dynamicPanel.frame, point) || CGRectContainsPoint(m_btn.frame, point)) {
			[self closePanel];
			m_isPopover = NO;
			return self;
		}
	}else {
		if (!CGRectContainsPoint(m_btn.frame, point)) {
			return nil;
		}
	}

	return [super hitTest:point withEvent:event];
}

- (void)dealloc {
	[m_staticPanelImage release];
	[m_dynamicPanelImage release];
	[m_images release];
	[m_actions release];
    [super dealloc];
}


@end
