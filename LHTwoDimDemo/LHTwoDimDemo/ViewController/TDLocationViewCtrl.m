//
//  TDLocationViewCtrl.m
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-6.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "TDLocationViewCtrl.h"

@interface TDLocationViewCtrl ()
{
    MKMapView       *_mapView;
}

@end

@implementation TDLocationViewCtrl

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
    
    CGFloat top = 0.f;
    if (SYSTEM_VERSION >= 7.0) {
        top = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT;
    }
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, top+160, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-160)];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [_mapView setMapType:MKMapTypeStandard];
    [self.view addSubview:_mapView];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate = self;//设置代理
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter = 1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta = 0.05;
    theSpan.longitudeDelta = 0.05;
    MKCoordinateRegion theRegion;
    theRegion.center = [[locationManager location] coordinate];
    theRegion.span = theSpan;
    [_mapView setRegion:theRegion];
    [locationManager release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)iAnnotation
{
    return nil;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_mapView release];
    
    [super dealloc];
}

@end
