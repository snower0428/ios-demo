//
//  UIDatePickerCtrl.m
//  Demo
//
//  Created by lei hui on 13-1-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UIDatePickerCtrl.h"
#import "Calendar.h"

#define LABEL_DATE_TAG      1000

//农历日期名
const char *kDayName[] =
{ 
    "*",
    "初一","初二","初三","初四","初五",
    "初六","初七","初八","初九","初十",
	"十一","十二","十三","十四","十五",
	"十六","十七","十八","十九","二十",
	"廿一","廿二","廿三","廿四","廿五",
	"廿六","廿七","廿八","廿九","三十"
};

//农历月份名
const char *kMonName[] = {"*","正月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一","腊月"};

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
        
        _isSolar = YES;
    }
    
    return self;
}

#pragma mark - data

//公历转农历
- (void)SolarToLunar
{
    Calendar calendar;
    DateInfo solar(_solarYear, _solarMonth, _solarDay);
    DateInfo lunar;
    
    lunar = calendar.Lunar(solar);
    
    _lunarYear = lunar.year;
    _lunarMonth = lunar.month;
    _lunarDay = lunar.day;
}

//农历转公历
- (void)LunarToSolar
{
    Calendar calendar;
    DateInfo solar;
    DateInfo lunar(_lunarYear, _lunarMonth, _lunarDay);
    
    solar = calendar.GetGlDate(lunar);
    
    _solarYear = solar.year;
    _solarMonth = solar.month;
    _solarDay = solar.day;		
}

- (void)initYearMonth
{
    if ([_arrayYear count] > 0) {
        [_arrayYear removeAllObjects];
    }
    if ([_arrayMonth count] > 0) {
        [_arrayMonth removeAllObjects];
    }
    
    for (int i = 1950; i <= 2050+4; i++) {
        if ((i < 1950+2) || (i > 2050+2)) {
            [_arrayYear insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1950];
        } else {
            [_arrayYear insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1950];
        }
    }
    for (int i = 1; i <= 12+4; i++) {
        if (i < 3 || i > 12+2) {
            [_arrayMonth insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1];
        } else {
            if (_isSolar) {
                [_arrayMonth insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1];
            } else {
                [_arrayMonth insertObject:[NSString stringWithCString:kMonName[i-2] encoding:NSUTF8StringEncoding] atIndex:i-1];
            }
        }
    }
}

- (void)initDay
{
    if (_isSolar) {
        _tableViewYear.tag = _solarYear - 1950;
        _tableViewMonth.tag = _solarMonth - 1;
        _tableViewDay.tag = _solarDay - 1;
        [self SolarToLunar];
    } else {
        _tableViewYear.tag = _lunarYear - 1950;
        _tableViewMonth.tag = _lunarMonth - 1;
        _tableViewDay.tag = _lunarDay - 1;
        [self LunarToSolar];
    }
    
    Calendar calendar;
    int days = 0;
    
    if (_isSolar) {
        days = calendar.GetMonthDays(_solarYear, _solarMonth);
    } else {
        days = calendar.MonthDays(_lunarYear, _lunarMonth);
    }
    
    if ([_arrayDay count] > 0) {
        [_arrayDay removeAllObjects];
    }
    
    for (int i = 1; i <= days+4; i++) {
        if (i < 3 || i > days+2) {
            [_arrayDay insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1];
        } else {
            if (_isSolar) {
                [_arrayDay insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1];
            } else {
                [_arrayDay insertObject:[NSString stringWithCString:kDayName[i-2] encoding:NSUTF8StringEncoding] atIndex:i-1];
            }
        }
    }
    
	if (_tableViewDay.tag >= days) 
	{
		_tableViewDay.tag = days - 1;
	}
	NSLog(@"_tableViewDay.tag=%d", _tableViewDay.tag);
}

