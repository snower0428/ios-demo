//
//  Category.mm
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-1.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//

#import "Category.h"
#import "GTMBase64Ex.h"

#pragma mark ----------NSData---------------

@implementation NSData(Extention)

//	对data进行AES加密/解密; key最长32位
- (NSData *)AES256_CCOperation:(CCOperation)operation withKey:(NSString *)key32{
	NSData *returnData = nil;
	
	char keyPtr[kCCKeySizeAES256+1];
	bzero(keyPtr, sizeof(keyPtr));
	[key32 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesOfBufferOpeation = 0;
	CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr, kCCBlockSizeAES128,
										  NULL,
										  [self bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesOfBufferOpeation);
	
	if (cryptStatus == kCCSuccess) {
		returnData  = [[[NSData alloc] initWithBytes:buffer length:numBytesOfBufferOpeation] autorelease];
	}else if (cryptStatus == kCCParamError){
		NSLog(@"PARAM ERROR");
	}else if (cryptStatus == kCCBufferTooSmall){
		NSLog(@"BUFFER TOO SMALL");
	}else if (cryptStatus == kCCMemoryFailure){
		NSLog(@"MEMORY FAILURE");
	}else if (cryptStatus == kCCAlignmentError){ 
		NSLog(@"ALIGNMENT");
	}else if (cryptStatus == kCCDecodeError){
		NSLog(@"DECODE ERROR");
	}else if (cryptStatus == kCCUnimplemented){ 
		NSLog(@"UNIMPLEMENTED"); 
	}
	
	free(buffer);
	
	return returnData;
}


//	对data进行DES加密/解密; key最长8位
- (NSData *)DES_CCOperation:(CCOperation)operation withKey:(NSString *)key8{
	NSData *returnData = nil;
	
	char keyPtr[kCCKeySizeDES+1];
	bzero(keyPtr, sizeof(keyPtr));
	[key8 getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	size_t bufferSize = dataLength + kCCBlockSizeDES;
	void *buffer = malloc(bufferSize);
	
    //Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
	size_t numBytesOfBufferOpeation = 0;
	CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmDES,
										  kCCOptionPKCS7Padding|kCCOptionECBMode ,
										  keyPtr, kCCBlockSizeDES,
										  NULL,
										  [self bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesOfBufferOpeation);
	
	if (cryptStatus == kCCSuccess) {
		returnData  = [[[NSData alloc] initWithBytes:buffer length:numBytesOfBufferOpeation] autorelease];
	}else if (cryptStatus == kCCParamError){
		NSLog(@"PARAM ERROR");
	}else if (cryptStatus == kCCBufferTooSmall){
		NSLog(@"BUFFER TOO SMALL");
	}else if (cryptStatus == kCCMemoryFailure){
		NSLog(@"MEMORY FAILURE");
	}else if (cryptStatus == kCCAlignmentError){ 
		NSLog(@"ALIGNMENT");
	}else if (cryptStatus == kCCDecodeError){
		NSLog(@"DECODE ERROR");
	}else if (cryptStatus == kCCUnimplemented){ 
		NSLog(@"UNIMPLEMENTED"); 
	}

	free(buffer);
	
	return returnData;
}

@end




#pragma mark ----------UIScreen---------------
//@implementation UIScreen(scale)
//- (BOOL)isRetina{
//	if ([UIScreen instancesRespondToSelector:@selector(scale)]){
//		float scale = [[UIScreen mainScreen] scale];
//		return (scale == 2.0);
//	}else {
//		return NO;
//	}
//}
//@end

#pragma mark ----------UIImage---------------

//@implementation UIImage(Extention)
//
//+ (id)imageFile:(NSString*)file{
//    UIImage *image = nil;
//    if (file) {
//        if ([file isAbsolutePath]) {
//            image = [UIImage imageWithContentsOfFileEx:file];
//        }else{
//            image = [UIImage imageNamed:file];
//        }
//    }
//    return image;
//}
//
//- (id)initWithContentsOfFileEx:(NSString *)path{
//	NSString *dstPath = path;
//	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//	
//	if (version <4.1f && path && [[UIScreen mainScreen] isRetina]) {
//		NSRange range = [path rangeOfString:@"@2x"];
//		if (range.location == NSNotFound) {
//			NSString *retinaPath = [NSString stringWithFormat:@"%@@2x.%@",[path stringByDeletingPathExtension], [path pathExtension]];
//			if ([[NSFileManager defaultManager] fileExistsAtPath:retinaPath]){//需要加上@2x后缀
//				dstPath = retinaPath;
//			}
//		}
//	}
//	
//	return [self initWithContentsOfFile:dstPath];
//}
//
//+ (UIImage*)imageWithContentsOfFileEx:(NSString *)path{
//
//	NSString *dstPath = path;
//	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//	
//	if (version <4.1f && path && [[UIScreen mainScreen] isRetina]) {
//		NSRange range = [path rangeOfString:@"@2x"];
//		if (range.location == NSNotFound) {
//			NSString *retinaPath = [NSString stringWithFormat:@"%@@2x.%@",[path stringByDeletingPathExtension], [path pathExtension]];
//			if ([[NSFileManager defaultManager] fileExistsAtPath:retinaPath]){//需要加上@2x后缀
//				dstPath = retinaPath;
//			}
//		}
//	}
//	
//	return [UIImage imageWithContentsOfFile:dstPath];
//}
//
////缩放图片并且添加相应的边框
//- (UIImage*)resizeImage:(CGSize)imageSize color:(UIColor*)borderColor width:(float)borderWidth height:(float)borderHeight{
//	CGRect fullRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//	
//	//modify by ztf 2011.11.2
//	if (UIGraphicsBeginImageContextWithOptions) {
//		UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.scale);
//    }else{
//        UIGraphicsBeginImageContext(imageSize);
//    }
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetBlendMode(context, kCGBlendModeNormal);
//	CGContextSetRGBFillColor(context, [borderColor red], [borderColor green], [borderColor blue], [borderColor alpha]);
//	CGContextAddRect(context,fullRect);
//	CGContextFillPath(context);
//	[self drawInRect:CGRectInset(fullRect, borderWidth, borderHeight)];
//	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	return retImage;
//}
//
////缩放图片并且添加相应的边框（直接操作view截屏，可能效率低）
//- (UIImage*)resizeImageEx:(CGSize)imageSize color:(UIColor*)borderColor width:(float)borderWidth height:(float)borderHeight{
//	CGRect fullRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//	
//	UIView *container = [[UIView alloc] initWithFrame:fullRect];
//	container.backgroundColor = borderColor;
//	UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
//	[imageView setFrame:CGRectInset(fullRect, borderWidth, borderHeight)];
//	[container addSubview:imageView];
//	
//	//modify by ztf 2011.11.2
//	if (UIGraphicsBeginImageContextWithOptions) {
//		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    }else{
//        UIGraphicsBeginImageContext(imageSize);
//    }   
//	[container.layer renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	[container release];
//	[imageView release];
//	
//	return retImage;
//}
//
////缩放图片，并且添加圆角
//- (UIImage*)resizeImage:(CGSize)imageSize cornerRadius:(float)cornerRadius{
//	UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
//	[imageView setFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//	imageView.layer.masksToBounds = YES;
//	imageView.layer.cornerRadius = cornerRadius;
//	
//	//modify by ztf 2011.11.2
//	if (UIGraphicsBeginImageContextWithOptions) {
//		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    }else{
//        UIGraphicsBeginImageContext(imageSize);
//    }   
//	[imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	[imageView release];
//	return retImage;
//}
//
//- (UIImage*)clipImageWithRate:(float)rate{
//    
//    float imageRate = self.size.width/self.size.height;
//    
//    if (imageRate == rate) {
//        return self;
//    }
//    
//    float originWidth = self.size.width;
//    float originHeight = self.size.height;
//    float destWidth = originWidth;
//    float destHeight = originHeight;
//    if (imageRate > rate) {
//        destWidth = originHeight*rate;
//    }else{
//        destHeight = originWidth*rate;
//    }
//    float xOffset = (originWidth - destWidth)/2;
//    float yOffset = (originHeight - destHeight)/2;
//    CGRect rect = CGRectMake(xOffset, yOffset, destWidth, destHeight);
//    
//    CGImageRef imageRef =  CGImageCreateWithImageInRect(self.CGImage, rect);
//    UIImage *destImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
//    CGImageRelease(imageRef);
//    return destImage;
//}
//
//@end


#pragma mark -----------UIView----------------
//@implementation UIView(Extention)
//
//- (id)viewController{
//	id responder = self;
//	while (responder && ![responder isKindOfClass:[UIViewController class]]) {
//		responder = [responder nextResponder];
//	}
//	
//	if ([responder isKindOfClass:[UIViewController class]]) {
//		return responder;
//	}else{
//		return nil;
//	}
//}
//
//- (UIImage*)captureScreen{
//    CGSize imageSize = self.frame.size;
//    
//    //begin
//    if (UIGraphicsBeginImageContextWithOptions) {
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    }else{
//        UIGraphicsBeginImageContext(imageSize);
//    }   
//    
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //end
//    UIGraphicsEndImageContext();
//
//    return retImage;
//}
//
//- (void)setPosition:(CGPoint)pt{
//    self.frame = CGRectMake(pt.x, pt.y, self.frame.size.width, self.frame.size.height);
//}
//
//- (void)scaleFrameWithSize:(CGSize)size{
//    if (CGSizeEqualToSize(size, CGSizeZero)) {
//        return;
//    }
//    if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
//        return;
//    }
//
//    CGPoint center = self.center;
//    
//    float width = self.frame.size.width;
//    float height = self.frame.size.height;
//    float sizeWidth = size.width;
//    float sizeHeight = size.height;
//    float xScale = sizeWidth / width;
//    float yScale = sizeHeight / height;
//    if (xScale>yScale) {
//        height = sizeHeight / sizeWidth * width;
//    }else {
//        width = sizeWidth / sizeHeight * height;
//    }
//    
//    //ajustSize
//    CGRect frame = self.frame;
//    frame.size = CGSizeMake(width, height);
//    self.frame = frame;
//    //ajustPositon
//    self.center = center;
//}
//
//@end

#pragma mark -----------NSString----------------
//#import <CommonCrypto/CommonDigest.h>
//
//@implementation  NSString(Extention)
//
//- (NSString *)md5Digest{
//    const char *cStr = [self UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
//    CC_MD5( cStr, strlen(cStr), result );
//    return [[NSString stringWithFormat:
//            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
//            ] lowercaseString];
//}
//
//- (NSString *)md5:(NSString *)str
//{    
//    const char *cStr = [str UTF8String];    
//    unsigned char result[CC_MD5_DIGEST_LENGTH];    
//    CC_MD5( cStr, strlen(cStr), result );    
//    
//    NSMutableString *hash = [NSMutableString string];  
//    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)  
//    {  
//        [hash appendFormat:@"%02X",result[i]];  
//    }  
//    return [hash lowercaseString];  
//}  
//#define CHUNK_SIZE 1024    
//- (NSString *)file_md5:(NSString *)path  
//{    
//    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];    
//    if(handle == nil)    
//        return nil;    
//    
//    CC_MD5_CTX md5_ctx;    
//    CC_MD5_Init(&md5_ctx);    
//    
//    NSData* filedata;    
//    do {    
//        filedata = [handle readDataOfLength:CHUNK_SIZE];    
//        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);    
//    }    
//    while([filedata length]);    
//    
//    unsigned char result[CC_MD5_DIGEST_LENGTH];    
//    CC_MD5_Final(result, &md5_ctx);    
//    
//    [handle closeFile];    
//    
//    NSMutableString *hash = [NSMutableString string];  
//    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)  
//    {  
//        [hash appendFormat:@"%02x",result[i]];  
//    }  
//    return [hash lowercaseString];  
//}  
//
//    /*对字符串的base64编码和解码（原始值必须是字符串）*/
//- (NSString *)encodeBase64{   
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    return [GTMBase64Ex stringByEncodingData:data];
//}
//
//- (NSString *)decodeBase64{
//    NSData *data = [GTMBase64Ex decodeString:self];
//    return  [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//}
//
//    /*对URL进行编码和解码*/
//- (NSString *)encodeURL{
//    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
//
//- (NSString *)decodeURL{
//    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
//
//- (NSString *)encodeURLParam{
//    	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, 
//                                                                     (CFStringRef)self, 
//                                                                     NULL, 
//                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),//CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), 
//                                                                     kCFStringEncodingUTF8) autorelease];
//}
//
//- (NSString *)addURLKey:(NSString*)key value:(NSString*)value{
//    NSMutableString *URLString = [NSMutableString stringWithString:self];
//    if (key && value) {
//        if (![self hasSuffix:@"&"] && ![self hasSuffix:@"?"]) {
//            [URLString appendString:@"&"];
//        }
//        [URLString appendString:key];
//        [URLString appendString:@"="];
//        [URLString appendString:value];
//    }
//    return URLString;
//}
//
//    /*对字符串的DES加密和解密（原始值必须是字符串）*/
//- (NSString*)DES_EncryptWithKey:(NSString *)key8{
//    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *outputData = [inputData DES_CCOperation:kCCEncrypt withKey:key8];
//    return [GTMBase64Ex stringByEncodingData:outputData];
//}
//
//- (NSString *)DES_DecryptWithKey:(NSString *)key8{
//    NSData *inputData = [GTMBase64Ex decodeString:self];
//    NSData *outputData = [inputData DES_CCOperation:kCCDecrypt withKey:key8];
//    return  [[[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding] autorelease];
//}
//
//
//    //获取符合key的字符串
//- (NSString *)getStringFromCharacterSet:(NSString*)characterSet{	
//	if ([self length] == 0) {
//		return nil;
//	}
//	
//	NSMutableString *strippedString = [NSMutableString  stringWithCapacity:self.length];
//
//	NSScanner *scanner = [NSScanner scannerWithString:self];
//	NSCharacterSet *numbers = [NSCharacterSet  characterSetWithCharactersInString:characterSet];
//
//	while ([scanner isAtEnd] == NO) {
//		NSString *buffer = nil;
//		if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
//			[strippedString appendString:buffer];
//			buffer = nil;
//		} else {
//			[scanner setScanLocation:([scanner scanLocation] + 1)];
//		}
//	}
//
//	return ([strippedString length]>0) ? [NSString stringWithString:strippedString] : nil;
//}
//
//- (NSString *)getNumberString{					//获取纯数字
//	return [self getStringFromCharacterSet:@"0123456789"];
//}
//
//- (NSString *)getIntString{					//获取int
//	return [self getStringFromCharacterSet:@"0123456789-"];
//}
//
//- (NSString *)getFloatString{					//获取float
//	return [self getStringFromCharacterSet:@"0123456789-."];
//}
//
////是否是中文标点
//- (BOOL)isChineseSymbol{
//    NSString *key = @" ，。；！？“”‘’－｀～｜、⋯";
//    if ([self getStringFromCharacterSet:key]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//
////恢复回车换行符号（从配置文件读取会在换行符号前增加一个"\n"）
//- (NSString*)restoreEnterSymbol{
//    if (nil == self) {
//        return nil;
//    }
//    NSString *t1 = [self stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
//    NSString *t2 = [t1 stringByReplacingOccurrencesOfString:@"\\r" withString:@"\n"];
//    NSString *t3 = [t2 stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//    return  t3;
//}
//
////删除换行字符
//- (NSString*)removeEnterSymbol{
//    if (nil == self) {
//        return nil;
//    }
//    NSString *t = [[self restoreEnterSymbol] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    return  t;
//}
//
//- (UIColor*)getColor{
//	UIColor *color = nil;
//	
//	NSArray *array = [self componentsSeparatedByString:@","];
//	int count = [array count];
//	if (count >=3) {
//		float r = [[array objectAtIndex:0] floatValue];
//		float g = [[array objectAtIndex:1] floatValue];
//		float b = [[array objectAtIndex:2] floatValue];
//		float a = (count>=4 ? [[array objectAtIndex:3] floatValue] : 1);
//		color = RGBA(r, g, b, a);
//	}
//	
//	return color;
//}
//
//- (NSString *)getValueFromURLForKey:(NSString *)key{
//	if (nil == key) {
//		return nil;
//	}
//	
//	int index = [self rangeOfString:@"?" options:NSCaseInsensitiveSearch].location;
//	if (index == NSNotFound){
//		return nil;
//	}
//	
//	NSString *paramList = [self substringFromIndex:index+1];
//	NSArray *array = [paramList componentsSeparatedByString:@"&"];
//	int minlen = [key length] + 1;
//	for (NSString *item in array){
//		if ([item length] > minlen && ([key caseInsensitiveCompare:[item substringToIndex:minlen-1]] == NSOrderedSame)){
//			int index = [item rangeOfString:@"=" options:NSCaseInsensitiveSearch].location;
//			NSString *first = [item substringToIndex:index];
//			if ([key caseInsensitiveCompare:first] == NSOrderedSame){
//				return [item substringFromIndex:index+1];
//			}
//		}
//	}
//	
//	return nil;
//}
//
//- (TransitionDirection)directionFromLeftValue{
//	int returnValue = 1;
//	
//	NSArray *values = [self componentsSeparatedByString:@","];
//	int count = [values count];
//	if (count>0) {
//		returnValue = [[values objectAtIndex:0] intValue];
//	}
//	
//	return (TransitionDirection)returnValue;
//}
//
//- (TransitionDirection)directionFromRightValue{
//	int returnValue = 0;
//	
//	NSArray *values = [self componentsSeparatedByString:@","];
//	int count = [values count];
//	if (count>1) {
//		returnValue = [[values objectAtIndex:1] intValue];
//	}
//	
//	return (TransitionDirection)returnValue;
//}
//
//- (BOOL)isFile{
//	BOOL ret = NO;
//	BOOL isDirectory = YES;
//	
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	if ([fileManager fileExistsAtPath:self isDirectory:&isDirectory] && !isDirectory)
//	{
//		ret = YES;
//	}
//	else
//	{
//		ret = NO;
//	}
//	
//	return ret;
//}
//
//- (NSString*)formatNumber{
//    int length = [self length];
//    if (length <= 3) {
//        return self;
//    }
//    
//    NSMutableString *string = [NSMutableString stringWithString:self];
//    int count = (length-1)/3;
//    int index = (length-1)%3+1;
//    for (int i=0; i<count; i++) {
//        [string insertString:@"," atIndex:index+i];
//        index += 3;
//    }
//    
//    return string;
//}
//
//- (NSString *)formatVersion{
//	NSRange firstDotRange = [self rangeOfString:@"."];
//	if (firstDotRange.location == NSNotFound){
//		return self;
//	}else{
//		NSRange searchRange = NSMakeRange(firstDotRange.location+1, [self length]-firstDotRange.location-1);
//		NSString *dstVersion = [self stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:searchRange];
//		return dstVersion;
//	}
//}
//
//
//
//@end

#pragma mark -----------UIColor----------------
@implementation UIColor(Extention)

- (CGColorSpaceModel) colorSpaceModel  
{  
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));  
}  

