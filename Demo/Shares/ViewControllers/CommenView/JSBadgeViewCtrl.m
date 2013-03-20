//
//  JSBadgeViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "JSBadgeViewCtrl.h"
#import "JSBadgeView.h"

#define kNumBadges              100

#define kSquareSideLength       64.0f
#define kSquareCornerRadius     10.0f
#define kMarginBetweenSquares   10.0f

#define kViewBackgroundColor    [UIColor colorWithRed:0.357 green:0.757 blue:0.357 alpha:1]
#define kSquareColor            [UIColor colorWithRed:0.004 green:0.349 blue:0.616 alpha:1]

@implementation JSBadgeViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
//    self.view.backgroundColor = kViewBackgroundColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat viewWidth = self.view.frame.size.width;
    
    NSUInteger numberOfSquaresPerRow = floor(viewWidth / (kSquareSideLength + kMarginBetweenSquares));
    const CGFloat kInitialXOffset = (viewWidth - (numberOfSquaresPerRow * kSquareSideLength)) / (float)numberOfSquaresPerRow;
    CGFloat xOffset = kInitialXOffset;
    
    const CGFloat kInitialYOffset = kInitialXOffset;
    CGFloat yOffset = kInitialYOffset;
    
    CGRect rectangleBounds = CGRectMake(0.0f,
                                        0.0f,
                                        kSquareSideLength,
                                        kSquareSideLength);
    
    CGPathRef rectangleShadowPath = [UIBezierPath bezierPathWithRoundedRect:rectangleBounds 
                                                          byRoundingCorners:UIRectCornerAllCorners 
                                                                cornerRadii:CGSizeMake(kSquareCornerRadius, kSquareCornerRadius)].CGPath;
    
    for (int i = 0; i < kNumBadges; i++)
    {
        UIView *rectangle = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(xOffset,
                                                                                    yOffset,
                                                                                    rectangleBounds.size.width,
                                                                                    rectangleBounds.size.height))];
        rectangle.backgroundColor = kSquareColor;
        rectangle.layer.cornerRadius = kSquareCornerRadius;
        rectangle.layer.shadowColor = [UIColor blackColor].CGColor;
        rectangle.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
        rectangle.layer.shadowOpacity = 0.4;
        rectangle.layer.shadowRadius = 1.0;
        rectangle.layer.shadowPath = rectangleShadowPath;        
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:rectangle alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeText = [NSString stringWithFormat:@"%d", i];
        [badgeView release];
        
        [scrollView addSubview:rectangle];
        [scrollView sendSubviewToBack:rectangle];
        
        xOffset += kSquareSideLength + kMarginBetweenSquares;
        
        if (xOffset > self.view.frame.size.width - kSquareSideLength)
        {
            xOffset = kInitialXOffset;
            yOffset += kSquareSideLength + kMarginBetweenSquares;
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, yOffset);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
