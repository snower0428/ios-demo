//
//  DDMenuDockViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "DDMenuDockViewCtrl.h"
#import "CenterViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

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
    
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CenterViewController alloc] init]];
    self.leftViewController = [[LeftViewController alloc] init];
    self.rightViewController = [[RightViewController alloc] init];
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

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
