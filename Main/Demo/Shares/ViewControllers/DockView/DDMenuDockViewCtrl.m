//
//  DDMenuDockViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "DDMenuDockViewCtrl.h"
#import "DockViewDefines.h"

@interface DDMenuDockViewCtrl ()

@end

@implementation DDMenuDockViewCtrl

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
    
    _leftCtrl = [[LeftViewController alloc] init];
    _rightCtrl = [[RightViewController alloc] init];
    _centerCtrl = [[CenterViewController alloc] init];
    _navCtrl = [[UINavigationController alloc] initWithRootViewController:_centerCtrl];
    
    self.rootViewController = _navCtrl;
    self.leftViewController = _leftCtrl;
    self.rightViewController = _rightCtrl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissActionNotification:) name:kDismissActionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftNotification:) name:kShowLeftNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRightNotification:) name:kShowRightNotification object:nil];
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
    if (self.leftViewController) {
        [self showLeftController:YES];
        [_leftCtrl hideAllButton];
    }
}

- (void)showRightNotification:(NSNotification *)notification
{
    if (self.rightViewController) {
        [self showRightController:YES];
        [_rightCtrl hideButtons];
    }
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
