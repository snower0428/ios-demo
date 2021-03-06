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

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    // Add table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView release];
    
    // Add refresh header view
    if (_refreshHeaderView == nil) {
        CGRect refreshHeaderViewFrame = CGRectMake(0, 0-APP_VIEW_HEIGH, 320, APP_VIEW_HEIGH);
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshHeaderViewFrame];
		view.delegate = self;
		[_tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	if (_refreshFooterView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
        refreshView.pullUpToRefresh = YES;
        refreshView.delegate = self;
        [_tableView addSubview:refreshView];
        _refreshFooterView = refreshView;
        [refreshView release];
    }
    
    //  update the last update date
	[_refreshFooterView refreshLastUpdatedDate];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _refreshFooterView.frame = CGRectMake(0.0f, _tableView.contentSize.height, 320, 650);
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
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
//    NSString *contentOffset = NSStringFromUIEdgeInsets(scrollView.contentInset);
//    NSString *contentInset = NSStringFromUIEdgeInsets(scrollView.contentInset);
//    NSLog(@"contentOffset:%@ ========== contentInset:%@", contentOffset, contentInset);
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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
