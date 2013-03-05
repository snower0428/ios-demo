//
//  Galleries2dView.m
//  Gallery
//
//  Created by zhangtianfu on 11-11-4.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    10

#import "Galleries2dView.h"

@interface Galleries2dView()
- (void)initGridsData;
- (void)moveGridsAnimation:(int)positionIndex;
@end



@implementation Galleries2dView


@synthesize	gridSize = m_gridSize;
@synthesize	centerGridSize = m_centerGridSize;
@synthesize	centerIndex = m_centerImageIndex;
@synthesize	interval = m_interval;
@synthesize	gridImages = m_gridImages;
@synthesize delegate = m_delegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		m_gridSize = CGSizeZero;
		m_centerGridSize = CGSizeZero;
		m_centerImageIndex = -1;
		m_count = 0;
		m_touching = NO;
		m_firstTouchPt = CGPointZero;;
		
		self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews{
	if (m_gridViews) {
		return;
	}
	
	m_count = [m_gridImages count];
	if (m_count<3) {
		return;
	}
	
	[self initGridsData];
}

- (void)initGridsData{
	if (m_interval<=0) {
		m_interval = 50;
	}
	
	m_centerPositionIndex = m_count/2;
	if (m_centerImageIndex<0 || m_centerImageIndex>m_count-1) {
		m_centerImageIndex = m_centerPositionIndex;
	}
	
	UIImage *firstImage = [m_gridImages objectAtIndex:0];
	if (CGSizeEqualToSize(m_gridSize, CGSizeZero)) {
		m_gridSize = CGSizeMake(firstImage.size.width/2, firstImage.size.height/2);
	}
	
	if (CGSizeEqualToSize(m_centerGridSize, CGSizeZero)) {
		m_centerGridSize = firstImage.size;
	}
	
	//calculate  positon indexs and rects
	float centerX = CGRectGetWidth(self.frame)/2;
	float centerY = CGRectGetHeight(self.frame)/2;
	CGRect centerRect = CGRectMake(centerX-m_centerGridSize.width/2, centerY-m_centerGridSize.height/2, m_centerGridSize.width, m_centerGridSize.height);
	m_positionRects = [[NSMutableArray arrayWithObject:NSStringFromCGRect(centerRect)] retain];
	m_positionIndexs = [[NSMutableArray arrayWithObject:[NSNumber numberWithInt:m_centerImageIndex]] retain];
	for (int i=0; i<m_count/2; i++) {
		int leftIndex = (m_centerImageIndex-i-1+m_count)%m_count;
		int rightIndex = (m_centerImageIndex+i+1)%m_count;
		
		//left
		[m_positionIndexs insertObject:[NSNumber numberWithInt:leftIndex] atIndex:0];
		
		float leftX = centerX - m_gridSize.width/2 - (i+1)*(m_gridSize.width+m_interval);
		float leftY = centerY - m_gridSize.height/2;
		CGRect leftRect = CGRectMake(leftX, leftY, m_gridSize.width, m_gridSize.height);
		[m_positionRects insertObject:NSStringFromCGRect(leftRect)  atIndex:0];
		
		//right
		if (leftIndex != rightIndex) {
			[m_positionIndexs addObject:[NSNumber numberWithInt:rightIndex]];
			
			float rightX = centerX-m_gridSize.width/2 + (i+1)*(m_gridSize.width+m_interval);
			float rightY = centerY-m_gridSize.height/2;
			CGRect rightRect = CGRectMake(rightX, rightY, m_gridSize.width, m_gridSize.height);
			[m_positionRects addObject:NSStringFromCGRect(rightRect)];
		}
	}
	
	//init grids
	m_gridViews = [[NSMutableArray alloc] init];
	for (int i=0; i<m_count; i++) {
		int positionIndex = [m_positionIndexs indexOfObject:[NSNumber numberWithInt:i]];
		CGRect rect = CGRectFromString([m_positionRects objectAtIndex:positionIndex]);
		
		UIImage *image = [m_gridImages objectAtIndex:i];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = rect;
		imageView.tag = i+1;
		[self addSubview:imageView];
		[imageView release];
		
		[m_gridViews addObject:imageView];//the same order as the images
	}
	
	//bring the center grid to Front
	UIImageView *centerView = [m_gridViews objectAtIndex:m_centerImageIndex];
	[self bringSubviewToFront:centerView];
}

