//
//  ViewController.m
//  GPUImageDemo
//
//  Created by leihui on 13-11-13.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "FalseColorViewCtrl.h"
#import "SobelEdgeDetectionViewCtrl.h"
#import "TiltShiftViewCtrl.h"
#import "VignetteViewCtrl.h"

#import "BrightnessContrastViewCtrl.h"
#import "HueSaturationViewCtrl.h"
#import "ExposureViewCtrl.h"
#import "GammaViewCtrl.h"

@interface ViewController ()
{
    UITableView     *_tableView;
    NSArray         *_arrayName;
    NSArray         *_arrayViewController;
}

@end

@implementation ViewController

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
    self.title = @"Demo";
    
    _arrayName = [[NSArray alloc] initWithObjects:
                  
                  [NSArray arrayWithObjects:
                   @"FalseColor",
                   @"SobelEdgeDetection",
                   @"TiltShift",
                   @"Vignette",
                   nil],
                  
                  [NSArray arrayWithObjects:
                   @"Brightness/Contrast",
                   @"Hue/Saturation",
                   @"Exposure",
                   @"Gamma",
                   nil],
                  
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            
                            [NSArray arrayWithObjects:
                             @"FalseColorViewCtrl",
                             @"SobelEdgeDetectionViewCtrl",
                             @"TiltShiftViewCtrl",
                             @"VignetteViewCtrl",
                             nil],
                            
                            [NSArray arrayWithObjects:
                             @"BrightnessContrastViewCtrl",
                             @"HueSaturationViewCtrl",
                             @"ExposureViewCtrl",
                             @"GammaViewCtrl",
                             nil],
                            
                            nil];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)initTableView
{
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section < [_arrayViewController count])
    {
        NSString *strClass = [[_arrayViewController objectAtIndex:section] objectAtIndex:row];
        id object = NSClassFromString(strClass);
        
        if ([strClass isEqualToString:@""])
        {
            
        }
        else
        {
            UIViewController *ctrl = [[[object alloc] init] autorelease];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrayName count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_arrayName objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    if (section < [_arrayName count]) {
        cell.textLabel.text = [[_arrayName objectAtIndex:section] objectAtIndex:row];
    }
    
    return cell;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_tableView release];
    [_arrayName release];
    [_arrayViewController release];
    
    [super dealloc];
}

@end
