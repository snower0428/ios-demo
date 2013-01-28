//
//  FlowerFly.h
//  FlowerDown
//
//  Created by qq on 11-9-8.
//  Copyright 2011 __ZX_Huang__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define flowerNum 30

#define timeInv 0.03

@interface FlowerFly : UIView {

	NSMutableArray *m_array;
	
	NSTimer *m_timer;
	
	int m_flowerIndex;
	float m_timeAdd;
	
	float m_changeSpeed;//多久改变一次方向
	float m_changeSpeedAdd;
}

-(void)initWithArray:(NSArray *)imageArray;
-(void)startTimer;
-(void)stopTimer;
@end
