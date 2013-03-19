//
//  GCDDemoViewCtrl.m
//  Demo
//
//  Created by leihui on 13-3-19.
//
//

#import "GCDDemoViewCtrl.h"

#define kButtonNoGCDTag     101
#define kButtonGCDTag       102
#define kMainCounter        200000
#define kSubCounter         2000

@interface GCDDemoViewCtrl ()

@end

@implementation GCDDemoViewCtrl

@synthesize stopFlag = _stopFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)loadArray
{
    if (!_array) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:kMainCounter];
        for (int i = 0; i < kMainCounter; i++) {
            [array addObject:[NSNumber numberWithInt:i]];
        }
        _array = [array copy];
    }
    
    return  _array;
}

- (void)disableStartButtons
{
    UIButton *btnStartNoGCD = (UIButton *)[self.view viewWithTag:kButtonNoGCDTag];
    if (btnStartNoGCD) {
        btnStartNoGCD.enabled = NO;
    }
    
    UIButton *btnStartGCD = (UIButton *)[self.view viewWithTag:kButtonGCDTag];
    if (btnStartGCD) {
        btnStartGCD.enabled = NO;
    }
}

- (void)enableStartButtons
{
    UIButton *btnStartNoGCD = (UIButton *)[self.view viewWithTag:kButtonNoGCDTag];
    if (btnStartNoGCD) {
        btnStartNoGCD.enabled = YES;
    }
    
    UIButton *btnStartGCD = (UIButton *)[self.view viewWithTag:kButtonGCDTag];
    if (btnStartGCD) {
        btnStartGCD.enabled = YES;
    }
}

- (void)updateLabelWith:(NSString *)str
{
    _label.text = str;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    [self loadArray];
    
    __block id _self = self;
    
    UIButton *btnStartNoGCD = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStartNoGCD.frame = CGRectMake(10, 20, 120, 30);
    btnStartNoGCD.tag = kButtonNoGCDTag;
    [btnStartNoGCD setTitle:@"btnStartNoGCD" forState:UIControlStateNormal];
    [self.view addSubview:btnStartNoGCD];
    
    [btnStartNoGCD handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self setStopFlag:NO];
        [_self disableStartButtons];
        
        for (int i = 0; i <= kMainCounter; i++){
            if ([_self stopFlag]) {
                break;
            }
            [_self updateLabelWith:[NSString stringWithFormat:@"%d",i]];
        }
        [_self enableStartButtons];
    }];
    
    UIButton *btnStartGCD = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStartGCD.frame = CGRectMake(10, 60, 120, 30);
    btnStartGCD.tag = kButtonGCDTag;
    [btnStartGCD setTitle:@"btnStartGCD" forState:UIControlStateNormal];
    [self.view addSubview:btnStartGCD];
    
    [btnStartGCD handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self setStopFlag:NO];
        [_self disableStartButtons];
        
        dispatch_queue_t aQueue = dispatch_queue_create("aQueueTag", NULL);
        dispatch_async(aQueue, ^{
            for (int i = 0; i <= kMainCounter; i++){
                if ([_self stopFlag]) {
                    break;
                }
                //sleep(1);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_self updateLabelWith:[NSString stringWithFormat:@"%d",i]];
                });
            }
            [_self enableStartButtons];
        });
    }];
    
    UIButton *btnStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStop.frame = CGRectMake(10, 100, 120, 30);
    btnStop.tag = kButtonGCDTag;
    [btnStop setTitle:@"Stop" forState:UIControlStateNormal];
    [self.view addSubview:btnStop];
    
    [btnStop handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        [_self setStopFlag:YES];
        [_self enableStartButtons];
    }];
    
    _label = [UILabel labelWithName:@"0"
                               font:[UIFont systemFontOfSize:15]
                              frame:CGRectMake(10, 150, 200, 30)
                              color:[UIColor blackColor]
                          alignment:UITextAlignmentLeft];
    [self.view addSubview:_label];
    
    UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, 300, 2)];
    separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.view addSubview:separator];
    [separator release];
    //
    //========================================
    //
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnStart.frame = CGRectMake(10, 200, 80, 30);
    [btnStart setTitle:@"Start" forState:UIControlStateNormal];
    [self.view addSubview:btnStart];
    
    [btnStart handleControlEvents:UIControlEventTouchUpInside withBlock:^(void){
        NSLog(@"start");
        dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", NULL);
        dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
        
        //Serial Queues
        NSLog(@"loadSerialFirstBlock");
        dispatch_async(serialQueue, ^(void){
            NSLog(@"startingSerialFirstBlock");
            NSDate *start = [NSDate date];
            for (id obj in _array) {
                for (int i = 0; i < kSubCounter; i++) {
                    //Do something
                }
            }
            NSDate *stop = [NSDate date];
            NSLog(@"finishSerialFirstBlock:%.4f", [stop timeIntervalSinceReferenceDate] - [start timeIntervalSinceReferenceDate]);
        });
        
        NSLog(@"loadSerialSecondBlock");
        dispatch_async(serialQueue, ^{
            NSLog(@"startingSerialSecondBlock");
            NSDate *start = [NSDate date];
            [_array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                for (int i = 0; i < kSubCounter; i++) {
                    //Do something
                }
            }];
            NSDate *stop=[NSDate date];
            NSLog(@"finishSerialSecondBlock %.4f",[stop timeIntervalSinceReferenceDate]-[start timeIntervalSinceReferenceDate]);
        });
        
        //Concurrent Queues
        NSLog(@"loadConcurrentFirstBlock");
        dispatch_async(concurrentQueue, ^{
            NSLog(@"startingConcurrentFirstBLock");
            NSDate *start = [NSDate date];
            for (id obj in _array){
                for (int i = 0; i < kSubCounter; i++) {
                    //Do something
                }
            }
            NSDate *stop=[NSDate date];
            NSLog(@"finishConcurrentFirstBlock %.4f",[stop timeIntervalSinceReferenceDate]-[start timeIntervalSinceReferenceDate]);
        });
        
        NSLog(@"loadConcurrentSecondBlock");
        dispatch_async(concurrentQueue, ^{
            NSLog(@"startingConcurrentSecondBlock");
            NSDate *start = [NSDate date];
            [_array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                for (int i = 0; i < kSubCounter; i++) {
                    //Do something
                }
            }];
            NSDate *stop=[NSDate date];
            NSLog(@"finishConcurrentSecondBlock %.4f",[stop timeIntervalSinceReferenceDate]-[start timeIntervalSinceReferenceDate]);
        });
        
        dispatch_release(serialQueue);
        dispatch_release(concurrentQueue);
    }];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 280, 300, 150)];
    [self.view addSubview:slider];
    [slider release];
    
    [slider setMinimumValue:0.0];
    [slider setMaximumValue:100.0];
    [slider setValue:30.0];
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

#pragma mark - dealloc

- (void)dealloc
{
    [_array release];
    [_label release];
    
    [super dealloc];
}

@end
