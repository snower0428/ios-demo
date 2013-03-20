//
//  LeftViewController.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

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
    view.backgroundColor = [UIColor blueColor];
    self.view = view;
    [view release];
	
    _label = [UILabel labelWithName:@"Left Panel"
                               font:[UIFont boldSystemFontOfSize:20.0f]
                              frame:CGRectMake(0, 0, 320, 30)
                              color:[UIColor whiteColor]
                          alignment:UITextAlignmentCenter];
	[self.view addSubview:_label];
    
    _btnHideCenter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnHideCenter.frame = CGRectMake(20.0f, 70.0f, 200.0f, 40.0f);
    _btnHideCenter.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_btnHideCenter setTitle:@"Hide Center" forState:UIControlStateNormal];
    [_btnHideCenter addTarget:self action:@selector(_hideTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnHideCenter];
    
    _btnShowCenter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnShowCenter.frame = _btnHideCenter.frame;
    _btnShowCenter.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_btnShowCenter setTitle:@"Show Center" forState:UIControlStateNormal];
    [_btnShowCenter addTarget:self action:@selector(_showTapped:) forControlEvents:UIControlEventTouchUpInside];
    _btnShowCenter.hidden = YES;
    [self.view addSubview:_btnShowCenter];
    
    _btnRemoveRightPanel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnRemoveRightPanel.frame = CGRectMake(20.0f, 120.0f, 200.0f, 40.0f);
    _btnRemoveRightPanel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_btnRemoveRightPanel setTitle:@"Remove Right Panel" forState:UIControlStateNormal];
    [_btnRemoveRightPanel addTarget:self action:@selector(_removeRightPanelTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRemoveRightPanel];
    
    _btnAddRightPanel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnAddRightPanel.frame = _btnRemoveRightPanel.frame;
    _btnAddRightPanel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_btnAddRightPanel setTitle:@"Add Right Panel" forState:UIControlStateNormal];
    [_btnAddRightPanel addTarget:self action:@selector(_addRightPanelTapped:) forControlEvents:UIControlEventTouchUpInside];
    _btnAddRightPanel.hidden = YES;
    [self.view addSubview:_btnAddRightPanel];
    
    _btnChangeCenterPanel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnChangeCenterPanel.frame = CGRectMake(20.0f, 170.0f, 200.0f, 40.0f);
    _btnChangeCenterPanel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_btnChangeCenterPanel setTitle:@"Change Center Panel" forState:UIControlStateNormal];
    [_btnChangeCenterPanel addTarget:self action:@selector(_changeCenterPanelTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnChangeCenterPanel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (void)_hideTapped:(id)sender
{
    [self.sidePanelController setCenterPanelHidden:YES animated:YES duration:0.2f];
    _btnHideCenter.hidden = YES;
    _btnShowCenter.hidden = NO;
}

- (void)_showTapped:(id)sender
{
    [self.sidePanelController setCenterPanelHidden:NO animated:YES duration:0.2f];
    _btnHideCenter.hidden = NO;
    _btnShowCenter.hidden = YES;
}

- (void)_removeRightPanelTapped:(id)sender
{
    self.sidePanelController.rightPanel = nil;
    _btnRemoveRightPanel.hidden = YES;
    _btnAddRightPanel.hidden = NO;
}

- (void)_addRightPanelTapped:(id)sender
{
    self.sidePanelController.rightPanel = [[RightViewController alloc] init];
    _btnRemoveRightPanel.hidden = NO;
    _btnAddRightPanel.hidden = YES;
}

- (void)_changeCenterPanelTapped:(id)sender
{
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[CenterViewController alloc] init]];
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
