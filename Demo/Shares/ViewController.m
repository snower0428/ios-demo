//
//  ViewController.m
//  CommDemo
//
//  Created by leihui on 12-10-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewCtrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    _arrayName = [[NSArray alloc] initWithObjects:
                  @"BabyInfo",
                  @"ASIHttpRequest",
                  @"TableView",
                  @"LivelyTableView",
                  @"KalCalendar",
                  @"DatePicker",
                  @"EGORefreshTableView",
                  @"CMPopTipView",
                  @"CycleScrollView",
                  @"MKHorizMenu",
                  @"JSBadgeView",
                  @"LKBadgeView",
                  @"SDWebImage",
                  @"MTStatusBarOverlay",
                  @"Carousel",
                  @"FlipEffects",
                  @"GCD",
                  @"UIImageCategory",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            NSStringFromClass([BabySelectViewController class]),
                            NSStringFromClass([ASIHttpDemoViewCtrl class]),
                            NSStringFromClass([TableViewDemoCtrl class]),
                            NSStringFromClass([LivelyTableViewCtrl class]),
                            NSStringFromClass([KalViewController class]),
                            NSStringFromClass([DatePickerDemoViewCtrl class]),
                            NSStringFromClass([EGORefreshTableViewCtrl class]),
                            NSStringFromClass([CMPopTipViewCtrl class]),
                            NSStringFromClass([CycleScrollViewCtrl class]),
                            NSStringFromClass([MKHorizMenuViewCtrl class]),
                            NSStringFromClass([JSBadgeViewCtrl class]),
                            NSStringFromClass([LKBadgeViewCtrl class]),
                            NSStringFromClass([SDWebImageViewCtrl class]),
                            NSStringFromClass([MTStatusBarOverlayViewCtrl class]),
                            NSStringFromClass([CarouselViewCtrl class]),
                            NSStringFromClass([FlipEffectsViewCtrl class]),
                            NSStringFromClass([GCDDemoViewCtrl class]),
                            NSStringFromClass([UIImageCategoryViewCtrl class]),
                            nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.title = @"RootViewController";
    
    //BackItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = _(@"Back");
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    NSLog(@"__IPHONE_OS_VERSION_MIN_REQUIRED = %d", __IPHONE_OS_VERSION_MIN_REQUIRED);
    NSLog(@"__IPHONE_OS_VERSION_MAX_ALLOWED = %d", __IPHONE_OS_VERSION_MAX_ALLOWED);
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [_arrayViewController count])
    {
        NSString *strClass = [_arrayViewController objectAtIndex:indexPath.row];
        id object = NSClassFromString(strClass);
        
        UIViewController *ctrl = [[[object alloc] init] autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayName count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < [_arrayName count]) {
        cell.textLabel.text = [_arrayName objectAtIndex:indexPath.row];
    }
    
    return cell;
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
