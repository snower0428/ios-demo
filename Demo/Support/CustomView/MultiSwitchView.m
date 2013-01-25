//
//  MultiSwitchView.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-5-24.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "MultiSwitchView.h"



@implementation MultiSwitchView

@synthesize		image = m_bgImage;
@synthesize     images = m_images;
@synthesize     actions = m_actions;
@synthesize     action  = m_action;



- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])){   
		self.backgroundColor = [UIColor clearColor];
		m_index = -1;
		m_action = -1;
		m_count = 0;
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame =  self.bounds;
		btn.backgroundColor = [UIColor clearColor];
		[self addSubview:btn];
		[btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)layoutSubviews{
	[self performSelector:@selector(initializeData)];
}


- (BOOL)initializeData{
	int actionCount = [m_actions count];
	int imagesCount = [m_images count];
	
	if (actionCount==imagesCount && actionCount>1) {
		m_count = actionCount;
		
		NSNumber *value = [NSNumber numberWithInt:m_action];
		m_index = [m_actions indexOfObject:value];
		if (m_index == NSNotFound) {
			m_index = 0;
		}
		m_action = [[m_actions objectAtIndex:m_index] intValue];
		[self setNeedsDisplay];
		
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

- (void)addTarget:(id)target action:(SEL)action{
	m_target = target;
	m_selector = action;
}

- (void)clickBtn{
	if (m_count>1) {
		m_index = (m_index+1)%m_count;
		m_action = [[m_actions objectAtIndex:m_index] intValue];
		[self setNeedsDisplay];
		[m_target performSelector:m_selector withObject:self];
	}
}

- (void)setImages:(NSMutableArray*)images{
	if (images != m_images){
		[m_images release];
		m_images =[images retain];
	}
}

- (void)setActions:(NSArray *)actions{
	if (actions != m_actions){
		[m_actions release];
		m_actions = [actions retain];
	}
}

- (void)setAction:(int)action{
	if (m_action != action) {
		m_action = action;
		
		//已经初始化过
		if (m_count > 0) {
			NSNumber *value = [NSNumber numberWithInt:m_action];
			m_index = [m_actions indexOfObject:value];
			if (m_index == NSNotFound) {
				m_index = 0;
			}
			m_action = [[m_actions objectAtIndex:m_index] intValue];
			[self setNeedsDisplay];
		}
	}
}


// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (m_bgImage){
		[m_bgImage drawInRect:self.bounds];
	}
	
	if (m_count>0){
		if (m_index<0 || m_index>m_count-1){
			m_index = 0;
		}
		
		UIImage *image = [m_images objectAtIndex:m_index];
		if (image){
			float width = CGRectGetWidth(rect);
			float height = CGRectGetHeight(rect);
			float imageWidth = image.size.width;
			float imageHeight = image.size.height;
			
			float x = rect.origin.x;
			float y = rect.origin.y;
			
			if (imageWidth<width){
				x += (width-imageWidth)/2;
				width = imageWidth;
			}
			
			if (imageHeight<height){
				y += (height-imageHeight)/2;
				height = imageHeight;
			}
			
			CGRect rc = CGRectMake(x, y, width, height);
			[image drawInRect:rc];
		}
	}
}


- (void)dealloc {
	[m_bgImage release];
	[m_images release];
	[m_actions release];
    [super dealloc];
}


@end