- (NSString *) colorSpaceString  
{  
    switch ([self colorSpaceModel])  
    {  
        case kCGColorSpaceModelUnknown:  
            return @"kCGColorSpaceModelUnknown";  
        case kCGColorSpaceModelMonochrome:  
            return @"kCGColorSpaceModelMonochrome";  
        case kCGColorSpaceModelRGB:  
            return @"kCGColorSpaceModelRGB";  
        case kCGColorSpaceModelCMYK:  
            return @"kCGColorSpaceModelCMYK";  
        case kCGColorSpaceModelLab:  
            return @"kCGColorSpaceModelLab";  
        case kCGColorSpaceModelDeviceN:  
            return @"kCGColorSpaceModelDeviceN";  
        case kCGColorSpaceModelIndexed:  
            return @"kCGColorSpaceModelIndexed";  
        case kCGColorSpaceModelPattern:  
            return @"kCGColorSpaceModelPattern";  
        default:  
            return @"Not a valid color space";  
    }  
}  

- (CGFloat) red  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    return c[0];  
}  

- (CGFloat) green  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];  
    return c[1];  
}  

- (CGFloat) blue  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];  
    return c[2];  
}  

- (CGFloat) alpha  
{  
    const CGFloat *c = CGColorGetComponents(self.CGColor);  
    return c[CGColorGetNumberOfComponents(self.CGColor)-1];  
}  

