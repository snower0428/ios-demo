//
//  Category.h
//  BabyBooks
//
//  Created by zhangtianfu on 11-3-1.
//  Copyright 2011 ND WebSoft Inc. All rights reserved.
//
//	============  分类	================

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark -----------NSData----------------
#import <CommonCrypto/CommonCryptor.h>

@interface NSData(Extention)
//kCCEncrypt:加密
//kCCDecrypt:解密
//	对data进行AES加密/解密; key最长32位
- (NSData *)AES256_CCOperation:(CCOperation)operation withKey:(NSString *)key32;
//	对data进行DES加密/解密; key最长8位
- (NSData *)DES_CCOperation:(CCOperation)operation withKey:(NSString *)key8;
@end

#pragma mark ----------UIScreen---------------
//@interface UIScreen(scale)
//
////@property(nonatomic,readonly) float scale;
//
//- (BOOL)isRetina;//判断是否是iphone4屏幕
//@end



#pragma mark ----------UIImage--------------
//@interface UIImage(Extention)
//
//+ (id)imageFile:(NSString*)file;
//
////	加载图片类似initWithContentsOfFile（为了解决4.0固件不能自动识别@2x图片）
//- (id)initWithContentsOfFileEx:(NSString *)path;
//
////	加载图片类似imageWithContentsOfFile（为了解决4.0固件不能自动识别@2x图片）
//+ (UIImage*)imageWithContentsOfFileEx:(NSString *)path;
//
//
////缩放图片并且添加相应的边框
//- (UIImage*)resizeImage:(CGSize)imageSize color:(UIColor*)borderColor width:(float)borderWidth height:(float)borderHeight;
////缩放图片并且添加相应的边框（直接操作view截屏，可能效率低）
//- (UIImage*)resizeImageEx:(CGSize)imageSize color:(UIColor*)borderColor width:(float)borderWidth height:(float)borderHeight;
//
//
////缩放图片，并且添加圆角
//- (UIImage*)resizeImage:(CGSize)imageSize cornerRadius:(float)cornerRadius;
//
////按照宽/高比例切割图片
//- (UIImage*)clipImageWithRate:(float)rate;//可以用UIViewContentMode代替
//
//@end

#pragma mark -----------UIView----------------
//@interface UIView(Extention)
////	当前view所属的UIViewController
//- (id)viewController;
//- (UIImage*)captureScreen;
//- (void)setPosition:(CGPoint)pt;
//- (void)scaleFrameWithSize:(CGSize)size;
//@end


#pragma mark -----------NSString----------------
//@interface NSString(Extention)
//- (NSString *)md5Digest;	//md5
//- (NSString *)md5:(NSString *)str;
//
//    /*对字符串的base64编码和解码（原始值必须是字符串）*/
//- (NSString *)encodeBase64; 
//- (NSString *)decodeBase64; 
//
//    /*对URL进行编码和解码*/
//- (NSString *)encodeURL;
//- (NSString *)decodeURL;
//- (NSString *)encodeURLParam;
//- (NSString *)addURLKey:(NSString*)key value:(NSString*)value;
//
//
//    /*对字符串的DES加密和解密（原始值必须是字符串）*/
//- (NSString *)DES_EncryptWithKey:(NSString *)key8; 
//- (NSString *)DES_DecryptWithKey:(NSString *)key8; 
//
//- (NSString *)getStringFromCharacterSet:(NSString*)characterSet;	//获取符合key的字符串
//- (NSString *)getNumberString;										//获取纯数字
//- (NSString *)getIntString;											//获取int
//- (NSString *)getFloatString;										//获取float
//
//- (BOOL)isChineseSymbol;//是否是中文标点
//- (NSString*)restoreEnterSymbol;//恢复回车换行符号（从配置文件读取会在换行符号前增加一个"\n"）
//- (NSString*)removeEnterSymbol;//删除换行字符
//
//- (UIColor*)getColor; //解析格式为r,g,b,alpha为相应的颜色，例如255,255,255,1--至少要rgb值存在才能解析
//
//- (NSString *)getValueFromURLForKey:(NSString *)key;//解析URL键值（解析？号之后的URL部分）
//
//
//- (TransitionDirection)directionFromLeftValue;
//- (TransitionDirection)directionFromRightValue;
//
//- (BOOL)isFile;
//
//    //格式输出数字每三位加个逗号（如果23,456,789）
//- (NSString*)formatNumber;
//    //格式输出版本号只保留第一个小数点（如5.0.1-->5.01）
//- (NSString *)formatVersion;
//
//@end

