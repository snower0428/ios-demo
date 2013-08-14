//
//  FailedBanksDetailViewCtrl.m
//  Demo
//
//  Created by leihui on 13-8-7.
//
//

#import "FailedBanksDetailViewCtrl.h"
#import "FailedBankDatabase.h"
#import "FailedBankDetails.h"

@interface FailedBanksDetailViewCtrl ()

@end

@implementation FailedBanksDetailViewCtrl

@synthesize uniqueId = _uniqueId;

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
    
    FailedBankDetails *details = [[FailedBankDatabase database] failedBankDetails:self.uniqueId];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSLog(@"self.uniqueId:%d", self.uniqueId);
    NSLog(@"details.name:%@", details.name);
    NSLog(@"details.city:%@", details.city);
    NSLog(@"details.state:%@", details.state);
    NSLog(@"details.zip:%d", details.zip);
    NSLog(@"details.closeDate:%@", [formatter stringFromDate:details.closeDate]);
    NSLog(@"details.updatedDate:%@", [formatter stringFromDate:details.updatedDate]);
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
    labelName.backgroundColor = [UIColor clearColor];
    labelName.text = @"Name:";
    labelName.textAlignment = UITextAlignmentRight;
    [self.view addSubview:labelName];
    [labelName release];
    
    UILabel *labelCity = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 20)];
    labelCity.backgroundColor = [UIColor clearColor];
    labelCity.text = @"City:";
    labelCity.textAlignment = UITextAlignmentRight;
    [self.view addSubview:labelCity];
    [labelCity release];
    
    UILabel *labelState = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 20)];
    labelState.backgroundColor = [UIColor clearColor];
    labelState.text = @"State:";
    labelState.textAlignment = UITextAlignmentRight;
    [self.view addSubview:labelState];
    [labelState release];
    
    UILabel *labelZip = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 20)];
    labelZip.backgroundColor = [UIColor clearColor];
    labelZip.text = @"Zip:";
    labelZip.textAlignment = UITextAlignmentRight;
    [self.view addSubview:labelZip];
    [labelZip release];
    
    UILabel *labelClosed = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 100, 20)];
    labelClosed.backgroundColor = [UIColor clearColor];
    labelClosed.text = @"Closed:";
    labelClosed.textAlignment = UITextAlignmentRight;
    [self.view addSubview:labelClosed];
    [labelClosed release];
    
    UILabel *labelUpdate = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 100, 20)];
    labelUpdate.backgroundColor = [UIColor clearColor];
    labelUpdate.text = @"Update:";
    labelUpdate.textAlignment = UITextAlignmentRight;
    [self.view addSubview:labelUpdate];
    [labelUpdate release];
    
    //
    // ==================================================
    //
    
    UILabel *labelNameDetail = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, 200, 20)];
    labelNameDetail.backgroundColor = [UIColor clearColor];
    labelNameDetail.text = details.name;
    labelNameDetail.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:labelNameDetail];
    [labelNameDetail release];
    
    UILabel *labelCityDetail = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, 200, 20)];
    labelCityDetail.backgroundColor = [UIColor clearColor];
    labelCityDetail.text = details.city;
    labelCityDetail.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:labelCityDetail];
    [labelCityDetail release];
    
    UILabel *labelStateDetail = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 200, 20)];
    labelStateDetail.backgroundColor = [UIColor clearColor];
    labelStateDetail.text = details.state;
    labelStateDetail.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:labelStateDetail];
    [labelStateDetail release];
    
    UILabel *labelZipDetail = [[UILabel alloc] initWithFrame:CGRectMake(105, 100, 200, 20)];
    labelZipDetail.backgroundColor = [UIColor clearColor];
    labelZipDetail.text = [NSString stringWithFormat:@"%d", details.zip];
    labelZipDetail.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:labelZipDetail];
    [labelZipDetail release];
    
    UILabel *labelClosedDetail = [[UILabel alloc] initWithFrame:CGRectMake(105, 130, 200, 20)];
    labelClosedDetail.backgroundColor = [UIColor clearColor];
    labelClosedDetail.text = [formatter stringFromDate:details.closeDate];
    labelClosedDetail.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:labelClosedDetail];
    [labelClosedDetail release];
    
    UILabel *labelUpdateDetail = [[UILabel alloc] initWithFrame:CGRectMake(105, 160, 200, 20)];
    labelUpdateDetail.backgroundColor = [UIColor clearColor];
    labelUpdateDetail.text = [formatter stringFromDate:details.updatedDate];
    labelUpdateDetail.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:labelUpdateDetail];
    [labelUpdateDetail release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
