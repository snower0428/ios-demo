//
//  LivelyTableViewCtrl.m
//  Demo
//
//  Created by lei hui on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LivelyTableViewCtrl.h"

@implementation LivelyTableViewCtrl

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    [self addBackButton];
    
    UIBarButtonItem *transitionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pickTransform:)];
    self.navigationItem.rightBarButtonItem = transitionButton;
    [transitionButton release];
    
    self.title = @"ADLivelyDemo";
    _array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 200; i++) {
        [_array addObject:[NSString stringWithFormat:@"Lively row #%d", i]];
    }
    
    _tableView = [[ADLivelyTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableView.initialCellTransformBlock = ADLivelyTransformFan;
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

#pragma mark -

- (void)pickTransform:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a transform"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Fan", @"Curl", @"Fade", @"Helix", @"Wave", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    [actionSheet release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *transforms = [NSArray arrayWithObjects:
                           ADLivelyTransformFan, 
                           ADLivelyTransformCurl, 
                           ADLivelyTransformFade, 
                           ADLivelyTransformHelix, 
                           ADLivelyTransformWave, nil];
    
    if (buttonIndex < [transforms count]) {
        _tableView.initialCellTransformBlock = [transforms objectAtIndex:buttonIndex];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView = backgroundView;
        [backgroundView release];
    }
    
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    
    UIColor *altBackgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    cell.backgroundView.backgroundColor = [indexPath row] % 2 == 0 ? [UIColor whiteColor] : altBackgroundColor;
    cell.textLabel.backgroundColor = cell.backgroundView.backgroundColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - dealloc

- (void)dealloc
{
    [_array release];
    [_tableView release];
    
    [super dealloc];
}

@end
