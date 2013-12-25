//
//  AngryBirdViewController.m
//  CoreGraphicsDemo
//
//  Created by leihui on 13-12-18.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "AngryBirdViewController.h"
#import "AngryBirdBackgroundView.h"
#import "AngryBirdView.h"

@interface AngryBirdViewController ()

@end

@implementation AngryBirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AngryBirdBackgroundView *backgroundView = [[AngryBirdBackgroundView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopShift, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    CGFloat width = 320.f;
    AngryBirdView *view = [[AngryBirdView alloc] initWithFrame:CGRectMake(0, 100, width, width)];
    view.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:view];
    [view release];
    
    scrollView.contentSize = CGSizeMake(width, scrollView.frame.size.height+200);
    
    [scrollView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
