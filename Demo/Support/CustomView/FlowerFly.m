//
//  FlowerFly.m
//  FlowerDown
//
//  Created by qq on 11-9-8.
//  Copyright 2011 __ZX_Huang__. All rights reserved.
//

#import "FlowerFly.h"
#import <QuartzCore/QuartzCore.h>
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation FlowerFly


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
	{
        // Initialization code
		
		}
	
    return self;
}

-(void)initWithArray:(NSArray *)imageArray
{
	self.userInteractionEnabled = NO;
	
	int count = [imageArray count];
	m_changeSpeed = (arc4random()%200)/50.0f-2;
	m_flowerIndex = 0;
	m_changeSpeedAdd  = 0;
	m_array = [[NSMutableArray alloc] initWithCapacity:flowerNum];
	
	for (int i = 0; i < flowerNum; i++)
	{
		int flag = arc4random()%count;
		UIImage *image = [imageArray objectAtIndex:flag];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.tag = i+1;
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		float x_speed = (arc4random()%100)/50.0f+2;
		[dic setObject:[NSNumber numberWithFloat:x_speed] forKey:@"speed"];
		float y_speed = (arc4random()%100)/100.0f+2;
		[dic setObject:[NSNumber numberWithFloat:y_speed] forKey:@"y_speed"];
		[dic setObject:imageView forKey:@"image"];
		[self addSubview:imageView];
		[imageView release];
		
		imageView.frame = CGRectMake(0, -100, image.size.width, image.size.height);
		imageView.hidden = YES;
		
		[m_array addObject:dic];
		[dic release];
		CABasicAnimation *theAnimation; 
		[CATransaction begin];
		theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; 
		theAnimation.duration=arc4random()%100/50+3;  
		theAnimation.repeatDuration = 100e+10;
		theAnimation.autoreverses=YES;
		float a = arc4random()%10/25.0+0.4;
		
		theAnimation.fromValue=[NSNumber numberWithFloat:a]; 
		theAnimation.toValue=[NSNumber numberWithFloat:-a];
		[imageView.layer addAnimation:theAnimation forKey:@"myrotation"];
		
		[CATransaction commit];
	}	
}

-(void)startTimer
{
	if(m_timer)
		[m_timer invalidate];
	
	m_timer = [NSTimer scheduledTimerWithTimeInterval:timeInv target:self selector:@selector(update) userInfo:nil repeats:YES];
}
-(void)stopTimer
{
	if(m_timer)
	{
		[m_timer invalidate];
		m_timer = nil;
		
		for (int i = 0; i < flowerNum; i++)
		{
			NSMutableDictionary *dic = [m_array objectAtIndex:i];
			UIImageView *imageView = [dic objectForKey:@"image"];
			[imageView.layer removeAllAnimations];
		}
	}
}
-(void)update
{
	m_timeAdd += timeInv;
	m_changeSpeedAdd += timeInv;
	if(m_timeAdd > 0.8)
	{
		NSDictionary *dic = [m_array objectAtIndex:m_flowerIndex];
		UIImageView *imageView = [dic objectForKey:@"image"];
		imageView.hidden = NO;
		
		int width = self.frame.size.width+500;
		int x = arc4random()%width-800;
		CGRect rect = imageView.frame;
		rect.origin.x = x;
		rect.origin.y = -50;
		imageView.frame = rect;
		m_timeAdd = 0;
		
		m_flowerIndex ++;
		if(m_flowerIndex == flowerNum)
			m_flowerIndex = 0;
	}
	
	for (int i = 0; i < flowerNum; i++)
	{
		NSMutableDictionary *dic = [m_array objectAtIndex:i];
		UIImageView *imageView = [dic objectForKey:@"image"];
		if(imageView.hidden == NO)
		{

			float x_speed = [[dic objectForKey:@"speed"] floatValue];
			float y_speed = [[dic objectForKey:@"y_speed"] floatValue];

			CGRect rect = imageView.frame;
			rect.origin.y += y_speed;
			rect.origin.x += x_speed;
			
			UIImage *image = imageView.image;
			rect.size.width = image.size.width;
			rect.size.height = image.size.height;
			imageView.frame = rect;

			if(rect.origin.y > self.frame.size.height + 100 || rect.origin.x > self.frame.size.width+100)
				imageView.hidden = YES;
		}
	}
}

- (void)dealloc {
	if(m_array)
	{
		[m_array release];
	}
    [super dealloc];
}


@end
