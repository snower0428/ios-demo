//
//  NSThreadViewCtrl2.h
//  Demo
//
//  Created by leihui on 13-8-19.
//
//

#import <UIKit/UIKit.h>

@interface NSThreadViewCtrl2 : UIViewController
{
    int     _tickets;
    int     _count;
    
    NSThread        *_ticketsThread1;
    NSThread        *_ticketsThread2;
    NSCondition     *_ticketsCondition;
    NSLock          *_theLock;
}

@end
