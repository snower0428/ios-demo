//
//  EGORefreshTableViewCtrl.m
//  Demo
//
//  Created by hui lei on 13-2-2.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "EGORefreshTableViewCtrl.h"

@implementation EGORefreshTableViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_HEIGHT)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    // Return
    __block __typeof(self) _self = self;
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReturn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    btnReturn.frame = CGRectMake(0, 0, 100, 30);
    [btnReturn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:btnReturn];
    
    [btnReturn handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self.navigationController popViewControllerAnimated:YES];
    }];
    
    // Add table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, APP_HEIGHT-30)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView release];
    
    // Add refresh header view
    if (_refreshHeaderView == nil) {
        CGRect refreshHeaderViewFrame = CGRectMake(0, 0-(APP_HEIGHT-30), 320, APP_HEIGHT-30);
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshHeaderViewFrame];
		view.delegate = self;
		[_tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
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

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	// should be calling your tableviews data source model to reload
	// put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData
{
	// model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.text = [NSString stringWithFormat:@"Section %d, Row %d", section, row];
        cell.textLabel.tag = 100;
    } else {
        UILabel *textLabel = (UILabel *)[cell viewWithTag:100];
        textLabel.text = [NSString stringWithFormat:@"Section %d, Row %d", section, row];
    }
    
	// Configure the cell.
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSString stringWithFormat:@"Section %i", section];
	
}

#pragma mark - UITableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - dealloc

- (void)dealloc
{
    _tableView = nil;
    _refreshHeaderView = nil;
    
    [super dealloc];
}

@end