- (void)updateDateInfo
{
    Calendar calendar;
    DateInfo info(_solarYear, _solarMonth, _solarDay);
    NSString *weekDay = [NSString stringWithCString:calendar.DayOfWeekZhou(info) encoding:NSUTF8StringEncoding];
    
    UILabel *labelDate = (UILabel *)[self.view viewWithTag:LABEL_DATE_TAG];
    if (labelDate != nil) {
        labelDate.text = [NSString stringWithFormat:@"%d年%d月%d日 周%@", _solarYear, _solarMonth, _solarDay, weekDay];
    }
    
//    Calendar dar;
//	
//	DateInfo info(nCurYear, nCurMonth, nCurDay);
//	NSString *week =[NSString stringWithCString:dar.DayOfWeekZhou(info) encoding: NSUTF8StringEncoding];
//    
//	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(tabYear.tag+2) inSection:0];
//	[tabYear scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES]; 
//	[tabYear selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//	
//	scrollIndexPath = [NSIndexPath indexPathForRow:(tabMonth.tag+2) inSection:0];
//	[tabMonth scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//	[tabMonth selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//	
//	scrollIndexPath = [NSIndexPath indexPathForRow:(tabDay.tag+2) inSection:0];
//	[tabDay scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//	[tabDay selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];	
//	
//	lbGongli.text = [NSString stringWithFormat:@"%d年%d月%d日 周%@", 
//                     nCurYear,
//                     nCurMonth,
//                     nCurDay,
//                     week
//                     ];
//	if (isGongLi)
//	{
//		[btnGongli setBackgroundImage:[UIImage imageNamed:@"gongnong-2.png"] forState:UIControlStateNormal]; 
//		[btnNongli setBackgroundImage:[UIImage imageNamed:@"gongnong-1.png"] forState:UIControlStateNormal]; 
//	}
//	else {
//		[btnGongli setBackgroundImage:[UIImage imageNamed:@"gongnong-1.png"] forState:UIControlStateNormal]; 
//		[btnNongli setBackgroundImage:[UIImage imageNamed:@"gongnong-2.png"] forState:UIControlStateNormal]; 
//	}
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showDatePicker:(UIView *)FParentView
{
    [FParentView addSubview:self.view];
    
    [self initYearMonth];
    [self initDay];
    [self updateDateInfo];
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
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    [view release];
    
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
    _tableViewYear.dataSource = self;
    _tableViewYear.delegate = self;
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
    _tableViewMonth.dataSource = self;
    _tableViewMonth.delegate = self;
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
    _tableViewDay.dataSource = self;
    _tableViewDay.delegate = self;
    [self.view addSubview:_tableViewDay];
    [_tableViewDay release];
    
    [dayBgView release];
    
    UILabel *labelYear = [UILabel labelWithName:@"年" 
                                           font:ARIAL_FONT(15) 
                                          frame:CGRectMake(25, 435, 98, 20) 
                                          color:[UIColor blackColor] 
                                      alignment:UITextAlignmentCenter];
    UILabel *labelMonth = [UILabel labelWithName:@"月" 
                                            font:ARIAL_FONT(15) 
                                           frame:CGRectMake(135, 435, 75, 20) 
                                           color:[UIColor blackColor] 
                                       alignment:UITextAlignmentCenter];
    UILabel *labelDay = [UILabel labelWithName:@"日" 
                                          font:ARIAL_FONT(15) 
                                         frame:CGRectMake(218, 435, 75, 20) 
                                         color:[UIColor blackColor] 
                                     alignment:UITextAlignmentCenter];
    [self.view addSubview:labelYear];
    [self.view addSubview:labelMonth];
    [self.view addSubview:labelDay];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableViewYear)
    {
        return [_arrayYear count];
    }
    else if (tableView == _tableViewMonth)
    {
        return [_arrayMonth count];
    }
    else if (tableView == _tableViewDay)
    {
        return [_arrayDay count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == _tableViewYear) {
        NSString *year = [_arrayYear objectAtIndex:row];
        cell.textLabel.text = year;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    else if (tableView == _tableViewMonth)
    {
        NSString *month = [_arrayMonth objectAtIndex:row];
        cell.textLabel.text = month;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    else if (tableView == _tableViewDay)
    {
        NSString *day = [_arrayDay objectAtIndex:row];
        cell.textLabel.text = day;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == tabYear) 
//	{
//		if (indexPath.row < 3)
//			tableView.tag = 0;
//		else if (indexPath.row >= dbYear.count - 2)
//			tableView.tag = dbYear.count - 5;
//		else 
//			tableView.tag = indexPath.row - 2;
//	}	
//	if (tableView == tabMonth) 
//	{
//		if (indexPath.row < 3)
//			tableView.tag = 0;
//		else if (indexPath.row >= dbMonth.count - 2)
//			tableView.tag = dbMonth.count - 5;
//		else 
//			tableView.tag = indexPath.row - 2;
//	}	
//	if (tableView == tabDay) 
//	{
//		if (indexPath.row < 3)
//			tableView.tag = 0;
//		else if (indexPath.row >= dbDay.count - 2)
//			tableView.tag = dbDay.count - 5;
//		else 
//			tableView.tag = indexPath.row - 2;
//	}
//	
//	if ((tableView == tabYear) || (tableView == tabMonth))
//	{ 
//		if (isGongLi)
//		{
//			nCurYear = tabYear.tag + 1950;
//			nCurMonth = tabMonth.tag + 1;
//			nCurDay = tabDay.tag + 1;
//			[self Gong2Nong];
//		}
//		else {
//			nCurYear_nl = tabYear.tag + 1950;
//			nCurMonth_nl = tabMonth.tag + 1;
//			nCurDay_nl = tabDay.tag + 1;
//			[self Nong2Gong];
//		}
//		[self InitDay];
//	}
//	else {
//		if (isGongLi)
//		{
//			nCurDay = tabDay.tag + 1;
//			[self Gong2Nong];
//		}
//		else {
//			nCurDay_nl = tabDay.tag + 1;
//			[self Nong2Gong];
//		}
//        
//	}
//	
//	[self showDateInfo];
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
