//
//  RandomExtention.h
//  
//  功能：求某个整数或者浮点数之间的随机数
//
//  Created by zhangtianfu on 11-4-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RandomExtention : NSObject {

}
+ (NSInteger)createRandomsizeValueInt:(NSInteger)fromInt toInt:(NSInteger)toInt;
+ (double)createRandomsizeValueFloat:(double)fromFloat toFloat:(double)toFloat;
@end
