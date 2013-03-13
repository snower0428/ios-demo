//
//  FlipEffectsViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-13.
//
//

#import "FlipEffectsViewCtrl.h"

@interface FlipEffectsViewCtrl ()

@end

@implementation FlipEffectsViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Flip"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    _targetView = [[UILabel alloc] initWithFrame:self.view.bounds];
    _targetView.backgroundColor = [UIColor purpleColor];
    _targetView.font = [UIFont boldSystemFontOfSize:50];
    _targetView.textAlignment = UITextAlignmentCenter;
    
    _pageFlipper = [[PageFlipper alloc] initWithHostView:self.view targetView:_targetView];
    _pageFlipper.delegate = self;
//    [_pageFlipper setFlipDuration:5.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonAction:(id)sender
{
    if (_isFlipping) {
        return;
    }
    _isFlipping = YES;
    [_pageFlipper flip];
}

#pragma mark - delegate

- (void)didFinishPageFlipWithTargetView:(UIView *)targetView wasCloseFlip:(BOOL)closeFlip
{
    _isFlipping = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.backgroundColor = [UIColor blueColor];
    label.font = [UIFont boldSystemFontOfSize:50];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%d", ++_pageIndex];
    
    [_pageFlipper setTargetView:label];
    
    [label release];
    
    NSLog(@"didFinishAnimatingToState:");
}

#pragma mark - dealloc

- (void)dealloc
{
    [_pageFlipper release];
    [_targetView release];
    
    [super dealloc];
}

@end
