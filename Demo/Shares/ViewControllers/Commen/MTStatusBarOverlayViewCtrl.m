//
//  MTStatusBarOverlayViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MTStatusBarOverlayViewCtrl.h"

@implementation MTStatusBarOverlayViewCtrl

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
    
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    overlay.delegate = self;
    overlay.progress = 0.0;
    [overlay postMessage:@"Following @myell0w on Twitter…"];
    overlay.progress = 0.1;
    // ...
    [overlay postMessage:@"Following myell0w on Github…" animated:NO];
    overlay.progress = 0.5;
    // ...
    [overlay postImmediateFinishMessage:@"Following was a good idea!" duration:2.0 animated:YES];
    overlay.progress = 1.0;
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
