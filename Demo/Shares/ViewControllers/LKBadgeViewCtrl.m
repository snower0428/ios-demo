//
//  LKBadgeViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LKBadgeViewCtrl.h"
#import "LKBadgeView.h"

@implementation LKBadgeViewCtrl

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
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    [view release];
    
    [self addBackButton];
    
    LKBadgeView *badgeView = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 10, 150, 25)];
    badgeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    badgeView.text = @"LKBadgeView";
    [self.view addSubview:badgeView];
    [badgeView release];
    
    LKBadgeView *badgeView01 = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 40, 150, 25)];
    badgeView01.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    badgeView01.text = @"1";
    badgeView01.horizontalAlignment = LKBadgeViewHorizontalAlignmentLeft;
    [self.view addSubview:badgeView01];
    [badgeView01 release];
    
    LKBadgeView *badgeView02 = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 70, 150, 25)];
    badgeView02.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    badgeView02.text = @"2";
    badgeView02.horizontalAlignment = LKBadgeViewHorizontalAlignmentCenter;
    [self.view addSubview:badgeView02];
    [badgeView02 release];
    
    LKBadgeView *badgeView03 = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 100, 150, 25)];
    badgeView03.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    badgeView03.text = @"3";
    badgeView03.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
    [self.view addSubview:badgeView03];
    [badgeView03 release];
    
    LKBadgeView *badgeView11 = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 130, 150, 25)];
    badgeView11.text = @"11";
    badgeView11.horizontalAlignment = LKBadgeViewHorizontalAlignmentLeft;
    [self.view addSubview:badgeView11];
    [badgeView11 release];
    
    LKBadgeView *badgeView22 = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 160, 150, 25)];
    badgeView22.text = @"22";
    badgeView22.textColor = [UIColor whiteColor];
    badgeView22.badgeColor = [UIColor blueColor];
    [self.view addSubview:badgeView22];
    [badgeView22 release];
    
    LKBadgeView *badgeView33 = [[LKBadgeView alloc] initWithFrame:CGRectMake(10, 190, 150, 25)];
    badgeView33.text = @"33";
    badgeView33.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
    badgeView33.outline = YES;
    badgeView33.outlineColor = [UIColor blueColor];
    badgeView33.outlineWidth = 2.0;
    [self.view addSubview:badgeView33];
    [badgeView33 release];
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