- (void)moveGridsAnimation:(int)positionIndex{
	if (positionIndex == m_centerPositionIndex) {
		return;
	}
	
	NSArray *ultralIndexs = nil;
	int offset = fabs(positionIndex - m_centerPositionIndex);
	if (positionIndex < m_centerPositionIndex) {//move right
		NSMutableArray *oldPositionIndexs = m_positionIndexs;
		
		NSMutableArray *offsetIndexs = (NSMutableArray*)[m_positionIndexs subarrayWithRange:NSMakeRange((m_count-offset), offset)];
		[m_positionIndexs removeObjectsInArray:offsetIndexs];
		NSMutableArray *newPositionIndexs = [[NSMutableArray alloc] initWithArray:offsetIndexs];
		[newPositionIndexs addObjectsFromArray:m_positionIndexs];
		m_positionIndexs = newPositionIndexs;
		
		[oldPositionIndexs release];
		
		if (m_count>3) {
			ultralIndexs = [m_positionIndexs subarrayWithRange:NSMakeRange(0, offset)];
		}
	}else {//move left
		NSMutableArray *oldPositionIndexs = m_positionIndexs;
		
		NSMutableArray *offsetIndexs = (NSMutableArray*)[m_positionIndexs subarrayWithRange:NSMakeRange(0, offset)];
		[m_positionIndexs removeObjectsInArray:offsetIndexs];
		NSMutableArray *newPositionIndexs = [[NSMutableArray alloc] initWithArray:m_positionIndexs];
		[newPositionIndexs addObjectsFromArray:offsetIndexs];
		m_positionIndexs = newPositionIndexs;
		
		[oldPositionIndexs release];
		
		if (m_count>3) {
			ultralIndexs = [m_positionIndexs subarrayWithRange:NSMakeRange((m_count-offset), offset)];
		}
	}
	
	//the animation of  normal grids
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	//reset grids rect
	for (int i=0; i<m_count; i++) {
		int imageIndex = [[m_positionIndexs objectAtIndex:i] intValue];
		if ([ultralIndexs containsObject:[m_positionIndexs objectAtIndex:i]]) {
			continue;
		}

		CGRect rect = CGRectFromString([m_positionRects objectAtIndex:i]);
		
		UIView *gridView = [m_gridViews objectAtIndex:imageIndex];
		gridView.tag = imageIndex+1;
		[gridView setFrame:rect];
	}
	
	//bring the center grid to Front
	m_centerImageIndex = [[m_positionIndexs objectAtIndex:m_centerPositionIndex] intValue];
	UIImageView *centerView = [m_gridViews objectAtIndex:m_centerImageIndex];
	[self bringSubviewToFront:centerView];
	
	[UIView commitAnimations];
	
	//the animation of  ultral grids
	if (m_count>3) {
		for (NSNumber *positionItem in ultralIndexs) {
			int imageIndex = [positionItem intValue];
			int positionIndex = [m_positionIndexs indexOfObject:positionItem];
			CGRect rect = CGRectFromString([m_positionRects objectAtIndex:positionIndex]);
			if (positionIndex < m_centerPositionIndex) {//move right
				rect = CGRectOffset(rect, -CGRectGetWidth(rect), 0);
			}else {
				rect = CGRectOffset(rect, +CGRectGetWidth(rect), 0);
			}

			UIView *gridView = [m_gridViews objectAtIndex:imageIndex];
			gridView.tag = imageIndex+1;
			[gridView setFrame:rect];
			
			gridView.alpha = 0;
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		for (NSNumber *positionItem in ultralIndexs) {
			int imageIndex = [positionItem intValue];
			UIView *gridView = [m_gridViews objectAtIndex:imageIndex];
			gridView.alpha = 1;
			
			int positionIndex = [m_positionIndexs indexOfObject:positionItem];
			CGRect rect = CGRectFromString([m_positionRects objectAtIndex:positionIndex]);
			[gridView setFrame:rect];
		}
		[UIView commitAnimations];
		
	}
	
	if (m_delegate && [m_delegate respondsToSelector:@selector(galleries2dView:selectionDidChange:)]) {
		[m_delegate galleries2dView:self selectionDidChange:m_centerImageIndex];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	m_touching = YES;
	
	UITouch *touch = [touches anyObject];
	m_firstTouchPt = [touch locationInView:[touch view]];
	
	m_isSingleTap = ([touches count] == 1);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	m_isSingleTap = NO;
	
	if (!m_touching) {
		return;
	}
	
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:[touch view]];
	
	if (fabsf(m_firstTouchPt.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabsf(m_firstTouchPt.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
    {
        if (m_firstTouchPt.x < currentTouchPosition.x)
           [self moveGridsAnimation:m_centerPositionIndex-1];
        else
           [self moveGridsAnimation:m_centerPositionIndex+1];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	m_touching = NO;
	
	if (m_isSingleTap) {
		CGPoint targetPoint = [[touches anyObject] locationInView:[self superview]];
		CALayer *targetLayer = (CALayer *)[self.layer hitTest:targetPoint];

		UIImageView *targetImageView = nil;
		for (UIImageView *imageView in m_gridViews) {
			if (targetLayer == imageView.layer) {
				targetImageView = imageView;
				break;
			}
		}

		if (targetImageView){
			int targetPositionIndex = [m_positionIndexs indexOfObject:[NSNumber numberWithInt:targetImageView.tag-1]];
			if (targetPositionIndex == m_centerPositionIndex) {
				if (m_delegate && [m_delegate respondsToSelector:@selector(galleries2dView:imageSelected:)]) {
					[m_delegate galleries2dView:self imageSelected:m_centerImageIndex];
				}
			}else{
				[self moveGridsAnimation:targetPositionIndex];
			}
		}
	}
}

- (void)animationWillStart:(NSString *)animationID context:(void *)context{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)dealloc {
	[m_positionIndexs release];
	[m_positionRects release];
	[m_gridImages release];
	[m_gridViews release];

    [super dealloc];
}


@end
