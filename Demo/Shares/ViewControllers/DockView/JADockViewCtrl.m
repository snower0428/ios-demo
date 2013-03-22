//
//  JADockViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "JADockViewCtrl.h"
#import "DockViewDefines.h"

@interface JADockViewCtrl ()

@end

@implementation JADockViewCtrl

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
    [super loadView];
    
    self.title = @"JADockView";
    
    self.shouldDelegateAutorotateToVisiblePanel = NO;
    
    _leftCtrl = [[LeftViewController alloc] init];
    _rightCtrl = [[RightViewController alloc] init];
    _centerCtrl = [[CenterViewController alloc] init];
    _navCtrl = [[UINavigationController alloc] initWithRootViewController:_centerCtrl];
    
    self.centerPanel = _navCtrl;
    self.leftPanel = _leftCtrl;
    self.rightPanel = _rightCtrl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissActionNotification:) name:kDismissActionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftNotification:) name:kShowLeftNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRightNotification:) name:kShowRightNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCenterNotification:) name:kHideCenterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCenterNotification:) name:kShowCenterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeRightNotification:) name:kRemoveRightNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRightNotification:) name:kAddRightNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCenterNotification:) name:kChangeCenterNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Notification

- (void)dismissActionNotification:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLeftNotification:(NSNotification *)notification
{
    if (self.leftPanel) {
        [self showLeftPanelAnimated:YES];
    }
}

- (void)showRightNotification:(NSNotification *)notification
{
    if (self.rightPanel) {
        [self showRightPanelAnimated:YES];
    }
}

- (void)hideCenterNotification:(NSNotification *)notification
{
    [self setCenterPanelHidden:YES animated:YES duration:0.2f];
}

- (void)showCenterNotification:(NSNotification *)notification
{
    [self setCenterPanelHidden:NO animated:YES duration:0.2f];
}

- (void)removeRightNotification:(NSNotification *)notification
{
    self.rightPanel = nil;
}

- (void)addRightNotification:(NSNotification *)notification
{
    self.rightPanel = _rightCtrl;
}

- (void)changeCenterNotification:(NSNotification *)notification
{
    if (_centerCtrl) {
        [_centerCtrl release];
        _centerCtrl = nil;
    }
    if (_navCtrl) {
        [_navCtrl release];
        _navCtrl = nil;
    }
    _centerCtrl = [[CenterViewController alloc] init];
    _navCtrl = [[UINavigationController alloc] initWithRootViewController:_centerCtrl];
    self.centerPanel = _navCtrl;
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_leftCtrl release];
    [_rightCtrl release];
    [_centerCtrl release];
    [_navCtrl release];
    
    [super dealloc];
}

@end
