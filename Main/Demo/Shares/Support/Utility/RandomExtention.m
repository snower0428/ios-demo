//
//  RandomExtention.m
//  test2
//
//  Created by zhangtianfu on 11-4-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RandomExtention.h"

//！随机数的最大值
#define ARC4RANDOM_MAX      0x100000000

@implementation RandomExtention




+ (NSInteger)createRandomsizeValueInt:(NSInteger)fromInt toInt:(NSInteger)toInt
{
    if (toInt <= fromInt)
    {
        return toInt;
    }else {
		NSInteger randVal = arc4random() % (toInt - fromInt + 1) + fromInt;
		return randVal;
	}
}

+ (double)createRandomsizeValueFloat:(double)fromFloat toFloat:(double)toFloat
{
    if (toFloat < fromFloat)
    {
        return toFloat;
    }else {
		double randVal = ((double)arc4random() / ARC4RANDOM_MAX) * (toFloat - fromFloat) + fromFloat;
		return randVal;
	}
}

@end
