//
//  UIDatePickerCtrl.m
//  Demo
//
//  Created by lei hui on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIDatePickerCtrl.h"

#define LABEL_DATE_TAG      1000

@implementation UIDatePickerCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        // Init
        _arrayYear = [[NSMutableArray alloc] init];
        _arrayMonth = [[NSMutableArray alloc] init];
        _arrayDay = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showDatePicker:(UIView *)FParentView
{
    [FParentView addSubview:self.view];
}

- (UIButton *)customButtonWith:(CGRect)frame title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = ARIAL_FONT(15);
    btn.layer.cornerRadius = 5;
    btn.layer.shadowOffset = CGSizeMake(2, 2);
    btn.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
    
    return btn;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.view.frame = CGRectMake(0, 0, 320, APP_HEIGHT);
    
    //背景
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT-235, 320, 240)];
    bg.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:221.0/255.0 blue:226.0/255.0 alpha:1.0];
    bg.layer.cornerRadius = 5;
    bg.layer.shadowOffset = CGSizeMake(2, 2);
    bg.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    bg.layer.borderWidth = 1.0;
    bg.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    [self.view addSubview:bg];
    [bg release];
    
    __block __typeof(self) _self = self;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320, APP_HEIGHT);
    btn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btn];
    [btn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void) {
        [_self.view removeFromSuperview];
    }];
    
    //按钮：确定，今日，取消
    UIButton *btnOK = [self customButtonWith:CGRectMake(11, 240, 96, 36) title:@"确定"];
    UIButton *btnToday = [self customButtonWith:CGRectMake(113, 240, 96, 36) title:@"今日"];
    UIButton *btnCancel = [self customButtonWith:CGRectMake(215, 240, 96, 36) title:@"取消"];
    [self.view addSubview:btnOK];
    [self.view addSubview:btnToday];
    [self.view addSubview:btnCancel];
    
    //分隔线
    UIImageView *seperator = [[UIImageView alloc] initWithFrame:CGRectMake(10, 285, 300, 1)];
    seperator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    [self.view addSubview:seperator];
    
    //时钟
    UIImageView *clock = [UIImageView imageViewWithFile:@"date_picker_clock.png" atPostion:CGPointMake(10, 295)];
    [self.view addSubview:clock];
    
    UILabel *labelDate = [UILabel labelWithName:@"2013年1月29日" 
                                           font:ARIAL_FONT(18) 
                                          frame:CGRectMake(40,296,180,22)];
    labelDate.tag = LABEL_DATE_TAG;
    [self.view addSubview:labelDate];
    
    //按钮：公历，农历
    UIButton *btnSolar = [self customButtonWith:CGRectMake(225, 290, 40, 36) title:@"公历"];
    UIButton *btnLunar = [self customButtonWith:CGRectMake(270, 290, 40, 36) title:@"农历"];
    [self.view addSubview:btnSolar];
    [self.view addSubview:btnLunar];
    
    //年
    UIView *yearBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 98, 98)];
    UIImageView *yearBg = [UIImageView imageViewWithFile:@"date_picker_year_bg.png"];
    yearBg.frame = CGRectMake(0, 0, 98, 98);
    [yearBgView addSubview:yearBg];
    
    _tableViewYear = [[UITableView alloc] initWithFrame:CGRectMake(25, 335, 98, 98) style:UITableViewStylePlain];
    _tableViewYear.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewYear.backgroundView = yearBgView;
    [self.view addSubview:_tableViewYear];
    [_tableViewYear release];
    
    [yearBgView release];
    
    //月
    UIView *monthBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 98)];
    UIImageView *monthBg = [UIImageView imageViewWithFile:@"date_picker_month_bg.png"];
    monthBg.frame = CGRectMake(0, 0, 75, 98);
    [monthBgView addSubview:monthBg];
    
    _tableViewMonth = [[UITableView alloc] initWithFrame:CGRectMake(135, 335, 75, 98) style:UITableViewStylePlain];
    _tableViewMonth.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewMonth.backgroundView = monthBgView;
    [self.view addSubview:_tableViewMonth];
    [_tableViewMonth release];
    
    [monthBgView release];
    
    //日
    UIView *dayBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 98)];
    UIImageView *dayBg = [UIImageView imageViewWithFile:@"date_picker_month_bg.png"];
    dayBg.frame = CGRectMake(0, 0, 75, 98);
    [dayBgView addSubview:dayBg];
    
    _tableViewDay = [[UITableView alloc] initWithFrame:CGRectMake(218, 335, 75, 98) style:UITableViewStylePlain];
    _tableViewDay.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewDay.backgroundView = dayBgView;
    [self.view addSubview:_tableViewDay];
    [_tableViewDay release];
    
    [dayBgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dealloc

- (void)dealloc
{
    [_tableViewYear release];
    [_tableViewMonth release];
    [_tableViewDay release];
    
    [_arrayYear release];
    [_arrayMonth release];
    [_arrayDay release];
    
    [super dealloc];
}

@end
