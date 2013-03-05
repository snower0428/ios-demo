//
//  CMPopTipViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-2-4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CMPopTipViewCtrl.h"

@implementation CMPopTipViewCtrl

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

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissAllPopTipViews
{
	while ([_visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = [_visiblePopTipViews objectAtIndex:0];
		[popTipView dismissAnimated:YES];
		[_visiblePopTipViews removeObjectAtIndex:0];
	}
}

- (void)buttonAction:(id)sender
{
    [self dismissAllPopTipViews];
	
	if (sender == _currentPopTipViewTarget) {
		// Dismiss the popTipView and that is all
		_currentPopTipViewTarget = nil;
	}
    else {
		NSString *contentMessage = nil;
		UIView *contentView = nil;
		NSNumber *key = [NSNumber numberWithInt:[(UIView *)sender tag]];
		id content = [_contents objectForKey:key];
		if ([content isKindOfClass:[UIView class]]) {
			contentView = content;
		}
		else if ([content isKindOfClass:[NSString class]]) {
			contentMessage = content;
		}
		else {
			contentMessage = @"A CMPopTipView can automatically point to any view or bar button item.";
		}
		NSArray *colorScheme = [_colorSchemes objectAtIndex:foo4random()*[_colorSchemes count]];
		UIColor *backgroundColor = [colorScheme objectAtIndex:0];
		UIColor *textColor = [colorScheme objectAtIndex:1];
		
		NSString *title = [_titles objectForKey:key];
		
		CMPopTipView *popTipView;
		if (contentView) {
			popTipView = [[[CMPopTipView alloc] initWithCustomView:contentView] autorelease];
		}
		else if (title) {
			popTipView = [[[CMPopTipView alloc] initWithTitle:title message:contentMessage] autorelease];
		}
		else {
			popTipView = [[[CMPopTipView alloc] initWithMessage:contentMessage] autorelease];
		}
		popTipView.delegate = self;
		//popTipView.disableTapToDismiss = YES;
		//popTipView.preferredPointDirection = PointDirectionUp;
		if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
			popTipView.backgroundColor = backgroundColor;
		}
		if (textColor && ![textColor isEqual:[NSNull null]]) {
			popTipView.textColor = textColor;
		}
        
        popTipView.animation = arc4random() % 2;
		
		popTipView.dismissTapAnywhere = YES;
        [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
        
		if ([sender isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)sender;
			[popTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
		}
		
		[_visiblePopTipViews addObject:popTipView];
		_currentPopTipViewTarget = sender;
	}
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    // Navigation
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    leftBarButtonItem.tag = 21;
    [leftBarButtonItem release];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    rightBarButtonItem.tag = 22;
    [rightBarButtonItem release];
    
    // ToolBar
    NSMutableArray *toolBarbuttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"ToolBar LHS" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonAction:)];
    [toolBarbuttons addObject:leftItem];
    leftItem.tag = 31;
    [leftItem release];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarbuttons addObject:flexibleItem];
    [flexibleItem release];
    
    UIBarButtonItem *midItem = [[UIBarButtonItem alloc] initWithTitle:@"ToolBar Mid" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonAction:)];
    [toolBarbuttons addObject:midItem];
    midItem.tag = 32;
    [midItem release];
    
    flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarbuttons addObject:flexibleItem];
    [flexibleItem release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"ToolBar RHS" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonAction:)];
    [toolBarbuttons addObject:rightItem];
    rightItem.tag = 33;
    [rightItem release];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, APP_VIEW_HEIGH - TOOLBAR_HEIGHT, 320, TOOLBAR_HEIGHT)];
    [toolBar setItems:toolBarbuttons animated:NO];
    [self.view addSubview:toolBar];
    [toolBar release];
    
    [toolBarbuttons release];
    
    // Button
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0, 0, 88, 35);
    [button1 setTitle:@"Button 1" forState:UIControlStateNormal];
    button1.tag = 11;
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(212, 30, 88, 35);
    [button2 setTitle:@"Button 2" forState:UIControlStateNormal];
    button2.tag = 12;
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.frame = CGRectMake(95, 80, 130, 35);
    [button3 setTitle:@"Button 3" forState:UIControlStateNormal];
    button3.tag = 13;
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.frame = CGRectMake(95, 250, 130, 35);
    [button4 setTitle:@"Button 4" forState:UIControlStateNormal];
    button4.tag = 14;
    [self.view addSubview:button4];
    [button4 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button5.frame = CGRectMake(20, 300, 88, 35);
    [button5 setTitle:@"Button 5" forState:UIControlStateNormal];
    button5.tag = 15;
    [self.view addSubview:button5];
    [button5 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button6.frame = CGRectMake(232, 337, 88, 35);
    [button6 setTitle:@"Button 6" forState:UIControlStateNormal];
    button6.tag = 16;
    [self.view addSubview:button6];
    [button6 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [UILabel labelWithName:@"Tap any button to see CMPopTipViews in action." 
                                       font:ARIAL_FONT(17) 
                                      frame:CGRectMake(37, 160, 246, 50) 
                                      color:[UIColor whiteColor] 
                                  alignment:UITextAlignmentCenter];
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    [self.view addSubview:label];
    
    // 返回
    __block __typeof(self) _self = self;
    UIButton *btnReturn = [[UIButton alloc] initWithFrame:label.frame];
    [btnReturn setTitle:@"Back" forState:UIControlStateNormal];
    [btnReturn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnReturn.titleLabel.font = ARIAL_FONT(40);
    btnReturn.alpha = 0.3;
    [self.view addSubview:btnReturn];
    [btnReturn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
#if TEST_POP_VIEW
        // Test
        CMPopTipView *popTipView = [[[CMPopTipView alloc] initWithMessage:@"Just for test..."] autorelease];
        popTipView.dismissTapAnywhere = YES;
        popTipView.animation = 1;
        [popTipView autoDismissAnimated:YES atTimeInterval:2.0];
        [popTipView presentPointingAtView:btnReturn inView:self.view animated:YES];
#else
        [_self onBack];
#endif
    }];
    [btnReturn release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_visiblePopTipViews = [[NSMutableArray array] retain];
	
	_contents = [[NSDictionary dictionaryWithObjectsAndKeys:
                 // Rounded rect buttons
                 @"A CMPopTipView will automatically position itself within the container view.", [NSNumber numberWithInt:11],
                 @"A CMPopTipView will automatically orient itself above or below the target view based on the available space.", [NSNumber numberWithInt:12],
                 @"A CMPopTipView always tries to point at the center of the target view.", [NSNumber numberWithInt:13],
                 @"A CMPopTipView can point to any UIView subclass.", [NSNumber numberWithInt:14],
                 @"A CMPopTipView will automatically size itself to fit the text message.", [NSNumber numberWithInt:15],
                 [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"love.png"]] autorelease], [NSNumber numberWithInt:16],	// content can be a UIView
                 // Nav bar buttons
                 @"This CMPopTipView is pointing at a leftBarButtonItem of a navigationItem.", [NSNumber numberWithInt:21],
                 @"Two popup animations are provided: slide and pop. Tap other buttons to see them both.", [NSNumber numberWithInt:22],
                 // Toolbar buttons
                 @"CMPopTipView will automatically point at buttons either above or below the containing view.", [NSNumber numberWithInt:31],
                 @"The arrow is automatically positioned to point to the center of the target button.", [NSNumber numberWithInt:32],
                 @"CMPopTipView knows how to point automatically to UIBarButtonItems in both nav bars and tool bars.", [NSNumber numberWithInt:33],
                 nil] retain];
	_titles = [[NSDictionary dictionaryWithObjectsAndKeys:
               @"Title", [NSNumber numberWithInt:14],
               @"Auto Orientation", [NSNumber numberWithInt:12],
               nil] retain];
	
	// Array of (backgroundColor, textColor) pairs.
	// NSNull for either means leave as default.
	// A color scheme will be picked randomly per CMPopTipView.
	_colorSchemes = [[NSArray arrayWithObjects:
                     [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
                     [NSArray arrayWithObjects:[UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0], [NSNull null], nil],
                     [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
                     [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
                     [NSArray arrayWithObjects:[UIColor orangeColor], [UIColor blueColor], nil],
                     [NSArray arrayWithObjects:[UIColor colorWithRed:220.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0], [NSNull null], nil],
                     nil] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	for (CMPopTipView *popTipView in _visiblePopTipViews) {
		id targetObject = popTipView.targetObject;
		[popTipView dismissAnimated:NO];
		
		if ([targetObject isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)targetObject;
			[popTipView presentPointingAtView:button inView:self.view animated:NO];
		}
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
		}
	}
}

#pragma mark -
#pragma mark CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
	[_visiblePopTipViews removeObject:popTipView];
	_currentPopTipViewTarget = nil;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_visiblePopTipViews release];
    [_contents release];
    [_titles release];
    [_colorSchemes release];
    
    [super dealloc];
}

@end
