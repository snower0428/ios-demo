//
//  ResourcesManager.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResourcesManager : NSObject 
{
	NSString *_resourcePath;
}

+ (ResourcesManager *)shareInstance;
- (UIImage *)imageWithFileName:(NSString *)name;
- (UIImage *)imageWithFilePath:(NSString *)path;

@end
