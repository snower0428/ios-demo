// -*- Mode: ObjC; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OverlayView.h"

static const CGFloat kPadding = 10;
static const CGFloat kLicenseButtonPadding = 10;

@interface OverlayView()
@property (nonatomic,assign) UIButton *torchButton;
@property (nonatomic,assign) UIButton *licenseButton;
@property (nonatomic,retain) UILabel *instructionsLabel;

@end


@implementation OverlayView

@synthesize delegate, oneDMode;
@synthesize points = _points;
@synthesize torchButton;
@synthesize licenseButton;
@synthesize cropRect;
@synthesize instructionsLabel;
@synthesize displayedMessage;
@synthesize cancelButtonTitle;
@synthesize cancelEnabled;
@synthesize cancelButton;
@synthesize canClickCancelBtn;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled {
  return [self initWithFrame:theFrame cancelEnabled:isCancelEnabled oneDMode:isOneDModeEnabled showLicense:YES];
}

- (id) initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled showLicense:(BOOL)showLicenseButton {
  self = [super initWithFrame:theFrame];
  if( self ) {
	canClickCancelBtn = NO;
    CGFloat rectSize = self.frame.size.width - kPadding * 2;
    if (!oneDMode) {
      cropRect = CGRectMake(kPadding, (self.frame.size.height - rectSize) / 2, rectSize, rectSize);
    } else {
      CGFloat rectSize2 = self.frame.size.height - kPadding * 2;
      cropRect = CGRectMake(kPadding, kPadding, rectSize, rectSize2);		
    }

    self.backgroundColor = [UIColor clearColor];
    self.oneDMode = isOneDModeEnabled;
	  
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
      UIImage *borderImage = [[UIImageManager shareInstance] imageWithFileName:@"TwoDimension/td_bottomBG.png"];
	imageView.image = [borderImage stretchableImageWithLeftCapWidth:1 topCapHeight:25];
	[self addSubview:imageView];
	[imageView release];
      
    /*if (showLicenseButton) {
        self.licenseButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        
        CGRect lbFrame = [licenseButton frame];
        lbFrame.origin.x = self.frame.size.width - licenseButton.frame.size.width - kLicenseButtonPadding;
        lbFrame.origin.y = self.frame.size.height - licenseButton.frame.size.height - kLicenseButtonPadding;
        [licenseButton setFrame:lbFrame];
        [licenseButton addTarget:self action:@selector(showLicenseAlert:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:licenseButton];
    }*/
    self.cancelEnabled = isCancelEnabled;

    if (self.cancelEnabled) {
      UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
      self.cancelButton = butt;
	  [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      if ([self.cancelButtonTitle length] > 0 ) {
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
      } else {
        [cancelButton setTitle:_(@"Cancel") forState:UIControlStateNormal];
      }
        
        UIImage *image = [[UIImageManager shareInstance] imageWithFileName:@"TwoDimension/td_cancelBtn.png"];
	  [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
      [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:cancelButton];
		//added by ygf
		if (cancelButton) {
			if (oneDMode) {
				//xuanzhuan
				[cancelButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
				[cancelButton setFrame:CGRectMake(20, 175, 45, 130)];
			} else {
				CGSize theSize = CGSizeMake(96, 33);
				CGRect theRect = CGRectMake(SCREEN_WIDTH-96-30, SCREEN_HEIGHT-8-33, theSize.width, theSize.height);
				[cancelButton setFrame:theRect];
			}
		}
    } 
  }
  return self;
}

- (void)cancel:(id)sender {
	// call delegate to cancel this scanner
	if (!canClickCancelBtn) {
		return;
	}
	if (delegate != nil) {
		[delegate cancelled];
	}
}

/*- (void)showLicenseAlert:(id)sender {
    NSString *title =
        NSLocalizedStringWithDefaultValue(@"OverlayView license alert title", nil, [NSBundle mainBundle], @"License", @"License");

    NSString *message =
        NSLocalizedStringWithDefaultValue(@"OverlayView license alert message", nil, [NSBundle mainBundle], @"Scanning functionality provided by ZXing library, licensed under Apache 2.0 license.", @"Scanning functionality provided by ZXing library, licensed under Apache 2.0 license.");

    NSString *cancelTitle =
        NSLocalizedStringWithDefaultValue(@"OverlayView license alert cancel title", nil, [NSBundle mainBundle], @"OK", @"OK");

    NSString *viewTitle =
        NSLocalizedStringWithDefaultValue(@"OverlayView license alert view title", nil, [NSBundle mainBundle], @"View License", @"View License");

    UIAlertView *av =
        [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:viewTitle, nil];

    [av show];
    [self retain]; // For the delegate callback ...
    [av release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == [alertView firstOtherButtonIndex]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apache.org/licenses/LICENSE-2.0.html"]];
  }
  [self release];
}*/

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	[_points release];
  [instructionsLabel release];
  [displayedMessage release];
  [cancelButtonTitle release],
	[super dealloc];
}


- (void)drawRect:(CGRect)rect inContext:(CGContextRef)context {
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
	CGContextStrokePath(context);
	
}

- (CGPoint)map:(CGPoint)point {
    CGPoint center;
    center.x = cropRect.size.width/2;
    center.y = cropRect.size.height/2;
    float x = point.x - center.x;
    float y = point.y - center.y;
    int rotation = 90;
    switch(rotation) {
    case 0:
        point.x = x;
        point.y = y;
        break;
    case 90:
        point.x = -y;
        point.y = x;
        break;
    case 180:
        point.x = -x;
        point.y = -y;
        break;
    case 270:
        point.x = y;
        point.y = -x;
        break;
    }
    point.x = point.x + center.x;
    point.y = point.y + center.y;
    return point;
}

#define kTextMargin 10

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
  if (displayedMessage == nil) {
    self.displayedMessage = _(@"Place a barcode inside the viewfinder rectangle to scan it");
  }
	NSInteger offsetY = 0;
	if (iPhone5) {
		offsetY = 44;
	}
	CGContextRef c = UIGraphicsGetCurrentContext();
	
#if 1
	CGFloat blackFrame[4] = {0.0f, 0.0f, 0.0f, 0.5f};//modify by ygf
	CGContextSetStrokeColor(c, blackFrame);
	CGContextSetFillColor(c, blackFrame);
	CGRect blackBGRect0 = CGRectMake(0, 0, SCREEN_WIDTH, 122+offsetY);//382
	CGContextFillRect(c, blackBGRect0);
	CGRect blackBGRect1 = CGRectMake(0, 122+offsetY, 49, 225);//382
	CGContextFillRect(c, blackBGRect1);
	CGRect blackBGRect2 = CGRectMake(0, 347+offsetY, SCREEN_WIDTH, SCREEN_HEIGHT - 122-225+50);//382
	CGContextFillRect(c, blackBGRect2);
	CGRect blackBGRect3 = CGRectMake(270, 122+offsetY, 50, 225);//382
	CGContextFillRect(c, blackBGRect3);
	
	/*CGFloat whiteFrame[4] = {1.0f, 1.0f, 1.0f, 0.0f};//modify by ygf
	CGContextSetStrokeColor(c, whiteFrame);
	CGContextSetFillColor(c, whiteFrame);
	CGRect whiteBGRect = CGRectMake(49, 123, 225, 225);
	CGContextFillRect(c, whiteBGRect);*/
	
	CGFloat greenFrame[4] = {0.04f, 0.965f, 0.05f, 1.0f};//modify by ygf
	CGContextSetStrokeColor(c, greenFrame);
	CGContextSetFillColor(c, greenFrame);
	CGRect Line0 = CGRectMake(47, 119+offsetY, 4, 24);
	CGContextFillRect(c, Line0);
	CGRect Line1 = CGRectMake(47, 119+offsetY, 24, 4);
	CGContextFillRect(c, Line1);
	CGRect Line2 = CGRectMake(248, 119+offsetY, 24, 4);
	CGContextFillRect(c, Line2);
	CGRect Line3 = CGRectMake(268, 119+offsetY, 4, 24);
	CGContextFillRect(c, Line3);
	CGRect Line4 = CGRectMake(47, 326+offsetY, 4, 24);
	CGContextFillRect(c, Line4);
	CGRect Line5 = CGRectMake(47, 346+offsetY, 24, 4);
	CGContextFillRect(c, Line5);
	CGRect Line6 = CGRectMake(248, 346+offsetY, 24, 4);
	CGContextFillRect(c, Line6);
	CGRect Line7 = CGRectMake(268, 326+offsetY, 4, 24);
	CGContextFillRect(c, Line7);
	
	CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};
	CGContextSetStrokeColor(c, white);
	CGContextSetFillColor(c, white);
#else
	CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};
	CGContextSetStrokeColor(c, white);
	CGContextSetFillColor(c, white);	
	
	[self drawRect:cropRect inContext:c];
