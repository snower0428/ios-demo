//
//  TDProduceViewCtrl.m
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-3.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "TDProduceViewCtrl.h"
#import "TDTextViewCtrl.h"
#import "TDLocationViewCtrl.h"

@interface TDProduceViewCtrl ()
{
    UITableView     *_tableView;
    NSArray         *_arrayName;
}

@end

@implementation TDProduceViewCtrl

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
    
    _arrayName = [[NSArray alloc] initWithObjects:@"文本信息", @"剪贴板", @"电话", @"短信", @"网址", @"邮箱", @"位置", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithWhite:230.0/255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)showProduceWith:(TDProduceType)type title:(NSString *)title
{
    TDTextViewCtrl *ctrl = [[TDTextViewCtrl alloc] init];
    ctrl.produceType = type;
    ctrl.title = title;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
    switch (row) {
        case 0: //文本信息
        {
            if (row < [_arrayName count]) {
                [self showProduceWith:TDProduceTypeText title:[_arrayName objectAtIndex:row]];
            }
            break;
        }
            
        case 1: //剪贴板
        {
            if (row < [_arrayName count]) {
                [self showProduceWith:TDProduceTypePasteboard title:[_arrayName objectAtIndex:row]];
            }
            break;
        }
            
        case 2: //电话
        {
            if (row < [_arrayName count]) {
                [self showProduceWith:TDProduceTypeCall title:[_arrayName objectAtIndex:row]];
            }
            break;
        }
            
        case 3: //短信
        {
            if (row < [_arrayName count]) {
                [self showProduceWith:TDProduceTypeSMS title:[_arrayName objectAtIndex:row]];
            }
            break;
        }
            
        case 4: //网址
        {
            if (row < [_arrayName count]) {
                [self showProduceWith:TDProduceTypeUrl title:[_arrayName objectAtIndex:row]];
            }
            break;
        }
            
        case 5: //邮箱
        {
            if (row < [_arrayName count]) {
                [self showProduceWith:TDProduceTypeMail title:[_arrayName objectAtIndex:row]];
            }
            break;
        }
            
        case 6: //位置
        {
            if (row < [_arrayName count]) {
                TDLocationViewCtrl *ctrl = [[TDLocationViewCtrl alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                [ctrl release];
            }
            break;
        }
            
        default:
            break;
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
    
    [super dealloc];
}

@end
