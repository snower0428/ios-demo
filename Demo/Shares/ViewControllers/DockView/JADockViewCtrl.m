//
//  JADockViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "JADockViewCtrl.h"
#import "CenterViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

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
    self.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[CenterViewController alloc] init]];
    self.leftPanel = [[LeftViewController alloc] init];
    self.rightPanel = [[RightViewController alloc] init];
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
