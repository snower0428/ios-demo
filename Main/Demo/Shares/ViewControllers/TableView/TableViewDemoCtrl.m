//
//  TableViewDemoCtrl.m
//  CommDemo
//
//  Created by leihui on 12-11-20.
//  Copyright (c) 2012年 ND WebSoft Inc. All rights reserved.
//

#import "TableViewDemoCtrl.h"
#import "CustomCellBackgroundView.h"
#import "CustomHeaderView.h"
#import "CustomFooterView.h"

@interface TableViewDemoCtrl ()

@end

@implementation TableViewDemoCtrl

@synthesize thingsToLearn = _thingsToLearn;
@synthesize thingsLearned = _thingsLearned;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Core Graphics 101";
    self.thingsToLearn = [NSMutableArray arrayWithObjects:@"Drawing Rects", @"Drawing Gradients", @"Drawing Arcs", nil];
    self.thingsLearned = [NSMutableArray arrayWithObjects:@"Table Views", @"UIKit", @"Objective-C", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _originTintColor = self.navigationController.navigationBar.tintColor;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.tintColor = _originTintColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [_thingsToLearn count];
    } else {
        return [_thingsLearned count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundView = [[[CustomCellBackgroundView alloc] init] autorelease];
        cell.selectedBackgroundView = [[[CustomCellBackgroundView alloc] init] autorelease];
        ((CustomCellBackgroundView *)cell.selectedBackgroundView).selected = YES;
    }
    
    // Configure the cell...
    NSString *entry;
    if (indexPath.section == 0) {
        entry = [_thingsToLearn objectAtIndex:indexPath.row];
        ((CustomCellBackgroundView *)cell.backgroundView).lastCell = indexPath.row == _thingsToLearn.count-1;
        ((CustomCellBackgroundView *)cell.selectedBackgroundView).lastCell = indexPath.row == _thingsToLearn.count-1;
    } else {
        entry = [_thingsLearned objectAtIndex:indexPath.row];
        ((CustomCellBackgroundView *)cell.backgroundView).lastCell = indexPath.row == _thingsLearned.count-1;
        ((CustomCellBackgroundView *)cell.selectedBackgroundView).lastCell = indexPath.row == _thingsLearned.count-1;
    }
    cell.textLabel.text = entry;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Things We'll Learn";
    } else {
        return @"Things Already Covered";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *header = [[[CustomHeaderView alloc] init] autorelease];
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    if (section == 1) {
        header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
        header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CustomFooterView *footer = [[[CustomFooterView alloc] init] autorelease];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

#pragma mark - dealloc

- (void)dealloc
{
    self.thingsToLearn = nil;
    self.thingsLearned = nil;
    
    [super dealloc];
}

@end
