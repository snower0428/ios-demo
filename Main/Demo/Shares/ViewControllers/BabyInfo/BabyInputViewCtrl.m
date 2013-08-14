//
//  BabyInputViewCtrl.m
//  ToDo
//
//  Created by leihui on 12-10-23.
//
//

#import "BabyInputViewCtrl.h"
#import "BBAnimation.h"
#import "BabyCompleteViewController.h"
#import "UIDatePickerCtrl.h"

@interface BabyInputViewCtrl ()
- (void)initPregnancyView;
- (void)initHasBabyView;
- (void)initPregnancyData;
- (void)initHasBabyData;
- (void)showNextButton;
- (void)showNextButtonWithAnimation;
- (void)initDateLabelWithFrame:(CGRect)frame;
- (void)initDateButtonWithFrame:(CGRect)frame;
- (NSString *)addDays:(NSInteger)days fromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day andFormat:(BOOL)format;
- (void)onSelectDate;
- (void)dateFromDateString:(NSString *)srcDate year:(out NSInteger *)year month:(out NSInteger *)month day:(out NSInteger *)day;
- (BOOL)checkBabyData;
- (BOOL)checkPregnancyData;
@end

@implementation BabyInputViewCtrl

@synthesize hasBaby = _hasBaby;

- (id)initWithBaby:(BOOL)hasBaby
{
    if (self = [super init]) {
        _hasBaby = hasBaby;
        _babyDateType = BabyDateTypeNone;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // bg
    UIImageView *bg = [UIImageView imageViewWithFile:@"baby_info_bg.png"];
    [self.view addSubview:bg];
    
    // 顶部“输入信息”
    UIImageView *imageViewTop = [UIImageView imageViewWithFile:@"title_input.png"];
    [self.view addSubview:imageViewTop];
    
    // 底部“请选择时期”
    UIImageView *imageViewBottom = [UIImageView imageViewWithFile:@"cloud_bg.png" atPostion:CGPointMake(0, 418)];
    [self.view addSubview:imageViewBottom];
    
    UILabel *label = [UILabel labelWithName:@"请输入孕妇信息"
                                       font:FZY4JW_FONT(20)
                                      frame:CGRectMake(0, 5, imageViewBottom.frame.size.width, imageViewBottom.frame.size.height)
                                      color:nil
                                  alignment:UITextAlignmentCenter];
    [imageViewBottom addSubview:label];
    
    // 太阳
    _imageViewSun = [UIImageView imageViewWithFile:@"baby_guide_sun.png" atPostion:CGPointMake(250, 390)];
    [self.view addSubview:_imageViewSun];
    
    // 下一步
    _btnNext = [UIButton buttonWithBackgroundNormalFile:@"btn_next.png" downFile:@"btn_next_d.png"];
    _btnNext.frame = CGRectMake(248, 388, _btnNext.frame.size.width, _btnNext.frame.size.height);
    [self.view addSubview:_btnNext];
    [_btnNext addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnNext.tag = BabyInputActionTypeNext;
    _btnNext.hidden = YES;
    
    // 返回
    UIButton *btnReturn = [UIButton buttonWithBackgroundNormalFile:@"btn_return.png" downFile:@"btn_return_d.png"];
    btnReturn.frame = CGRectMake(15, 418, btnReturn.frame.size.width, btnReturn.frame.size.height);
    [self.view addSubview:btnReturn];
    
    [btnReturn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (_hasBaby) {
        // 有宝宝
        [self initHasBabyView];
    } else {
        // 怀孕期
        [self initPregnancyView];
    }
    
    [self showNextButton];
    
    // Get font
//    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    for (int nFamily = 0; nFamily < [familyNames count]; nFamily++) {
//        NSLog(@"Family names: %@", [familyNames objectAtIndex:nFamily]);
//        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:nFamily]]];
//        for (int nFont = 0; nFont < [fontNames count]; nFont++) {
//            NSLog(@"Font names: %@", [fontNames objectAtIndex:nFont]);
//        }
//        [fontNames release];
//    }
//    [familyNames release];
}

// 初始化孕妇期
- (void)initPregnancyView
{
    // 孕妇期
    UIImageView *imageTitle = [UIImageView imageViewWithFile:@"pregnancy.png" atPostion:CGPointMake(120, 70)];
    [self.view addSubview:imageTitle];
    
    // 小背景
    UIImageView *inputBg = [UIImageView imageViewWithFile:@"pregnancy_bg" atPostion:CGPointMake(10, 130)];
    [self.view addSubview:inputBg];
    
    // 预产期
    _btnPreBirth = [UIButton buttonWithBackgroundNormalFile:@"radio.png" downFile:@"radio_d.png"];
    _btnPreBirth.frame = CGRectMake(100, 140, _btnPreBirth.frame.size.width, _btnPreBirth.frame.size.height);
    [self.view addSubview:_btnPreBirth];
    [_btnPreBirth addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnPreBirth.tag = BabyInputActionTypePreBirth;
    
    UILabel *labelPreBirth = [UILabel labelWithName:@"预产期"
                                               font:FZY4JW_FONT(20)
                                              frame:CGRectMake(140, 142, 150, 30)
                                              color:[UIColor whiteColor]
                                          alignment:UITextAlignmentLeft];
    [self.view addSubview:labelPreBirth];
    
    // 最后月经时间
    _btnLastMenses = [UIButton buttonWithBackgroundNormalFile:@"radio.png" downFile:@"radio_d.png"];
    _btnLastMenses.frame = CGRectMake(100, 305, _btnLastMenses.frame.size.width, _btnLastMenses.frame.size.height);
    [self.view addSubview:_btnLastMenses];
    [_btnLastMenses addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnLastMenses.tag = BabyInputActionTypeLastMenses;
    
    UILabel *labelLastMenses = [UILabel labelWithName:@"最后月经时间"
                                                 font:FZY4JW_FONT(20)
                                                frame:CGRectMake(140, 307, 150, 30)
                                                color:[UIColor whiteColor]
                                            alignment:UITextAlignmentLeft];
    [self.view addSubview:labelLastMenses];
    
    // 日期
    _imageViewDateBg = [UIImageView imageViewWithFile:@"date_bg.png" atPostion:CGPointMake(105, 215)];
    [self.view addSubview:_imageViewDateBg];
    
    [self initDateButtonWithFrame:_imageViewDateBg.frame];
    [self initPregnancyData];
}

// 初始化有宝宝
- (void)initHasBabyView
{
    // 有宝宝
    UIImageView *imageTitle = [UIImageView imageViewWithFile:@"has_baby.png" atPostion:CGPointMake(120, 70)];
    [self.view addSubview:imageTitle];
    
    // 小背景
    _imageViewBg = [UIImageView imageViewWithFile:@"has_baby_princess_bg.png" atPostion:CGPointMake(10, 125)];
    [self.view addSubview:_imageViewBg];
    
    // 宝宝性别
    UILabel *labelBabySex = [UILabel labelWithName:@"宝宝性别"
                                              font:FZY4JW_FONT(20)
                                             frame:CGRectMake(100, 130, 150, 30)
                                             color:[UIColor whiteColor]
                                         alignment:UITextAlignmentCenter];
    [self.view addSubview:labelBabySex];
    
    // 宝宝生日
    UILabel *labelBabyBirthday = [UILabel labelWithName:@"宝宝生日"
                                                   font:FZY4JW_FONT(20)
                                                  frame:CGRectMake(100, 270, 150, 30)
                                                  color:[UIColor whiteColor]
                                              alignment:UITextAlignmentCenter];
    [self.view addSubview:labelBabyBirthday];
    
    // 王子
    _btnPrince = [UIButton buttonWithBackgroundNormalFile:@"btn_prince.png" downFile:@"btn_prince_d.png"];
    _btnPrince.frame = CGRectMake(95, 180, _btnPrince.frame.size.width, _btnPrince.frame.size.height);
    [self.view addSubview:_btnPrince];
    [_btnPrince addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnPrince.tag = BabyInputActionTypePrince;
    
    // 公主
    _btnPrincess = [UIButton buttonWithBackgroundNormalFile:@"btn_princess.png" downFile:@"btn_princess_d.png"];
    _btnPrincess.frame = CGRectMake(185, 180, _btnPrincess.frame.size.width, _btnPrincess.frame.size.height);
    [self.view addSubview:_btnPrincess];
    [_btnPrincess addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnPrincess.tag = BabyInputActionTypePrincess;
    
    // 日期
    _imageViewDateBg = [UIImageView imageViewWithFile:@"date_bg.png" atPostion:CGPointMake(95, 305)];
    [self.view addSubview:_imageViewDateBg];
    
    [self initDateButtonWithFrame:_imageViewDateBg.frame];
    [self initHasBabyData];
}

- (void)initDateButtonWithFrame:(CGRect)frame
{
    _btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDate.frame = frame;
    _btnDate.backgroundColor = [UIColor clearColor];
    _btnDate.titleLabel.font = FZY4JW_FONT(20);
    [self.view addSubview:_btnDate];
    [_btnDate addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnDate.tag = BabyInputActionTypeDate;
}

- (void)initDateLabelWithFrame:(CGRect)frame
{
    _lableDate = [UILabel labelWithName:@"请输入日期" font:FZY4JW_FONT(20) frame:frame color:[UIColor whiteColor] alignment:UITextAlignmentCenter];
    [self.view insertSubview:_lableDate belowSubview:_btnDate];
    
    CABasicAnimation *animation = [BBAnimation opacityCount:FLT_MAX duration:0.8 fromValue:[NSNumber numberWithFloat:0.6] toValue:[NSNumber numberWithFloat:0.1]];
    [_lableDate.layer addAnimation:animation forKey:@"OpacityAnimation"];
}

#pragma mark ------------------ initData ------------------

- (void)initPregnancyData
{
//    _isLastMensesDate = CommBusiness.babyInfo.deliverDateType;
//    _preBitrhDate = CommBusiness.babyInfo.deliverDate;
    
    NSString *strDate = nil;
    
    if (_preBitrhDate != nil) {
        NSString *date = [_preBitrhDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self dateFromDateString:date year:&_preBirthYear month:&_preBirthMonth day:&_preBirthDay];
    }
    if (_preBirthYear == 0 && _preBirthMonth == 0 && _preBirthDay == 0) {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        strDate = [NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, [components year], [components month], [components day]];
    } else {
        if (_isLastMensesDate) {
            // 最后月经
            strDate = [self addDays:-279 fromYear:_preBirthYear month:_preBirthMonth day:_preBirthDay andFormat:NO];
        } else {
            // 预产期
            strDate = [NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, _preBirthYear, _preBirthMonth, _preBirthDay];
        }
    }
    
    if (_isLastMensesDate) {
        _babyDateType = BabyDateTypeLastMenses;
        
        [_btnPreBirth setBackgroundImage:[UIImage imageFile:@"radio.png"] forState:UIControlStateNormal];
        [_btnLastMenses setBackgroundImage:[UIImage imageFile:@"radio_d.png"] forState:UIControlStateNormal];
    } else {
        _babyDateType = BabyDateTypePreBirth;
        
        [_btnPreBirth setBackgroundImage:[UIImage imageFile:@"radio_d.png"] forState:UIControlStateNormal];
        [_btnLastMenses setBackgroundImage:[UIImage imageFile:@"radio.png"] forState:UIControlStateNormal];
    }
    
//    if ([PubFunction stringIsNullOrEmpty:[[CommBusiness getInstance] currentRoleID]]) {
//        [self initDateLabelWithFrame:_imageViewDateBg.frame];
//    } else {
//        [_btnDate setTitle:strDate forState:UIControlStateNormal];
//    }
    
    NSLog(@"strDate:%@", strDate);
    
    [self initDateLabelWithFrame:_imageViewDateBg.frame];
}

- (void)initHasBabyData
{
    _babyDateType = BabyDateTypeHasBaby;
    
//    _babySex = CommBusiness.babyInfo.babySex;
    if(_babySex == 0){
        _imageViewBg.image = [UIImage imageFile:@"has_baby_prince_bg.png"];
        [_btnPrince setBackgroundImage:[UIImage imageFile:@"btn_prince_d.png"] forState:UIControlStateNormal];
        [_btnPrincess setBackgroundImage:[UIImage imageFile:@"btn_princess.png"] forState:UIControlStateNormal];
    } else {
        _imageViewBg.image = [UIImage imageFile:@"has_baby_princess_bg.png"];
        [_btnPrince setBackgroundImage:[UIImage imageFile:@"btn_prince.png"] forState:UIControlStateNormal];
        [_btnPrincess setBackgroundImage:[UIImage imageFile:@"btn_princess_d.png"] forState:UIControlStateNormal];
    }
    
//    if ([PubFunction stringIsNullOrEmpty:[[CommBusiness getInstance] currentRoleID]]) {
//        [self initDateLabelWithFrame:_imageViewDateBg.frame];
//    } else {
//        _babyBirthday = CommBusiness.babyInfo.babyBirthday;
//        if (![PubFunction stringIsNullOrEmpty:_babyBirthday]) {
//            NSString *date = [_babyBirthday stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            [self dateFromDateString:date year:&_babyBirthYear month:&_babyBirthMonth day:&_babyBirthDay];
//            [_btnDate setTitle:[NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, _babyBirthYear, _babyBirthMonth, _babyBirthDay] forState:UIControlStateNormal];
//        }
//    }
    
    [self initDateLabelWithFrame:_imageViewDateBg.frame];
}

#pragma mark ------------------ func ------------------

- (NSString *)addDays:(NSInteger)days fromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day andFormat:(BOOL)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATE_FORMAT_YYYY_MM_DD];
    NSDate *date = [df dateFromString:[NSString stringWithFormat:TIME_FORMAT_SEP_SEP,year ,month, day]];
    [df release];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:days];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    
    NSDateComponents *newComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:newDate];
    year = [newComps year];
    month = [newComps month];
    day = [newComps day];
    [calendar release];
    
    NSString* strDate = [NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, year, month, day];
    if (format) {
        strDate = [NSString stringWithFormat:TIME_FORMAT_SEP_SEP, year, month, day];
    }
    
    return strDate;
}

- (void)onPreBirthDate
{
    _babyDateType = BabyDateTypePreBirth;
    
    if (_isLastMensesDate)
    {
        _isLastMensesDate = NO;
        _preBitrhDate = [NSString stringWithFormat:TIME_FORMAT_SEP_SEP, _preBirthYear, _preBirthMonth, _preBirthDay];
        
        NSString *strDate = [NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, _preBirthYear, _preBirthMonth, _preBirthDay];
        [_btnDate setTitle:strDate forState:UIControlStateNormal];
    }
}

- (void)onLastMensesDate
{
    _babyDateType = BabyDateTypeLastMenses;
    
    if (!_isLastMensesDate)
    {
        _isLastMensesDate = YES;
        _lastMensesDate = [self addDays:-279 fromYear:_preBirthYear month:_preBirthMonth day:_preBirthDay andFormat:YES];
        
        NSString *strDate = [self addDays:-279 fromYear:_preBirthYear month:_preBirthMonth day:_preBirthDay andFormat:NO];
        [_btnDate setTitle:strDate forState:UIControlStateNormal];
    }
}

// 下一步
- (void)onNext
{
    if (_hasBaby) { //有宝宝
        if (![self checkBabyData]) {
            return;
        } else {
//            [CommBusiness babyInfo].isConceive = kNo;
//            [CommBusiness babyInfo].babyBirthday = [NSString stringWithFormat:TIME_FORMAT_SEP_SEP, _babyBirthYear, _babyBirthMonth, _babyBirthDay];
//            [CommBusiness babyInfo].babySex = _babySex;
        }
    } else { //怀孕中
        if (![self checkPregnancyData]) {
            return;
        } else {
//            [CommBusiness babyInfo].isConceive = kYes;
//            [CommBusiness babyInfo].deliverDate = [NSString stringWithFormat:TIME_FORMAT_SEP_SEP, _preBirthYear, _preBirthMonth, _preBirthDay];
//            [CommBusiness babyInfo].deliverDateType = _isLastMensesDate;
        }
    }
    
    BabyCompleteViewController *babyCompleteCtrl = [[BabyCompleteViewController alloc] init];
    [self.navigationController pushViewController:babyCompleteCtrl animated:YES];
    [babyCompleteCtrl release];
}

- (void)onSelectDate
{
    NSLog(@"选择日期...");
    NSInteger nDateYear = 0;
    NSInteger nDateMonth = 0;
    NSInteger nDateDay = 0;
    if (_hasBaby) {
        // 有宝宝
        nDateYear = _babyBirthYear;
        nDateMonth = _babyBirthMonth;
        nDateDay = _babyBirthDay;
    } else {
        // 孕妇期
        if (_isLastMensesDate) {
            NSString *strDate = [self addDays:-279 fromYear:_preBirthYear month:_preBirthMonth day:_preBirthDay andFormat:YES];
            strDate = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [self dateFromDateString:strDate year:&nDateYear month:&nDateMonth day:&nDateDay];
        } else {
            nDateYear = _preBirthYear;
            nDateMonth = _preBirthMonth;
            nDateDay = _preBirthDay;
        }
    }
    if (nDateYear == 0 || nDateMonth == 0 || nDateDay == 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        nDateYear = components.year;
        nDateMonth = components.month;
        nDateDay = components.day;
    }
    
    [[UIDatePickerCtrl shareInstance] showDatePicker:YES date:[NSDate date] parent:self.view delegate:self selector:@selector(updateDate:)];
    [UIDatePickerCtrl shareInstance].view.alpha = 0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         [UIDatePickerCtrl shareInstance].view.alpha = 1;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)updateDate:(NSString *)date
{
    int year = 0, month = 0, day = 0;
    [self dateFromDateString:date year:&year month:&month day:&day];
    
    if (_babyDateType == BabyDateTypePreBirth) {
        // 预产期
        _preBirthYear = year;
        _preBirthMonth = month;
        _preBirthDay = day;
        
        [_btnDate setTitle:[NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, year, month, day] forState:UIControlStateNormal];
        _preBitrhDate = [NSString stringWithFormat:TIME_FORMAT_SEP_SEP, _preBirthYear, _preBirthMonth, _preBirthDay];
        NSLog(@"_preBitrhDate = %@", _preBitrhDate);
    } else if (_babyDateType == BabyDateTypeLastMenses) {
        // 最后月经时间
        NSString *strPreBirthDate = [self addDays:279 fromYear:year month:month day:day andFormat:YES];
        strPreBirthDate = [strPreBirthDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self dateFromDateString:strPreBirthDate year:&_preBirthYear month:&_preBirthMonth day:&_preBirthDay];
        
        _lastMensesDate = [self addDays:-279 fromYear:_preBirthYear month:_preBirthMonth day:_preBirthDay andFormat:YES];
        
        [_btnDate setTitle:[NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, year, month, day] forState:UIControlStateNormal];
        
        NSLog(@"_lastMensesDate = %@", _lastMensesDate);
    } else if (_babyDateType == BabyDateTypeHasBaby) {
        // 有宝宝
        _babyBirthYear = year;
        _babyBirthMonth = month;
        _babyBirthDay = day;
        
        [_btnDate setTitle:[NSString stringWithFormat:TIME_FORMAT_SEP_GENERAL, year, month, day] forState:UIControlStateNormal];
        _babyBirthday = [NSString stringWithFormat:TIME_FORMAT_SEP_SEP, _babyBirthYear, _babyBirthMonth, _babyBirthDay];
        NSLog(@"_babyBirthday = %@", _babyBirthday);
    } else {
        NSLog(@"宝宝日期类型有误。。。");
    }
}

- (BOOL)checkPregnancyData
{
    if (_isLastMensesDate) {
        //最后月经
        NSString *strLastMensesDate = [self addDays:-279 fromYear:_preBirthYear month:_preBirthMonth day:_preBirthDay andFormat:YES];
        
        int nLastMensesYear = 0;
        int nLastMensesMonth = 0;
        int nLastMensesDay = 0;
        strLastMensesDate = [strLastMensesDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self dateFromDateString:strLastMensesDate year:&nLastMensesYear month:&nLastMensesMonth day:&nLastMensesDay];
        
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:DATE_FORMAT_YYYY_MM_DD];
        NSDate *selDate = [dateformatter dateFromString:[NSString stringWithFormat:TIME_FORMAT_SEP_SEP, nLastMensesYear, nLastMensesMonth, nLastMensesDay]];
        [dateformatter release];
        
        NSTimeInterval dateLong = [selDate timeIntervalSinceNow];
        NSInteger day = dateLong/(24*60*60);
        
        NSLog(@"day = %d", day);
        if (day>=0 && dateLong>0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"末次经期输入有误，日期不能大于今日！，请重新输入末次经期。"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
        if (day <= -280) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"根据您输入的末次经期来算，您已怀孕超过280天。\r\n 请确认好末次经期后，重新输入。"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
    } else {
        //预产期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:DATE_FORMAT_YYYY_MM_DD];
        NSDate *selDate = [dateFormatter dateFromString:[NSString stringWithFormat:TIME_FORMAT_SEP_SEP, _preBirthYear, _preBirthMonth, _preBirthDay]];
        [dateFormatter release];
        
        NSTimeInterval dateLong = [selDate timeIntervalSinceNow];
        NSInteger day = dateLong/(24*60*60);
        
        NSLog(@"day = %d", day);
        if (day >= 279)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"根据您输入的预产期来算，您已怀孕超过280天。\r\n 请确认好预产期后，重新输入。"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
        
        if (day < 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"预产期应该大于当前日期哦！请重新输入预产期。"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)checkBabyData
{
    NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
	NSInteger nCurYear = [components year];
	NSInteger nCurMonth = [components month];
	NSInteger nCurDay = [components day];
    
    if ((nCurYear - _babyBirthYear >= 7)
        || ((nCurYear - _babyBirthYear == 6)&&(nCurMonth - _babyBirthMonth >= 1))
        || ((nCurYear - _babyBirthYear == 6)&&(nCurMonth == _babyBirthMonth)&&(nCurDay >= _babyBirthDay)))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"您的宝宝年龄已超过六岁，超出了育儿软件的服务范围（0～6岁），无法使用该软件。"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    if ((_babyBirthYear > nCurYear)
        || ((_babyBirthYear == nCurYear)&&(_babyBirthMonth > nCurMonth))
        || ((_babyBirthYear == nCurYear)&&(_babyBirthMonth == nCurMonth)&&(_babyBirthDay > nCurDay)))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                        message:@"您设的宝宝生日超过了今天，请重新输入宝宝实际的生日。\r\n 如果怀孕中宝宝未出生时请选择宝宝预产期。"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    return YES;
}

- (void)dateFromDateString:(NSString *)srcDate year:(out NSInteger *)year month:(out NSInteger *)month day:(out NSInteger *)day
{
    //date格式如:20121026
    if ([srcDate length] >= 8) {
        NSString *date = [srcDate substringFromIndex:[srcDate length]-8];
        *year = [[date substringToIndex:4] integerValue];
        *month = [[date substringWithRange:NSMakeRange(4, 2)] integerValue];
        *day = [[date substringFromIndex:6] integerValue];
    }
}

#pragma mark -------------------- buttonClicked --------------------

- (void)buttonClicked:(UIButton *)button
{
    int buttonTag = button.tag;
    
    switch (buttonTag) {
        case BabyInputActionTypePreBirth:
        {
            // 预产期
            [_btnPreBirth setBackgroundImage:[UIImage imageFile:@"radio_d.png"] forState:UIControlStateNormal];
            [_btnLastMenses setBackgroundImage:[UIImage imageFile:@"radio.png"] forState:UIControlStateNormal];
            
            [self onPreBirthDate];
        }break;
            
        case BabyInputActionTypeLastMenses:
        {
            // 最后月经时间
            [_btnPreBirth setBackgroundImage:[UIImage imageFile:@"radio.png"] forState:UIControlStateNormal];
            [_btnLastMenses setBackgroundImage:[UIImage imageFile:@"radio_d.png"] forState:UIControlStateNormal];
            
            [self onLastMensesDate];
        }break;
            
        case BabyInputActionTypeDate:
        {
            // 选择日期
            if (_lableDate) {
                [_lableDate.layer removeAllAnimations];
                [_lableDate removeFromSuperview];
                _lableDate = nil;
            }
            if (_btnNext.hidden) {
                [self showNextButtonWithAnimation];
            }
            
            [self onSelectDate];
        }break;
            
        case BabyInputActionTypeNext:
        {
            // 下一步
            [self onNext];
        }break;
            
        case BabyInputActionTypePrince:
        {
            // 王子
            _imageViewBg.image = [UIImage imageFile:@"has_baby_prince_bg.png"];
            [_btnPrince setBackgroundImage:[UIImage imageFile:@"btn_prince_d.png"] forState:UIControlStateNormal];
            [_btnPrincess setBackgroundImage:[UIImage imageFile:@"btn_princess.png"] forState:UIControlStateNormal];
            
            _babySex = 0;
        }break;
            
        case BabyInputActionTypePrincess:
        {
            // 公主
            _imageViewBg.image = [UIImage imageFile:@"has_baby_princess_bg.png"];
            [_btnPrince setBackgroundImage:[UIImage imageFile:@"btn_prince.png"] forState:UIControlStateNormal];
            [_btnPrincess setBackgroundImage:[UIImage imageFile:@"btn_princess_d.png"] forState:UIControlStateNormal];
            
            _babySex = 1;
        }break;
            
        default:
            break;
    }
}

- (void)showNextButton
{
//    if (![PubFunction stringIsNullOrEmpty:[[CommBusiness getInstance] currentRoleID]]) {
//        _btnNext.hidden = NO;
//        _imageViewSun.hidden = YES;
//    }
}

- (void)showNextButtonWithAnimation
{
    [UIView beginAnimations:@"RotateButton" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_imageViewSun cache:YES];
    
    _imageViewSun.image = [UIImage imageNamed:@"btn_next.png"];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

#pragma --------------------  delegate --------------------

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"RotateButton"]) {
        _btnNext.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

@end
