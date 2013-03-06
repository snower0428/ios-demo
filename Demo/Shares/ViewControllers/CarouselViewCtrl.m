//
//  CarouselViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CarouselViewCtrl.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define NUMBER_OF_ITEMS             (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS     25
#define ITEM_SPACING                210
#define INCLUDE_PLACEHOLDERS        YES

@implementation CarouselViewCtrl

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
    
    //set up data
    _items = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUMBER_OF_ITEMS; i++)
    {
        [_items addObject:[NSNumber numberWithInt:i]];
    }
    
    _wrap = YES;
	
	//create carousel
	_iCarousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	_iCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _iCarousel.type = iCarouselTypeCoverFlow2;
	_iCarousel.delegate = self;
	_iCarousel.dataSource = self;
    
	//add carousel to view
	[self.view addSubview:_iCarousel];
	
	//add top bar
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Wrap: ON" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleWrap)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
	
	//add bottom bar
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	[toolbar setItems:[NSArray arrayWithObjects:
					   [[[UIBarButtonItem alloc] initWithTitle:@"Insert Item" style:UIBarButtonItemStyleBordered target:self action:@selector(insertItem)] autorelease],
					   [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease],
                       [[[UIBarButtonItem alloc] initWithTitle:@"Switch Type" style:UIBarButtonItemStyleBordered target:self action:@selector(switchCarouselType)] autorelease],
                       [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease],
					   [[[UIBarButtonItem alloc] initWithTitle:@"Delete Item" style:UIBarButtonItemStyleBordered target:self action:@selector(removeItem)] autorelease],
					   nil]];
	[self.view addSubview:toolbar];
	[toolbar release];
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

#pragma mark - Action

- (void)switchCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel",  @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", @"Custom", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)toggleWrap
{
    _wrap = !_wrap;
    self.navigationItem.rightBarButtonItem.title = _wrap? @"Wrap: ON": @"Wrap: OFF";
    [_iCarousel reloadData];
}

- (void)insertItem
{
    NSInteger index = _iCarousel.currentItemIndex;
    [_items insertObject:[NSNumber numberWithInt:_iCarousel.numberOfItems] atIndex:index];
    [_iCarousel insertItemAtIndex:index animated:YES];
}

- (void)removeItem
{
    if (_iCarousel.numberOfItems > 0)
    {
        NSInteger index = _iCarousel.currentItemIndex;
        [_iCarousel removeItemAtIndex:index animated:YES];
        [_items removeObjectAtIndex:index];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        
        //carousel can smoothly animate between types
        [UIView beginAnimations:nil context:nil];
        _iCarousel.type = type;
        [UIView commitAnimations];
        
        //update title
        self.navigationItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
		label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [label.font fontWithSize:50];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
	label.text = [[_items objectAtIndex:index] stringValue];
	
	return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
	return INCLUDE_PLACEHOLDERS? 2: 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
		label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [label.font fontWithSize:50.0f];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
	label.text = (index == 0)? @"[": @"]";
	
	return view;
}

#pragma mark - iCarouselDelegate

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _iCarousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return _wrap;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_iCarousel release];
    [_items release];
    
    [super dealloc];
}

@end