@end

#pragma mark -----------NSDictionary----------------
@implementation NSDictionary(Extention)

- (UIImage*)getImageForKey:(NSString*)key resDirectory:(NSString*)resDirectory{
	NSString *imageName = [self objectForKey:key];
	NSString *imagePath = [resDirectory  stringByAppendingPathComponent:imageName];
	UIImage *image = [UIImage imageWithContentsOfFileEx:imagePath];
	if (imageName && !image) {
		WriteLog(@"%@ ========%@", key, imagePath);
	}
	
	return image;
}

- (UIImage*)getImageFromArray:(int)index forKey:(NSString*)key resDirectory:(NSString*)resDirectory{
	NSArray *images = [self objectForKey:key];
	int count = [images count];
	if (index == -1) {
		index = count-1;
	}
	
	if (index>=0 && index<count) {
		NSString *item = [images objectAtIndex:index];
		NSString *path = [resDirectory  stringByAppendingPathComponent:item];
		UIImage *image = [UIImage imageWithContentsOfFileEx:path];
		return image;
	}
	
	return nil;
}

- (NSArray*)getImagesForKey:(NSString*)key resDirectory:(NSString*)resDirectory{
	NSArray *images = [self objectForKey:key];
	if ([images isKindOfClass:[NSArray class]]) {
		return [images getImages:resDirectory];
	}else {
		return nil;
	}
}

