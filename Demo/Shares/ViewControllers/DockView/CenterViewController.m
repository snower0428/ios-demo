//
//  CenterViewController.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "CenterViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

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
    
    self.title = @"Center Panel";
    
    CGFloat red = (CGFloat)arc4random() / 0x100000000;
    CGFloat green = (CGFloat)arc4random() / 0x100000000;
    CGFloat blue = (CGFloat)arc4random() / 0x100000000;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
    UIImage *image = [JASidePanelController defaultImage];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(leftItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = titleView.bounds;
    [button setTitle:@"Dismiss" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [titleView addSubview:button];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
    [titleView release];
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

- (void)leftItemAction
{
    if (self.sidePanelController.leftPanel) {
        [self.sidePanelController showLeftPanelAnimated:YES];
    }
}

- (void)rightItemAction
{
    if (self.sidePanelController.rightPanel) {
        [self.sidePanelController showRightPanelAnimated:YES];
    }
}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
