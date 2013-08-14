//
//  LHCoreGraphicsDemoViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-7-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LHCoreGraphicsDemoViewCtrl.h"
#import "LHCoreGraphicsView.h"

@interface LHCoreGraphicsDemoViewCtrl ()
{
    LHCoreGraphicsView      *_coreGraphicsView;
}

@end

@implementation LHCoreGraphicsDemoViewCtrl

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
    
    _coreGraphicsView = [[LHCoreGraphicsView alloc] initWithFrame:CGRectMake(0, 20, 400, 400)];
    _coreGraphicsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _coreGraphicsView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:_coreGraphicsView];
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
    [_coreGraphicsView release];
    
    [super dealloc];
}

@end
