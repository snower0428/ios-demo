//
//  NSThreadViewCtrl2.m
//  Demo
//
//  Created by leihui on 13-8-19.
//
//

#import "NSThreadViewCtrl2.h"

@interface NSThreadViewCtrl2 ()

@end

@implementation NSThreadViewCtrl2

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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _tickets = 100;
    _count = 0;
    
    _theLock = [[NSLock alloc] init];
    _ticketsCondition = [[NSCondition alloc] init];
    
    _ticketsThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [_ticketsThread1 setName:@"Thread1"];
    [_ticketsThread1 start];
    
    _ticketsThread2 = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [_ticketsThread2 setName:@"Thread2"];
    [_ticketsThread2 start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)run
{
    while (TRUE) {
        // 上锁
//        [_ticketsCondition lock];
        [_theLock lock];
        if (_tickets >= 0) {
            [NSThread sleepForTimeInterval:0.09];
            _count = 100 - _tickets;
            NSLog(@"当前票数是:%d, 售出:%d, 线程名:%@", _tickets, _count, [[NSThread currentThread] name]);
            _tickets--;
        }
        else {
            break;
        }
        [_theLock unlock];
//        [_ticketsCondition unlock];
    }
}

- (void)stopThread
{
    if (_ticketsThread1) {
        [_ticketsThread1 cancel];
        [_ticketsThread1 release];
        _ticketsThread1 = nil;
    }
    
    if (_ticketsThread2) {
        [_ticketsThread2 cancel];
        [_ticketsThread2 release];
        _ticketsThread2 = nil;
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [self stopThread];
    [_theLock release];
    [_ticketsCondition release];
    
    [super dealloc];
}

@end
