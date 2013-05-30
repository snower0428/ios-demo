//
//  RightViewController.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
    
    self.view.backgroundColor = [UIColor purpleColor];
    _label.text = @"Right Panel";
    
    _btnHideCenter.frame = CGRectMake(self.view.bounds.size.width - 220.0f, 70.0f, 200.0f, 40.0f);
    _btnHideCenter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    _btnShowCenter.frame = _btnHideCenter.frame;
    _btnShowCenter.autoresizingMask = _btnHideCenter.autoresizingMask;
    
    _btnRemoveRightPanel.hidden = YES;
    _btnAddRightPanel.hidden = YES;
    _btnChangeCenterPanel.hidden = YES;
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