#endif
	
  //	CGContextSetStrokeColor(c, white);
	//	CGContextSetStrokeColor(c, white);
	CGContextSaveGState(c);
	if (oneDMode) {
        NSString *text = NSLocalizedStringWithDefaultValue(@"OverlayView 1d instructions", nil, [NSBundle mainBundle], @"Place a red line over the bar code to be scanned.", @"Place a red line over the bar code to be scanned.");
        UIFont *helvetica15 = [UIFont fontWithName:@"Helvetica" size:15];
        CGSize textSize = [text sizeWithFont:helvetica15];
        
		CGContextRotateCTM(c, M_PI/2);
        // Invert height and width, because we are rotated.
        CGPoint textPoint = CGPointMake(self.bounds.size.height / 2 - textSize.width / 2, self.bounds.size.width * -1.0f + 20.0f);
        [text drawAtPoint:textPoint withFont:helvetica15];
	}
	else {
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize constraint = CGSizeMake(rect.size.width  - 2 * kTextMargin, cropRect.origin.y);
    CGSize displaySize = [self.displayedMessage sizeWithFont:font constrainedToSize:constraint];
    //CGRect displayRect = CGRectMake((rect.size.width - displaySize.width) / 2 , cropRect.origin.y - displaySize.height, displaySize.width, displaySize.height);
	CGRect displayRect = CGRectMake(49,68+offsetY,displaySize.width,displaySize.height);//modify by ygf
	[self.displayedMessage drawInRect:displayRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	}
	CGContextRestoreGState(c);
	int offset = rect.size.width / 2;
	if (oneDMode) {
		CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, red);
		CGContextSetFillColor(c, red);
		CGContextBeginPath(c);
		//		CGContextMoveToPoint(c, rect.origin.x + kPadding, rect.origin.y + offset);
		//		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - kPadding, rect.origin.y + offset);
		CGContextMoveToPoint(c, rect.origin.x + offset, rect.origin.y + kPadding);
		CGContextAddLineToPoint(c, rect.origin.x + offset, rect.origin.y + rect.size.height - kPadding);
		CGContextStrokePath(c);
	}
	if( nil != _points ) {
		CGFloat blue[4] = {0.0f, 1.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, blue);
		CGContextSetFillColor(c, blue);
		if (oneDMode) {
			CGPoint val1 = [self map:[[_points objectAtIndex:0] CGPointValue]];
			CGPoint val2 = [self map:[[_points objectAtIndex:1] CGPointValue]];
			CGContextMoveToPoint(c, offset, val1.x);
			CGContextAddLineToPoint(c, offset, val2.x);
			CGContextStrokePath(c);
		}
		else {
			CGRect smallSquare = CGRectMake(0, 0, 10, 10);
			for( NSValue* value in _points ) {
				CGPoint point = [self map:[value CGPointValue]];
				smallSquare.origin = CGPointMake(
                                         cropRect.origin.x + point.x - smallSquare.size.width / 2,
                                         cropRect.origin.y + point.y - smallSquare.size.height / 2);
				[self drawRect:smallSquare inContext:c];
			}
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setPoints:(NSMutableArray*)pnts {
    [pnts retain];
    [_points release];
    _points = pnts;
	
    if (pnts != nil) {
		//modify by ygf
        //self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    }
    [self setNeedsDisplay];
}

- (void) setPoint:(CGPoint)point {
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
    }
    if (_points.count > 3) {
        [_points removeObjectAtIndex:0];
    }
    [_points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}


- (void)layoutSubviews {
  [super layoutSubviews];
	/*
  if (cancelButton) {
    if (oneDMode) {
      [cancelButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
      [cancelButton setFrame:CGRectMake(20, 175, 45, 130)];
    } else {
      CGSize theSize = CGSizeMake(96, 33);
      //CGRect rect = self.frame;
      //CGRect theRect = CGRectMake((rect.size.width - theSize.width) / 2, cropRect.origin.y + cropRect.size.height + 20, theSize.width, theSize.height);
	  CGRect theRect = CGRectMake(SCREEN_WIDTH-96-30, SCREEN_HEIGHT-8-33, theSize.width, theSize.height);
      [cancelButton setFrame:theRect];
    }
  }*/
}

@end