#pragma mark -----------UIColor----------------
@interface UIColor(Extention)
- (CGColorSpaceModel) colorSpaceModel ;
- (NSString *) colorSpaceString;
- (CGFloat) red; 
- (CGFloat) green;  
- (CGFloat) blue; 
- (CGFloat) alpha;  
@end

#pragma mark -----------NSDictionary----------------
@interface NSDictionary(Extention)
- (UIImage*)getImageForKey:(NSString*)key resDirectory:(NSString*)resDirectory;
- (UIImage*)getImageFromArray:(int)index forKey:(NSString*)key resDirectory:(NSString*)resDirectory;
- (NSArray*)getImagesForKey:(NSString*)key resDirectory:(NSString*)resDirectory;
- (CGRect)getRectForKey:(NSString*)key;
- (CGRect)getRectForKey:(NSString*)key fromImage:(UIImage*)image;

- (Class)getPageViewClass;

- (id)getValueWithLanguageType:(LanguageType)languageType;
- (id)getLayersWithLanguageType:(LanguageType)languageType;

@end

#pragma mark -----------NSArray----------------
@interface NSArray(Extention)
- (NSArray*)getImages:(NSString*)resDirectory;
@end

#pragma mark -----------UIDevice---------------
@interface UIDevice(Extention)
- (NSString *)udid;//所有的设备都要用这个接口获取设备id
- (NSString *)macaddress;//获取wifi地址

@property(readonly) double availableMemory;

@end

#pragma mark --------------NSObject-----------------
@interface NSObject (Extention)
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;
@end

#pragma mark --------------UINavigationController-----------------------------
@interface UINavigationController (Extention)
- (UIViewController*)rootViewController;
@end

#pragma mark --------------UIButton-----------------------------
@interface UIButton (Extention)
- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(ButtonBlock)block;

+ (id)buttonWithNormalFile:(NSString*)normalFile;
+ (id)buttonWithNormalFile:(NSString*)normalFile downFile:(NSString*)downFile;
+ (id)buttonWithNormalFile:(NSString*)normalFile downFile:(NSString*)downFile disableFile:(NSString*)disableFile;

+ (id)buttonWithBackgroundNormalFile:(NSString*)normalFile;
+ (id)buttonWithBackgroundNormalFile:(NSString*)normalFile downFile:(NSString*)downFile;
+ (id)buttonWithBackgroundNormalFile:(NSString*)normalFile downFile:(NSString*)downFile disableFile:(NSString*)disableFile;
@end

#pragma mark --------------UIAlertView-----------------------------
@interface UIAlertView (Extention)
+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title  
                               message:(NSString *)message;
+ (UIAlertView*)showAlertViewWithTitle:(NSString *)title 
                               message:(NSString *)message 
                      cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
                      otherButtonItems:(BlockButtonItem *)otherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
  cancelButtonItem:(BlockButtonItem *)cancelButtonItem 
  otherButtonItems:(BlockButtonItem *)otherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonWithTitle:(NSString *)title block:(ButtonBlock)block; 
- (NSInteger)addButtonItem:(BlockButtonItem *)item; 

    /*AlertViewHUD*/
+ (UIAlertView*)showWaitingDialog:(NSString*)text;
+ (void)updateWaitingDialog:(NSString*)text;
+ (void)closeWaitingDialog;

@end

#pragma mark --------------UIWebView-----------------------------
@interface UIWebView (Extention)
- (void)setTransparentBackground;
@end

#pragma mark --------------UIImageView-----------------------------
@interface UIImageView (Extention)
+ (id)imageViewWithFile:(NSString*)file;
+ (id)imageViewWithFile:(NSString*)file atPostion:(CGPoint)position;
@end


#pragma mark --------------UIScrollView-----------------------------
@interface UIScrollView(Extention)
- (int)currentPage;
@end

#pragma mark --------------UILabel-----------------------------
@interface UILabel(Extention)
- (CGSize)ajustFrame;
+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame;
+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor*)color;
+ (UILabel *)labelWithName:(NSString *)name font:(UIFont *)font frame:(CGRect)frame color:(UIColor*)color alignment:(UITextAlignment)alignment;
@end

#pragma mark ---------------NSFileManager----------------------
@interface NSFileManager(Extention)
- (BOOL)isFileExists:(NSString*)path;
- (BOOL)isDirectoryExists:(NSString*)path;
- (BOOL)createDirectoryAtPath:(NSString *)directory;
- (BOOL)isEmptyDirectoryAtPath:(NSString *)directory;
@end


