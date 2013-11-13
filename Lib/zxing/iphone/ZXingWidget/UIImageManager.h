//
//  UIImageManager.h
//  ZXingWidget
//
//  Created by leihui on 13-8-28.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageManager : NSObject

+ (UIImageManager *)shareInstance;
- (UIImage *)imageWithFileName:(NSString *)name;
- (UIImage *)imageWithFilePath:(NSString *)path;

@end
