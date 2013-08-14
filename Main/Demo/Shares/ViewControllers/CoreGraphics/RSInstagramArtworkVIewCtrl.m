//
//  RSInstagramArtworkVIewCtrl.m
//  Demo
//
//  Created by lei hui on 13-7-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSInstagramArtworkVIewCtrl.h"
#import "RSInstagramArtworkView.h"

@interface RSInstagramArtworkVIewCtrl ()
{
    RSInstagramArtworkView  *_instagramArtworkView;
}

@end

@implementation RSInstagramArtworkVIewCtrl

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
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
	
    _instagramArtworkView = [[RSInstagramArtworkView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 400.0)];
    // always center
    _instagramArtworkView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    // clear background
    _instagramArtworkView.opaque = NO;
	
	[self.view addSubview:_instagramArtworkView];
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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// `superview` (window) is now set and we can convert the center to local coordinates for the subview.
//	_instagramArtworkView.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dealloc

- (void)dealloc
{
    [_instagramArtworkView release];
    
    [super dealloc];
}

@end
