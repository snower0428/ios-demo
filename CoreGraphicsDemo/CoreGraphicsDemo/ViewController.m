//
//  ViewController.m
//  CoreGraphicsDemo
//
//  Created by leihui on 13-12-18.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "BasicEffectsViewController.h"
#import "DemoViewController.h"
#import "DrawCircleViewController.h"
#import "AngryBirdViewController.h"
#import "InstagramArtworkViewController.h"

@interface ViewController ()
{
    UITableView     *_tableView;
    NSArray         *_arrayName;
    NSArray         *_arrayViewController;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CoreGraphics";
    
    _arrayName = [[NSArray alloc] initWithObjects:
                  @"Basic",
                  @"Demo",
                  @"Circle",
                  @"AngryBird",
                  @"Instagram",
                  nil];
    
    _arrayViewController = [[NSArray alloc] initWithObjects:
                            @"BasicEffectsViewController",
                            @"DemoViewController",
                            @"DrawCircleViewController",
                            @"AngryBirdViewController",
                            @"InstagramArtworkViewController",
                            nil];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Private

- (void)initTableView
{
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)onBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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

#pragma mark - dealloc

- (void)dealloc
{
    [_tableView release];
    [_arrayName release];
    [_arrayViewController release];
    
    [super dealloc];
}

@end
