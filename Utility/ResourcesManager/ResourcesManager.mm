//
//  ResourcesManager.mm
//

#import "ResourcesManager.h"

@implementation ResourcesManager

static ResourcesManager *kShareResourcesManagerInstance = nil;

+ (ResourcesManager *)shareInstance;
{
	@synchronized([ResourcesManager class])
	{
		if (!kShareResourcesManagerInstance) {
			kShareResourcesManagerInstance = [[self alloc] init];
		}
		return kShareResourcesManagerInstance;
	}
	return self;
}

+ (id)alloc
{
	@synchronized([ResourcesManager class])
	{
		if (!kShareResourcesManagerInstance) {
			kShareResourcesManagerInstance = [super alloc];
        }
		return kShareResourcesManagerInstance;
	}
	return self;
}

- (id)init
{
	if (self = [super init]) 
	{
		_resourcePath = [[NSString stringWithFormat:@"%@/Resource/Image", [[NSBundle mainBundle] resourcePath]] copy];
	}
	return self;
}

#pragma mark - Private

- (NSString *)get2X:(NSString *)name
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
		NSString *finStr = [subStr stringByAppendingFormat:@"@2x.%@",nameEx];
		return finStr;
	}
	return name;
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

- (UIImage *)imageWithFileName:(NSString *)name
{
	if(name == nil) {
		return nil;
    }
    
	NSString *finName = name;
    UIImage *image = nil;
    if (iPhone5)
    {
        NSString *finName5 = [self getiPhone5FileName:name];
        image = [UIImage imageWithContentsOfFile:[_resourcePath stringByAppendingPathComponent:finName5]];
        if (image) {
            return image;
        }
    }
    
    if (finName) {
        return [UIImage imageWithContentsOfFile:[_resourcePath stringByAppendingPathComponent:finName]];
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

#pragma mark - dealloc

-(void)dealloc
{
	kShareResourcesManagerInstance = nil;
	[_resourcePath release];
    
	[super dealloc];
}

@end
