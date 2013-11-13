//
//  GCDViewCtrl.m
//  Demo
//
//  Created by leihui on 13-8-20.
//
//

#import "GCDViewCtrl.h"

#define kURL    @"http://img.wallpapersking.com/Big6/640960/2010513/2040002.jpg"

@interface GCDViewCtrl ()

@end

@implementation GCDViewCtrl

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
    
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgImageView];
    
    /**
     *  1. 常用的方法dispatch_async
     *  代码结构如下：
     *
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
            });
        });
     *
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSURL *url = [NSURL URLWithString:kURL];
        NSData *data = [[[NSData alloc] initWithContentsOfURL:url] autorelease];
        UIImage *image = [[[UIImage alloc] initWithData:data] autorelease];
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                _bgImageView.image = image;
            });
        }
    });
    
    /**
     *  2. dispatch_group_async的使用
     *  dispatch_group_async可以实现监听一组任务是否完成，完成后得到通知执行其他的操作。
     *  这个方法很有用，比如你执行三个下载任务，当三个任务都下载完成后你才通知界面说完成的了。
     */
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group, queue, ^(void) {
//        [NSThread sleepForTimeInterval:1.0];
//        NSLog(@"group1");
//    });
//    
//    dispatch_group_async(group, queue, ^(void) {
//        [NSThread sleepForTimeInterval:2.0];
//        NSLog(@"group2");
//    });
//    
//    dispatch_group_async(group, queue, ^(void) {
//        [NSThread sleepForTimeInterval:3.0];
//        NSLog(@"group3");
//    });
//    
//    dispatch_group_notify(group, queue, ^(void) {
//        NSLog(@"upateUI");
//    });
    
    /**
     *  3. dispatch_barrier_async的使用
     *  dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行。
     */
//    dispatch_queue_t queue = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"dispatch_async1");
//    });
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:4];
//        NSLog(@"dispatch_async2");
//    });
//    dispatch_barrier_async(queue, ^{
//        NSLog(@"dispatch_barrier_async");
//        [NSThread sleepForTimeInterval:4];
//        
//    });
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:1];
//        NSLog(@"dispatch_async3");
//    });
    
    /**
     *  4. dispatch_apply
     *  执行某个代码片段N次。
     */
//    dispatch_apply(5, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//        NSLog(@"dispatch_apply: %lu", index);
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc
{
    [_bgImageView release];
    
    [super dealloc];
}

@end
