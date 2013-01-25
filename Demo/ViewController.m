//
//  ViewController.m
//  CommDemo
//
//  Created by leihui on 12-10-17.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
//#import "BabySelectViewController.h"
//#import "ASIHttpDemoViewCtrl.h"
//#import "TableViewDemoCtrl.h"
//#import "KalCalendar/Kal.h"
//#import "CarouselDemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _arrayName = [[NSArray alloc] initWithObjects:@"BabyInfo", @"ASIHttpRequest", @"TableView", @"KalCalendar", @"Carousel", nil];
    
//    _arrayViewController = [@[NSStringFromClass([BabySelectViewController class]),
//                            NSStringFromClass([ASIHttpDemoViewCtrl class]),
//                            NSStringFromClass([TableViewDemoCtrl class]),
//                            NSStringFromClass([KalViewController class]),
//                            NSStringFromClass([CarouselDemoViewController class])] retain];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
//    NSLog(@"ViewController ---------- viewDidLoad");
    
    NSString *str = [NSString stringWithFormat:@"%@", @"I am 10 and 123 years and 23.5 old!"];
    NSLog(@"numberStr:%@ ---- intStr:%@ ---- floatStr:%@", [str getNumberString], [str getIntString], [str getFloatString]);
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"ViewController ---------- viewWillAppear:");
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"ViewController ---------- viewDidAppear:");
}

#pragma mark -------------------- delegate --------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [_arrayViewController count]) {
        id object = NSClassFromString([_arrayViewController objectAtIndex:indexPath.row]);
        UIViewController *ctrl = [[[object alloc] init] autorelease];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark -------------------- dataSource --------------------

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
        if (indexPath.row < [_arrayName count]) {
            cell.textLabel.text = [_arrayName objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------------- dealloc --------------------

- (void)dealloc
{
    [_arrayName release];
    [_arrayViewController release];
    
    [super dealloc];
}

@end
