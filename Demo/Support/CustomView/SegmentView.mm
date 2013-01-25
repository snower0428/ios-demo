//
//  SegmentView.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-1-19.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "SegmentView.h"


@interface SegmentView(privateMethod)
- (void)initBtns;
- (void)selectBtn:(int)index;
@end

@implementation SegmentView

@synthesize     style	= m_style;
@synthesize		image	= m_bgImage;
@synthesize     images	= m_images;
@synthesize     actions = m_actions;
@synthesize     action  = m_action;
@synthesize     enableRepeatClick = m_enableRepeatClick;
@synthesize     enabled = m_enabled;

- (id)initWithFrame:(CGRect)frame Style:(SegmentViewStyle)style{
    if ((self = [super initWithFrame:frame])){   
		self.backgroundColor = [UIColor clearColor];
		m_index = -1;
		m_action = -1;
		m_count = 0;

		if (style<0 || style>1){
			m_style = SegmentViewStyleHorizontal;
		}else{
			m_style = style;
		}
		
		m_btns = [[NSMutableArray alloc] init];
        m_enableRepeatClick = NO;
        m_enabled = YES;
    }
    return self;
}

- (void)layoutSubviews{
	[self initializeData];
}

- (BOOL)initializeData{

	int imagesCount = [m_images count];
    if (imagesCount < 2) {
        return NO;
    }
    
    int actionCount = [m_actions count];
    if (actionCount > 0 && actionCount != imagesCount) {
        return NO;
    }
    
    
    if (actionCount == 0) {
        NSMutableArray *actions = [NSMutableArray array];
        for (int i=0; i<imagesCount; i++) {
            [actions addObject:[NSNumber numberWithInt:i]];
        }
        self.actions = actions;
    }


    m_count = imagesCount;
    
    NSNumber *value = [NSNumber numberWithInt:m_action];
    m_index = [m_actions indexOfObject:value];
    if (m_index == NSNotFound) {
        m_index = 0;
    }
    m_action = [[m_actions objectAtIndex:m_index] intValue];
    
    [self initBtns];
    [self selectBtn:m_index];
    
    return YES;
}

- (void)addTarget:(id)target action:(SEL)action{
	m_target = target;
	m_selector = action;
}
							   
- (void)initBtns{
	for (UIButton* btn in m_btns){
		[btn removeFromSuperview];
	}
	[m_btns removeAllObjects];
	
	float width = 0;
	float height = 0;
	if (SegmentViewStyleHorizontal == m_style){
		width = self.frame.size.width/m_count;
		height = self.frame.size.height;
	}else{
		width = self.frame.size.width;
		height = self.frame.size.height/m_count;
	}

	for (int i=0; i<m_count; i++){
		CGRect rect = CGRectZero;
		if (SegmentViewStyleHorizontal == m_style){
			rect = CGRectMake(width*i, 0, width, height);
		}else{
			rect = CGRectMake(0, height*i, width, height);
		}
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame =  rect;
		btn.backgroundColor = [UIColor clearColor];
		btn.tag = i+1000;
		[btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn];
		[m_btns addObject:btn];
	}
}

- (void)clickBtn:(id)sender{
    if (!m_enabled) {
        return;
    }
//	[[SoundEffect sharedInstance] playSound:sound_segment];
    
//    [[ClickEffectView sharedInstance] playEffect];
	
	int tag = [sender tag];
	[self selectBtn:tag-1000];
	
	[m_target performSelector:m_selector withObject:self];
}
							   
- (void)selectBtn:(int)index{
	m_index = index;
	m_action = [[m_actions objectAtIndex:m_index] intValue];
	
	for (int i=0; i<m_count; i++){
		UIButton	*btn = [m_btns objectAtIndex:i];
		if (m_index == i){
			btn.enabled = m_enableRepeatClick?YES:NO;
		}else{
			btn.enabled = YES;
		}
	}
	
	[self setNeedsDisplay];
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
		if ([m_btns count]) {
			NSNumber *value = [NSNumber numberWithInt:m_action];
			m_index = [m_actions indexOfObject:value];
			if (m_index == NSNotFound) {
				m_index = 0;
			}
			m_action = [[m_actions objectAtIndex:m_index] intValue];
			[self selectBtn:m_index];
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
			float theImageWidth = image.size.width;
			float theImageHeight = image.size.height;
			
			float x = rect.origin.x;
			float y = rect.origin.y;
			
			if (theImageWidth<width){
				x += (width-theImageWidth)/2;
				width = theImageWidth;
			}
			
			if (theImageHeight<height){
				y += (height-theImageHeight)/2;
				height = theImageHeight;
			}
			
			CGRect rc = CGRectMake(x, y, width, height);
			[image drawInRect:rc];
		}
	}
}


- (void)dealloc {
	[m_bgImage release];
	[m_images release];
	[m_btns release];
	[m_actions release];
    [super dealloc];
}


@end
