//
//  MKHorizMenuCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MKHorizMenuCtrl.h"

@implementation MKHorizMenuCtrl

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
    
    _items = [[NSArray arrayWithObjects:
              @"Headlines", 
              @"UK", 
              @"International", 
              @"Politics", 
              @"Weather", 
              @"Travel", 
              @"Radio", 
              @"Hollywood", 
              @"Sports", 
              @"Others", nil] retain];
    
    _label = [[UILabel alloc] initWithFrame:self.view.bounds];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blueColor];
    _label.font = [UIFont boldSystemFontOfSize:30];
    _label.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_label];
    
    _horizMenu = [[MKHorizMenu alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
    _horizMenu.showsHorizontalScrollIndicator = NO;
    _horizMenu.showsVerticalScrollIndicator = NO;
    _horizMenu.dataSource = self;
    _horizMenu.itemSelectedDelegate = self;
    [self.view addSubview:_horizMenu];
    
    [_horizMenu reloadData];
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
    
    [_horizMenu setSelectedIndex:5 animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MKHorizMenuDataSource

- (UIImage *)selectedItemImageForMenu:(MKHorizMenu *)tabView
{
    return [[UIImage imageNamed:@"ButtonSelected"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
}

- (UIColor *)backgroundColorForMenu:(MKHorizMenu *)tabView
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar"]];
}

- (int)numberOfItemsForMenu:(MKHorizMenu *)tabView
{
    return [_items count];
}

- (NSString *)horizMenu:(MKHorizMenu *)horizMenu titleForItemAtIndex:(NSUInteger)index
{
    return [_items objectAtIndex:index];
}

#pragma mark - MKHorizMenuDelegate

- (void)horizMenu:(MKHorizMenu *)horizMenu itemSelectedAtIndex:(NSUInteger)index
{
    _label.text = [_items objectAtIndex:index];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_items release];
    [_horizMenu release];
    
    [super dealloc];
}

@end