- (CGRect)getRectForKey:(NSString*)key{
	NSString *frameString = [self objectForKey:key];
	CGRect  rect = CGRectFromString(frameString);
	return rect;
}

- (CGRect)getRectForKey:(NSString*)key fromImage:(UIImage*)image{
	CGRect  rect = [self getRectForKey:key];
	
	if (image) {
		if (rect.size.width == -1){
			rect.size.width = image.size.width;
		}
		
		if (rect.size.height == -1){
			rect.size.height = image.size.height;
		}
	}

	return rect;
}

- (Class)getPageViewClass{
	NSString *className = [self objectForKey:@"className"];
	if (self && nil == className) {
		className = @"PageView";
	}
	
	Class object= NSClassFromString(className);
	return object;
}

- (id)getValueWithLanguageType:(LanguageType)languageType{
	if (LanguageTypeEnglish == languageType){
		return [self objectForKey:@"EN"];
	}else if (LanguageTypezh_CN == languageType) {
		return [self objectForKey:@"CN"];
	}else if (LanguageTypezh_FT == languageType) {
		return  [self objectForKey:@"FT"];
	}
	
	return nil;
}

- (id)getLayersWithLanguageType:(LanguageType)languageType{
	if (LanguageTypeEnglish == languageType){
		return [self objectForKey:@"layers_EN"];
	}else if (LanguageTypezh_CN == languageType) {
		return [self objectForKey:@"layers_CN"];
	}else if (LanguageTypezh_FT == languageType) {
		return  [self objectForKey:@"layers_FT"];
	}
	
	return nil;
}

