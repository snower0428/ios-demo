//
//  ViewController.m
//  CommDemo
//
//  Created by leihui on 12-10-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "CommenCtrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    _arrayName = [[NSArray alloc] initWithObjects:
                  @"TableView",
                  @"CommenView",
                  @"DockView",
                  @"Animations",
                  @"BabyInfo",
                  @"ASIHttpRequest",
                  @"KalCalendar",
                  @"DatePicker",
                  @"SDWebImage",
                  @"GCD",
                  @"Emoji",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            NSStringFromClass([TableViewCtrl class]),
                            NSStringFromClass([CommenViewCtrl class]),
                            NSStringFromClass([DockViewCtrl class]),
                            NSStringFromClass([AnimationsViewCtrl class]),
                            NSStringFromClass([BabySelectViewController class]),
                            NSStringFromClass([ASIHttpDemoViewCtrl class]),
                            NSStringFromClass([KalViewController class]),
                            NSStringFromClass([DatePickerDemoViewCtrl class]),
                            NSStringFromClass([SDWebImageViewCtrl class]),
                            NSStringFromClass([GCDDemoViewCtrl class]),
                            NSStringFromClass([EmojiViewCtrl class]),
                            nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

#pragma mark - dealloc

- (void)dealloc
{
    [_arrayName release];
    [_arrayViewController release];
    
    [super dealloc];
}

@end
