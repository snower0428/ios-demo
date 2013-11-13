//
//  ViewController.m
//  TesseractDemo
//
//  Created by leihui on 13-10-27.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "Tesseract.h"
#import "NSString+TKUtilities.h"
#import "PHTesseract.h"

@interface ViewController ()
{
    UIImagePickerController *_imagePicker;
    Tesseract   *_tesseract;
    
    UILabel *_label;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@end

@implementation ViewController

@synthesize imagePicker = _imagePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 50, 300, 40);
    [button setTitle:@"Parse" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnTest.frame = CGRectMake(10, 100, 300, 40);
    [btnTest setTitle:@"Test" forState:UIControlStateNormal];
    [self.view addSubview:btnTest];
    [btnTest addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 100)];
    _label.backgroundColor =[UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor blackColor];
    [self.view addSubview:_label];
    
    _tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    
    // Set the character whitelist to just be numbers, lowercase and uppercase letters
    // and a few special symbols
//    [_tesseract setVariableValue:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-=*/!""'.%:"
//                          forKey:@"tessedit_char_whitelist"];
    [_tesseract setVariableValue:@"0123456789%" forKey:@"tessedit_char_whitelist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)btnClicked:(id)sender
{
    CGImageRef UIGetScreenImage();
    CGImageRef img = UIGetScreenImage();
    UIImage* scImage=[UIImage imageWithCGImage:img];
    CGImageRelease(img); // you need to call this.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(scImage.CGImage, CGRectMake(scImage.size.width*2/3, 0, scImage.size.width/3, 20*[UIScreen mainScreen].scale));
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
//    UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:img], nil, nil, nil);
    
    // Start processing the image
    [_tesseract setImage:croppedImage];
    [_tesseract recognize];
    NSString *text = [_tesseract recognizedText];
    _label.text = text;
    
    NSLog(@"[UIScreen mainScreen].scale:%f ---- text:%@", [UIScreen mainScreen].scale, text);
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *arrayLow = [NSMutableArray array];
    
    for (int i = 0; i <=100; i++) {
        NSString *str = [NSString stringWithFormat:@"%d%%", i];
        if (i < 10) {
            [arrayLow addObject:str];
        }
        else {
            [array addObject:str];
        }
    }
    
    BOOL bPersentage = NO;
    NSString *persentage = @"";
    for (int i = 0; i < [array count]; i++) {
        NSString *str = [array objectAtIndex:i];
        if ([text containsString:str]) {
            bPersentage = YES;
            persentage = str;
            break;
        }
    }
    
    if (!bPersentage) {
        for (int i = 0; i < [arrayLow count]; i++) {
            NSString *str = [arrayLow objectAtIndex:i];
            if ([text containsString:str]) {
                bPersentage = YES;
                persentage = str;
                break;
            }
        }
    }
    
    NSLog(@"persentage:%@", persentage);
}

- (void)testAction:(id)sender
{
    PHTesseract *tesseract = [[PHTesseract alloc] init];
    NSLog(@"[tesseract batteryPercentage]:%d", [tesseract batteryPercentage]);
}

- (UIImage*)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*) getGLScreenshot {
    NSInteger myDataLength = 320 * 480 * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, 320, 480, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <480; y++)
    {
        for(int x = 0; x <320 * 4; x++)
        {
            buffer2[(479 - y) * 320 * 4 + x] = buffer[y * 4 * 320 + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * 320;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(320, 480, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

-(void)fullScreenshots
{
//    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
//    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
//    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    CGImageRef UIGetScreenImage();
    CGImageRef img = UIGetScreenImage();
    UIImage* scImage=[UIImage imageWithCGImage:img];
    CGImageRelease(img); // you need to call this.
    UIImageWriteToSavedPhotosAlbum(scImage, nil, nil, nil);
    
    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
//    else
//        UIGraphicsBeginImageContext(window.bounds.size);
//    
//    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}

#if 0

#include "IOPowerSources.h"
#include "IOPSKeys.h"

- (double) batteryLevel
{
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    
    int numOfSources = CFArrayGetCount(sources);
    if (numOfSources == 0) {
        NSLog(@"Error in CFArrayGetCount");
        return -1.0f;
    }
    
    for (int i = 0 ; i < numOfSources ; i++)
    {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) {
            NSLog(@"Error in IOPSGetPowerSourceDescription");
            return -1.0f;
        }
        psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
        
        int curCapacity = 0;
        int maxCapacity = 0;
        double percent;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        percent = ((double)curCapacity/(double)maxCapacity * 100.0f);
        
        return percent; 
    }
    return -1.0f;
}

#endif

@end
