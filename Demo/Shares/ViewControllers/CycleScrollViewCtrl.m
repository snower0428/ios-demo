//
//  CycleScrollViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-1.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CycleScrollViewCtrl.h"

#define PAGE_COUNT      5

@implementation CycleScrollViewCtrl

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
    
    [self addBackButton];
    
    PHCycleScrollView *cycleScrollView = [[PHCycleScrollView alloc] initWithFrame:self.view.bounds];
    cycleScrollView.dataSource = self;
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
    [cycleScrollView release];
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

#pragma mark - PHCycleScrollViewDataSource, PHCycleScrollViewDelegate

- (NSInteger)numberOfPages
{
    return PAGE_COUNT;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UILabel *label = [[[UILabel alloc] initWithFrame:self.view.bounds] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%d", index];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont boldSystemFontOfSize:100];
    label.textAlignment = UITextAlignmentCenter;
    
    return label;
}

- (void)didClickPage:(PHCycleScrollView *)csView atIndex:(NSInteger)index
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" 
                                                        message:[NSString stringWithFormat:@"You are click in %d page!", index] 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}


#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