@end

#pragma mark -----------NSArray----------------
@implementation NSArray(Extention)

- (NSArray*)getImages:(NSString*)resDirectory{
	NSMutableArray *images = [NSMutableArray array];
	
	for (NSString *item in self){
		NSString *path = [resDirectory  stringByAppendingPathComponent:item];
		UIImage *image = [[UIImage alloc] initWithContentsOfFileEx:path];
		if (image){
			[images addObject:image];
			[image release];
		}else{
			WriteLog(@"images- ========%@",path);
		}
	}
	
	if ([images count] > 0) {
		return images;
	}else {
		return nil;
	}
}

@end

#pragma mark -----------UIDevice---------------
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define KNDWIFIID		@"01"	//ND WIFI标识
#define KNDCFUUID		@"02"	//ND cfuuid标识

static  NSString *kUDID = nil;
@implementation UIDevice(Extention)

- (NSString *)udid{
	if (kUDID) {
		return kUDID;
	}
    
    NSString *udid = [self uniqueIdentifier];
    
	if(udid == nil || [udid hasPrefix:@"5.0"] || [udid length] < 10){
		//wifi 
		NSString *macaddress = [[UIDevice currentDevice] macaddress];
		if (nil == macaddress) {
			//uuid
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSString *uuid = [defaults stringForKey:@"udid"];
			if (nil == uuid || [uuid length]<36) {
				//create uuid
                udid = [Utility GUIDString];
				//uuid+Base64+header
				NSString *uuidBase64 = [uuid encodeBase64];
				NSString *uuidBase64WithHeader = [KNDCFUUID stringByAppendingString:uuidBase64];
				//save to local
				[defaults setValue:uuidBase64WithHeader forKey:@"udid"];
				[defaults synchronize];
				kUDID = [uuidBase64WithHeader retain];
			}else {
				kUDID = [uuid retain];
			}
		}else {
			//wifi+Base64+header
			NSString *macaddressBase64 = [macaddress encodeBase64];
			NSString *macaddressBase64WithHeader = [KNDWIFIID stringByAppendingString:macaddressBase64];
			kUDID = [macaddressBase64WithHeader retain];
		}
	}else {
		kUDID = [udid retain];
	}

	return kUDID;
}

- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}


#include <sys/sysctl.h>  
#include <mach/mach.h>
- (double)availableMemory {
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

@end

#pragma mark --------------NSObject-----------------
@implementation NSObject(Extention)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects { 
    NSMethodSignature *signature = [self methodSignatureForSelector:selector]; 
    if (signature) { 
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature]; 
        [invocation setTarget:self]; 
        [invocation setSelector:selector]; 
        for(int i = 0; i < [objects count]; i++){ 
            id object = [objects objectAtIndex:i]; 
            [invocation setArgument:&object atIndex: (i + 2)];        
        } 
        [invocation invoke]; 
        
        if (signature.methodReturnLength) { 
            id anObject; 
            [invocation getReturnValue:&anObject]; 
            return anObject; 
        }
    } 
    
    return nil;
} 

- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay{
    block = [[block copy] autorelease];
    [self performSelector:@selector(invokeBlock:) withObject:block afterDelay:delay];
}

- (void)invokeBlock:(void(^)(void))block{
    if (block){
        block();
    }
}

@end

#pragma mark --------------UINavigationController-----------------------------
@implementation UINavigationController (Extention)
- (UIViewController*)rootViewController{
    NSArray *viewControllers = [self viewControllers];
    if ([viewControllers count] > 0) {
        return [viewControllers objectAtIndex:0];
    }
    return nil;
}
@end

#pragma mark --------------UIButton-----------------------------
@implementation UIButton (Extention)

#import <objc/runtime.h>
static NSString *KEY_UIBUTTON_BLOCK = @"UIBUTTON_BLOCK_KEY";

- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block{
    objc_setAssociatedObject(self, KEY_UIBUTTON_BLOCK, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(invokeBlock) forControlEvents:controlEvents];
}

- (void)invokeBlock{
    ButtonBlock block = objc_getAssociatedObject(self, KEY_UIBUTTON_BLOCK);
    if (block) {
        block();
    }
}

+ (id)buttonWithNormalFile:(NSString*)normalFile{
    return [self buttonWithNormalFile:normalFile downFile:nil disableFile:nil];
}

+ (id)buttonWithNormalFile:(NSString*)normalFile downFile:(NSString*)downFile{
    return [self buttonWithNormalFile:normalFile downFile:downFile disableFile:nil];
}

+ (id)buttonWithNormalFile:(NSString*)normalFile downFile:(NSString*)downFile disableFile:(NSString*)disableFile{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalFile) {
        UIImage *image = [UIImage imageFile:normalFile];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        }
    }
    if (downFile) {
        UIImage *image = [UIImage imageFile:downFile];
        if (image) {
            [btn setImage:image forState:UIControlStateHighlighted];
            if (nil == normalFile) {
                [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            }
        }
    }
    if (disableFile) {
        UIImage *image = [UIImage imageFile:disableFile];
        if (image) {
            [btn setImage:image forState:UIControlStateDisabled];
        }
    }
    
    return btn;
}

+ (id)buttonWithBackgroundNormalFile:(NSString*)normalFile{
    return [self buttonWithBackgroundNormalFile:normalFile downFile:nil disableFile:nil];
}

+ (id)buttonWithBackgroundNormalFile:(NSString*)normalFile downFile:(NSString*)downFile{
    return [self buttonWithBackgroundNormalFile:normalFile downFile:downFile disableFile:nil];
}

