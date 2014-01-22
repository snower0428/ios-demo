//
//  LocationInfoViewController.m
//  LHCatalog
//
//  Created by leihui on 13-12-30.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "LocationInfoViewController.h"
#import "MMLocationManager.h"

typedef enum
{
    BtnActionLatLong    = 100,
    BtnActionCity,
    BtnActionAddress,
    BtnActionAllInfo,
}BtnAction;

@interface LocationInfoViewController ()
{
    UILabel     *_label;
}

@end

@implementation LocationInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = [NSArray arrayWithObjects:
                      @"获取坐标",
                      @"获取城市",
                      @"获取地址",
                      @"获取所有信息",
                      nil];
    
    CGFloat leftMargin = 10.f;
    CGFloat topMargin = 10.f;
    CGFloat btnWidth = 300.f;
    CGFloat btnHeight = 40.f;
    CGFloat yInterval = 10.f;
    
    if (SYSTEM_VERSION >= 7.0) {
        topMargin += STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT;
    }
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, topMargin, SCREEN_WIDTH, 100)];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:14.f];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = UITextAlignmentCenter;
    _label.numberOfLines = 0;
    [self.view addSubview:_label];
    
    topMargin += 100;
    
    for (int i = 0; i < [array count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.tag = BtnActionLatLong+i;
        btn.frame = CGRectMake(leftMargin, topMargin+(btnHeight+yInterval)*i, btnWidth, btnHeight);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)btnClicked:(id)sender
{
    int btnTag = ((UIButton *)sender).tag;
    switch (btnTag) {
        case BtnActionLatLong:
        {
            __block __typeof(self) _self = self;
            [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                [_self setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
            }];
            break;
        }
        case BtnActionCity:
        {
            __block __typeof(self) _self = self;
            [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
                [_self setLabelText:cityString];
            }];
            break;
        }
        case BtnActionAddress:
        {
            __block __typeof(self) _self = self;
            [[MMLocationManager shareLocation] getAddress:^(NSString *addressString) {
                [_self setLabelText:addressString];
            }];
            break;
        }
        case BtnActionAllInfo:
        {
            __block NSString *string;
            __block __typeof(self) _self = self;
            [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
            } withAddress:^(NSString *addressString) {
                string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
                [_self setLabelText:string];
            }];
            break;
        }
        default:
            break;
    }
}

-(void)setLabelText:(NSString *)text
{
    NSLog(@"text %@",text);
    _label.text = text;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_label release];
    
    [super dealloc];
}

@end
