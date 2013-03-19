//
//  DatePickerDemoViewCtrl.m
//  Demo
//
//  Created by hui lei on 13-2-1.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "DatePickerDemoViewCtrl.h"
#import "UIDatePickerCtrl.h"

@implementation DatePickerDemoViewCtrl

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

- (void)updateDate:(NSString *)date
{
    NSString *selectDate = [NSString stringWithFormat:@"Select date:%@", date];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Date" 
                                                        message:selectDate 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_HEIGHT)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    // Show DatePicker
    UIButton *btnDatePicker = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDatePicker.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    btnDatePicker.frame = CGRectMake(20, 10, 100, 30);
    [btnDatePicker setTitle:@"选择日期" forState:UIControlStateNormal];
    [self.view addSubview:btnDatePicker];
    
    [btnDatePicker handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [[UIDatePickerCtrl shareInstance] showDatePicker:YES 
                                                    date:[NSDate date] 
                                                  parent:self.view 
                                                delegate:self 
                                                selector:@selector(updateDate:)];
    }];
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

@end
