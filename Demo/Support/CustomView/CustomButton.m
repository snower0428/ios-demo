//
//  CustomButton.m
//  BabyBooks
//
//  Created by zhangtianfu on 11-9-2.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "CustomButton.h"


@implementation CustomButton

@synthesize  openPagePlist = m_openPagePlist;
@synthesize  closePageTag = m_closePageTag;
@synthesize  isExclusive = m_isExclusive;
@synthesize  autoClick = m_autoClick;
@synthesize  pageIndex = m_pageIndex;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	[self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	[self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
	[m_openPagePlist release];
    [super dealloc];
}


@end
