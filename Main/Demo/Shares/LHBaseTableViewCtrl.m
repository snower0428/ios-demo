//
//  LHBaseTableViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-20.
//
//

#import "LHBaseTableViewCtrl.h"
#import "DataController.h"

@interface LHBaseTableViewCtrl ()

@end

@implementation LHBaseTableViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithWhite:230.0/255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.title = @"RootViewController";
    
    //BackItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = _(@"Back");
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [_arrayViewController count])
    {
        NSString *strClass = [_arrayViewController objectAtIndex:indexPath.row];
        id object = NSClassFromString(strClass);
        
        if ([strClass isEqualToString:@"JADockViewCtrl"] ||
            [strClass isEqualToString:@"DDMenuDockViewCtrl"]
            )
        {
            UIViewController *ctrl = [[[object alloc] init] autorelease];
            [self presentViewController:ctrl animated:YES completion:nil];
        }
        else if ([strClass isEqualToString:@"SDScaffoldIndexViewController"])
        {
            UIViewController *ctrl = [[object alloc] initWithEntityName:@"User" sortBy:@"lastname" context:MANAGED_OBJECT_CONTEXT];
            [self.navigationController pushViewController:ctrl animated:YES];
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
    
    [super dealloc];
}

@end
