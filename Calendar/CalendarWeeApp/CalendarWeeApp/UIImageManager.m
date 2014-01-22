//
//  UIImageManager.m
//  ZXingWidget
//
//  Created by leihui on 13-8-28.
//
//

#import "UIImageManager.h"

#define kDefaultImagePath   [NSString stringWithFormat:@"%@/Resource", [[NSBundle bundleWithIdentifier:@"com.91.sj.CalendarWeeApp"] resourcePath]]

static UIImageManager *kImageManager = nil;

@interface UIImageManager ()

- (NSString *)getiPhone5FileName:(NSString *)name;

@end

@implementation UIImageManager

- (id)init
{
    self = [super init];
    if (self) {
        // Init
    }
    
    return self;
}

+ (UIImageManager *)shareInstance
{
    @synchronized(self)
    {
        if (nil == kImageManager) {
            kImageManager = [[UIImageManager alloc] init];
        }
    }
    return kImageManager;
}

+ (void)exitInstance
{
    @synchronized(self)
    {
        if (kImageManager != nil) {
            [kImageManager release];
            kImageManager = nil;
        }
    }
}

- (UIImage *)imageWithFileName:(NSString *)name
{
	if(name == nil) {
		return nil;
    }
    
	NSString *finName = name;
    UIImage *image = nil;
    
    if (iPhone5) {
        NSString *finName5 = [self getiPhone5FileName:name];
        image = [UIImage imageWithContentsOfFile:[kDefaultImagePath stringByAppendingPathComponent:finName5]];
        if (image) {
            return image;
        }
    }
    
    if (finName) {
//        NSString *filePath = [kDefaultImagePath stringByAppendingPathComponent:finName];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            NSLog(@"file Exist");
//        }
//        else {
//            NSLog(@"file not Exist");
//        }
//        NSLog(@"filePath:%@", filePath);
        NSLog(@"filePath:%@", [kDefaultImagePath stringByAppendingPathComponent:finName]);
        return [UIImage imageWithContentsOfFile:[kDefaultImagePath stringByAppendingPathComponent:finName]];
    }
    
    return nil;
}

- (UIImage *)imageWithFilePath:(NSString *)path
{
	if(path == nil) {
		return nil;
    }
    
	NSString *finName = path;
    UIImage *image = nil;
    if (iPhone5)
    {
        NSString *finName5 = [self getiPhone5FileName:finName];
        image = [UIImage imageWithContentsOfFile:finName5];
        if (image) {
            return image;
        }
    }
    
    return [UIImage imageWithContentsOfFile:finName];
}

- (NSString *)getiPhone5FileName:(NSString *)name
{
	if (name != nil)
	{
		NSString *nameEx = [name pathExtension];
		int nameExLen = [nameEx length];
		int nameLen = [name length];
		int index = nameLen - nameExLen - 1;
		if ((index < 0)||(index > nameLen))
		{
			return name;
		}
		NSString *subStr = [name substringToIndex:index];
		NSString *finStr = [subStr stringByAppendingFormat:@"-568h.%@",nameEx];
		return finStr;
	}
	return name;
}

#pragma mark - dealloc

- (void)dealloc
{
    [super dealloc];
}

@end