+ (id)buttonWithBackgroundNormalFile:(NSString*)normalFile downFile:(NSString*)downFile disableFile:(NSString*)disableFile{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (normalFile) {
        UIImage *image = [UIImage imageFile:normalFile];
        if (image) {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        }
    }
    if (downFile) {
        UIImage *image = [UIImage imageFile:downFile];
        if (image) {
            [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            if (nil == normalFile) {
                [btn setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            }
        }
    }
    if (disableFile) {
        UIImage *image = [UIImage imageFile:disableFile];
        if (image) {
            [btn setBackgroundImage:image forState:UIControlStateDisabled];
        }
    }
    
    return btn;
}

@end


#pragma mark --------------UIAlertView-----------------------------
static NSString *KEY_BLOCK_ITEM_LIST = @"KEY_BLOCK_ITEM_LIST";
@implementation UIAlertView (Extention)

+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title  
                               message:(NSString *)message{
    return [self showAlertViewWithTitle:title message:message cancelButtonItem:[BlockButtonItem itemWithTitle:@"确定" block:nil] otherButtonItems:nil];
}

+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title 
                               message:(NSString *)message 
                      cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
                      otherButtonItems:(BlockButtonItem *)otherButtonItems, ...{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:cancelButtonItem otherButtonItems:nil];
    if (otherButtonItems) {
        [alertView addButtonItem:otherButtonItems];
        
        va_list list;
        va_start(list, otherButtonItems);
        BlockButtonItem *item = nil;
        while ((item = va_arg(list, BlockButtonItem*))) {
            [alertView addButtonItem:item];
        }
        va_end(list);
    }
    [alertView show];
    [alertView release];
    return alertView;
}

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
   cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
   otherButtonItems:(BlockButtonItem *)otherButtonItems, ...
{
    if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonItem.title otherButtonTitles:nil]){
        NSMutableArray *buttonItems = [NSMutableArray array];
        if (cancelButtonItem) {
            [buttonItems addObject:cancelButtonItem];
        }
        
        objc_setAssociatedObject(self, KEY_BLOCK_ITEM_LIST, buttonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (otherButtonItems) {
            [self addButtonItem:otherButtonItems];
            
            va_list list;
            va_start(list, otherButtonItems);
            while (BlockButtonItem *item = va_arg(list, BlockButtonItem*)) {
                [self addButtonItem:item];
            }
            va_end(list);
        }
    }
    
    return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(ButtonBlock)block{
    return [self addButtonItem:[BlockButtonItem itemWithTitle:title block:block]];
}

- (NSInteger)addButtonItem:(BlockButtonItem *)item{
    if (item) {
        NSMutableArray *buttonItems = objc_getAssociatedObject(self, KEY_BLOCK_ITEM_LIST);
        [buttonItems addObject:item];
        
        NSInteger index = [self addButtonWithTitle:item.title];
        return index;
    }

    return -1;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSArray *buttonItems = objc_getAssociatedObject(self, KEY_BLOCK_ITEM_LIST);
    if (buttonIndex < [buttonItems count]) {
        BlockButtonItem *item = [buttonItems objectAtIndex:buttonIndex];
        ButtonBlock block = item.block;
        if (block) {
            block();
        }
    }
}

    /*AlertViewHUD*/
static UIAlertView *kAlertViewHUD = nil;
+ (UIAlertView*)showWaitingDialog:(NSString*)text{
    if (nil == kAlertViewHUD) {
        kAlertViewHUD = [[UIAlertView alloc] initWithTitle:text message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [kAlertViewHUD show];
        [kAlertViewHUD release];
        
        float x = kAlertViewHUD.frame.size.width/2-10;
        float y = kAlertViewHUD.frame.size.height - 60;

        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicatorView setCenter:CGPointMake(x, y)];
        [kAlertViewHUD addSubview:indicatorView];
        [indicatorView release];
        [indicatorView startAnimating];
    }else {
        [kAlertViewHUD setTitle:text];
    }
    return kAlertViewHUD;
}

+ (void)updateWaitingDialog:(NSString*)text{
    [kAlertViewHUD setTitle:text];
}

+ (void)closeWaitingDialog{
    [kAlertViewHUD dismissWithClickedButtonIndex:0 animated:YES];
    kAlertViewHUD = nil;
}


@end

#pragma mark --------------UIWebView-----------------------------
@implementation UIWebView (Extention)
- (void)setTransparentBackground{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    // Modified by lh 2012/07/13
    // 在4.2.1会崩溃
    NSArray *array = [NSArray arrayWithArray:[self subviews]];
    if ([array count] > 0) {
        UIScrollView *scrollView = (UIScrollView *)[array objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        for (UIView *subView in scrollView.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                subView.hidden = YES;
            }
        }
    }
//    UIScrollView *scrollView = [self scrollView];
//    for (UIView *subView in scrollView.subviews) {
//        if ([subView isKindOfClass:[UIImageView class]]) {
//            subView.hidden = YES;
//        }
//    }
}
@end

#pragma mark --------------UIImageView-----------------------------
@implementation UIImageView (Extention)
+ (id)imageViewWithFile:(NSString*)file{
    return [self imageViewWithFile:file atPostion:CGPointZero];
}

+ (id)imageViewWithFile:(NSString*)file atPostion:(CGPoint)position{
    UIImageView *view = nil;
    if (file) {
        UIImage *image = [UIImage imageFile:file];
        if (image) {
            view = [[[UIImageView alloc] initWithImage:image] autorelease];
            [view setFrame:CGRectMake(position.x, position.y, image.size.width, image.size.height)];
        }
    }
    
    return view;
}

@end


#pragma mark --------------UIScrollView-----------------------------
@implementation UIScrollView(Extention)
- (int)currentPage{
    float scrollWidth = self.frame.size.width;
    int currentPage = floor((self.contentOffset.x - scrollWidth/2) / scrollWidth) + 1;
    return currentPage;
}
@end


#pragma mark --------------UILabel-----------------------------
@implementation UILabel(Extention)
- (CGSize)ajustFrame{
    CGRect frame = self.frame;
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(frame.size.width, frame.size.height)];
    frame.size = size;
    self.frame = frame;
    return size;
}

+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame
{
    return [self labelWithName:name font:font frame:frame color:nil];
}

+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor*)color
{
    return [self labelWithName:name font:font frame:frame color:color alignment:UITextAlignmentLeft];
}

+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor*)color alignment:(UITextAlignment)alignment
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = name;
    if (color != nil) {
        label.textColor = color;
    }
    label.textAlignment = alignment;
    
    return label;
}
@end

#pragma mark ---------------NSFileManager----------------------
@implementation NSFileManager(Extention)

- (BOOL)isFileExists:(NSString*)path{
    BOOL isDirectory = NO;
    if ([self fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory) {
        return YES;
    }
    return NO;
}

- (BOOL)isDirectoryExists:(NSString*)path{
    BOOL isDirectory = NO;
    if ([self fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
        return YES;
    }
    return NO; 
}

- (BOOL)createDirectoryAtPath:(NSString *)directory{
    if (![self isDirectoryExists:directory]) {
        return [self createDirectoryAtPath:directory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return YES;
}

- (BOOL)isEmptyDirectoryAtPath:(NSString *)directory{
    if ([self isDirectoryExists:directory]) {
        NSArray *array = [self contentsOfDirectoryAtPath:directory error:nil];
        for (NSString *item in array) {
            if (![item hasPrefix:@"."]) {
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}


@end











