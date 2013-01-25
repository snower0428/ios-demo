//
//  Wordlabel.m
//  BabyBooks
//
//  Created by nd on 11-4-25.
//  Copyright 2011 ND. All rights reserved.
//

#import "Wordlabel.h"


@implementation WordLabel

@synthesize strokeColor=m_strokeColor;
@synthesize renderingColor=m_renderingColor;
@synthesize verticalAlignment = m_verticalAlignment;
//@synthesize frameCurr=frameCurr;


- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    m_verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (UIColor *)getStrokeColor
{
	return m_strokeColor;
}
- (void)setStrokeColor:(UIColor *)color {
	if (m_strokeColor) {
		[m_strokeColor release];
	}
	m_strokeColor=[color retain];
    [self setNeedsDisplay];
}
- (UIColor *)getRenderingColor
{
	return m_strokeColor;
}
- (void)setRenderingColor:(UIColor *)color {
	if (m_renderingColor) {
		[m_renderingColor release];
	}
	m_renderingColor=[color retain];
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentTop;
		m_verticalAlignment=VerticalAlignmentTop;
    }
	self.strokeColor=[UIColor clearColor];
	self.renderingColor=[UIColor clearColor];
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect {
	rect=[self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
	CGSize shadowOffset = self.shadowOffset;
	
	UIColor *textColor = self.textColor;
	
	//描边颜色
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetCharacterSpacing (c, 10);
	
	CGRect tmpRect=rect;
#ifdef TARGET_IPAD	
	CGContextSetLineWidth(c, 4);
	tmpRect.origin.y+=1;
#else
	CGContextSetLineWidth(c, 4);
	tmpRect.origin.y+=1;
#endif	
	CGContextSetMiterLimit(c ,1.0f);
	CGContextSetTextDrawingMode(c, kCGTextStroke);
	self.textColor = m_strokeColor;
	
	[super drawTextInRect:tmpRect];
	
	//字体颜色
	CGContextSetTextDrawingMode(c, kCGTextFill);
		self.textColor = textColor;
#ifdef TARGET_IPAD	
	self.shadowOffset = CGSizeMake(0, 6);
#else
	self.shadowOffset = CGSizeMake(0, 4);
#endif
	[super drawTextInRect:rect];
	self.shadowOffset = shadowOffset;
	//背景渲染
	
    CGContextSetShadowWithColor(c,CGSizeMake(0.5, -0.5), 38,self.renderingColor.CGColor);
	[super drawTextInRect:rect];
} 


-(CGFloat)adjustsWordsHeight
{
	CGRect frame =self.frame;
	if (frame.size.width<=0) {
		return -1;
	}

	CGSize fitSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, 10000) lineBreakMode:self.lineBreakMode];

	frame.size.height = fitSize.height;
	self.frame=frame;
	
	return fitSize.height;
}

- (void)dealloc {
	self.strokeColor=nil;
	self.renderingColor=nil;
    [super dealloc];
}



@end
