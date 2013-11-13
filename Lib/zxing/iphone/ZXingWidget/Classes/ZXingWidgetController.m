// -*- mode:objc; c-basic-offset:2; indent-tabs-mode:nil -*-
/**
 * Copyright 2009-2012 ZXing authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ZXingWidgetController.h"
#import "Decoder.h"
#import "NSString+HTML.h"
#import "ResultParser.h"
#import "ParsedResult.h"
#import "ResultAction.h"
#import "TwoDDecoderResult.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import "FlashLightManager.h"

#if FlashLight
#import <sys/utsname.h>
#define kTorchToggleTag 1000
#endif

#import <notify.h>

#if FlashLight
#include <unistd.h>

//#define DOCUMENTS_DIRECTORY                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//#define kFlashLightOpenedFlagPath           [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"FlashLightOpenedFlag"]    //文件存在表示手电筒已打开
//#define kNotifyFlashLightStateChange        @"kNotifyFlashLightStateChange" //手电筒状态改变时发送通知

#endif

#define CAMERA_SCALAR 1.12412 // scalar = (480 / (2048 / 480))
#define FIRST_TAKE_DELAY 1.0
#define ONE_D_BAND_HEIGHT 10.0

@interface ZXingWidgetController ()

@property BOOL showCancel;
@property BOOL showLicense;
@property BOOL oneDMode;
@property BOOL isStatusBarHidden;

- (void)initCapture;
- (void)stopCapture;

@end

@implementation ZXingWidgetController

#if HAS_AVFF
@synthesize captureSession;
@synthesize prevLayer;
#endif
@synthesize result, delegate, soundToPlay;
@synthesize overlayView;
@synthesize oneDMode, showCancel, showLicense, isStatusBarHidden;
@synthesize readers;
#if FlashLight

typedef enum  
{
	iPhone_1 = 1,
	iPhone_3G,
	iPhone_3GS,
	iPhone_4,
	iPhone_4S,
	iPhone_5,
	iPhone_5S,
	iPod_1,
	iPod_2,
	iPod_3,
	iPod_4,
    iPod_5,
	iPad_1,
	iPad_2,
	iPad_mini,
	iPad_3,
	iPad_4,
	unknown,
}MACHINE_TYPE;

MACHINE_TYPE machineType()
{
	struct utsname systemInfo;
	uname(&systemInfo);
	
	NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	
	if ([@"iPhone1,1" isEqualToString:machineName])
		return iPhone_1;
	else if ([@"iPhone1,2" isEqualToString:machineName])
		return iPhone_3G;
	else if ([@"iPhone2,1" isEqualToString:machineName])
		return iPhone_3GS;
	else if ([@"iPhone3,1" isEqualToString:machineName] || [@"iPhone3,2" isEqualToString:machineName] || [@"iPhone3,3" isEqualToString:machineName])
		return iPhone_4;
	else if ([@"iPhone4,1" isEqualToString:machineName] || [@"iPhone4,2" isEqualToString:machineName])
		return iPhone_4S;
	else if ([@"iPhone5,1" isEqualToString:machineName] || [@"iPhone5,2" isEqualToString:machineName])
		return iPhone_5;
	else if ([@"iPhone6,1" isEqualToString:machineName] || [@"iPhone6,2" isEqualToString:machineName])
		return iPhone_5S;
	else if ([@"iPod1,1" isEqualToString:machineName])
		return iPod_1;
	else if ([@"iPod2,1" isEqualToString:machineName] || [@"iPod2,2" isEqualToString:machineName])
		return iPod_2;
	else if ([@"iPod3,1" isEqualToString:machineName])
		return iPod_3;
	else if ([@"iPod4,1" isEqualToString:machineName])
		return iPod_4;
    else if ([@"iPod5,1" isEqualToString:machineName])
        return iPod_5;
	else if ([@"iPad1,1" isEqualToString:machineName])
		return iPad_1;
	else if ([@"iPad2,1" isEqualToString:machineName] || [@"iPad2,2" isEqualToString:machineName] || [@"iPad2,3" isEqualToString:machineName] || [@"iPad2,4" isEqualToString:machineName])
		return iPad_2;
	else if ([@"iPad2,5" isEqualToString:machineName] || [@"iPad2,6" isEqualToString:machineName])
		return iPad_mini;
	else if ([@"iPad3,1" isEqualToString:machineName] || [@"iPad3,2" isEqualToString:machineName] || [@"iPad3,3" isEqualToString:machineName])
		return iPad_3;
	else if ([@"iPad3,4" isEqualToString:machineName] || [@"iPad3,5" isEqualToString:machineName] || [@"iPad3,6" isEqualToString:machineName])
		return iPad_4;
	return unknown;
}

NSString *machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (BOOL)isSupportAVCapture
{
	BOOL bSucc = NO;
	NSString *macDev = machineName();
	if (!([macDev isEqualToString:@"iPhone1,1"] || [macDev hasPrefix:@"iPhone1,2"] || [macDev hasPrefix:@"iPhone2,1"]
		  || [macDev hasPrefix:@"iPad"] 
		  || [macDev isEqualToString:@"iPod1,1"] || [macDev isEqualToString:@"iPod2,1"]|| [macDev isEqualToString:@"iPod3,1"]|| [macDev isEqualToString:@"iPod4,1"]))
	{
		bSucc = YES;
	}
	return bSucc;
}

- (void)setTorchBtn:(BOOL)status
{
	UIButton *btnTorch = (UIButton *)[self.overlayView viewWithTag:kTorchToggleTag];
	if (btnTorch && [btnTorch isKindOfClass:[UIButton class]]) {
		if (status) {
			[btnTorch setTitle:_(@"CloseTorch") forState:UIControlStateNormal];
		}
        else {
			[btnTorch setTitle:_(@"OpenTorch") forState:UIControlStateNormal];
		}
	}
    NSLog(@"btnTorch.titleLabel.text:%@", btnTorch.titleLabel.text);
}

- (void)initFlashLight
{
    BOOL torchOn = NO;
    if ([[FlashLightManager shareInstance] isTorchOn]) {
        torchOn = YES;
    }
    else {
        torchOn = NO;
    }
}

- (void)destoryFlashLight
{
	if (SystemVersion >= 5.0f) {
        BOOL torchOn = NO;
        if ([[FlashLightManager shareInstance] isTorchOn]) {
            torchOn = YES;
        }
        else {
            torchOn = NO;
        }
        
        MACHINE_TYPE machine = machineType();
        if ((machine == iPhone_4) || (machine == iPhone_4S)|| (machine == iPhone_5)|| (machine == iPhone_5S) || (machine == iPod_5))
        {
            if (torchOn) {
                [[FlashLightManager shareInstance] toggleTorch];
            }
        }
	}
}

#if 0

static void callbackNotifyStateLock(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	int token;
	uint64_t state;
	notify_register_check("com.apple.springboard.lockstate", &token);
	notify_get_state(token, &state);//0开锁 1锁屏
	
	NSLog("com.apple.springboard.lockstate state =%d",state);
	if (state >0) {
		//CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately)
	}
	
	notify_cancel(token); 
}

- (void)addlockNotification
{
	NSLog("addlockNotification......");
	CFStringRef name =  CFStringCreateWithCString(nil,"com.apple.springboard.lockstate", kCFStringEncodingUTF8);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil,(CFNotificationCallback)callbackNotifyStateLock,  name, nil, 0);
}

- (void)removelockNotification
{
	NSLog("removelockNotification......");
	CFStringRef name =  CFStringCreateWithCString(nil,"com.apple.springboard.lockstate", kCFStringEncodingUTF8);
	CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), self, (CFStringRef)name, NULL);
}

#endif

static int enterBackGround = -1;//0 lock 1 unlock
static int avComeCount = 0;

- (void)enterBGTorchToggle
{
	//locked lock screen
	NSLog(@"enterBGTorchToggle:%d",enterBackGround);
	avComeCount = 0;
	BOOL torchOn = YES;
    
    if ([[FlashLightManager shareInstance] isTorchOn]) {
        torchOn = YES;
    }
    else {
        torchOn = NO;
    }
	
	if (SystemVersion>=5.0f) {
        if (torchOn) {
            MACHINE_TYPE machine = machineType();
            if ((machine == iPhone_4) || (machine == iPhone_4S)|| (machine == iPhone_5)|| (machine == iPhone_5S) || (machine == iPod_5))
            {
                [[FlashLightManager shareInstance] toggleTorch];
            }
            enterBackGround = 0;//lock screen
            self.overlayView.canClickCancelBtn = NO;
        }
	}
    else {
		if (torchOn) {
			enterBackGround = 0;//lock screen
			self.overlayView.canClickCancelBtn = NO;
		}
	}
}

- (void)avStreamComeNotification
{
	NSLog(@"avStreamComeNotification:%d",enterBackGround);
	if (enterBackGround == 1) {
		MACHINE_TYPE machine = machineType();
		int countWait = 2;
		if ((machine == iPhone_4) || (machine == iPhone_4S)) {
			countWait = 2;
		}else if((machine == iPhone_5)|| (machine == iPhone_5S) || (machine == iPod_5)){
			countWait = 1;
		}
		if (avComeCount<countWait) {
			avComeCount ++;
			return;
		}
		NSLog(@"avStreamComeNotification:%d,self.overlayView.canClickCancelBtn:%d",enterBackGround,self.overlayView.canClickCancelBtn);
		//[NSThread sleepForTimeInterval:2.0f];	
		if (!self.overlayView.canClickCancelBtn) {
			return;
		}
		if (![self isSupportAVCapture]) {
			return;
		}
		
		if (SystemVersion>=5.0f) {
            
            if ((machine == iPhone_4) || (machine == iPhone_4S)|| (machine == iPhone_5)|| (machine == iPhone_5S) || (machine == iPod_5))
            {
                [[FlashLightManager shareInstance] toggleTorch];
            }
		}
		
		enterBackGround = -1;
	}
}

- (void)outBGTorchToggle
{
	avComeCount = 0;
	NSLog(@"outBGTorchToggle:%d",enterBackGround);
	if (enterBackGround == 0) {
		enterBackGround = 1;//unlock
	}
}

- (void)torchToggle
{
	if (!self.overlayView.canClickCancelBtn) {
		return;
	}
    
	if (![self isSupportAVCapture]) {
		return;
	}

	MACHINE_TYPE machine = machineType();
	if ((machine == iPhone_4) || (machine == iPhone_4S)|| (machine == iPhone_5)|| (machine == iPhone_5S) || (machine == iPod_5))
	{
		BOOL torchOn = YES;
		if (SystemVersion>=5.0) {
            [[FlashLightManager shareInstance] toggleTorch];
		}
        
        if ([[FlashLightManager shareInstance] isTorchOn]) {
            torchOn = YES;
        }
        else {
            torchOn = NO;
        }
		[self setTorchBtn:torchOn];
	}
}

#endif

- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode
{
    return [self initWithDelegate:scanDelegate showCancel:shouldShowCancel OneDMode:shouldUseoOneDMode showLicense:YES];
}

- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode showLicense:(BOOL)shouldShowLicense
{
    self = [super init];
    if (self) {
        [self setDelegate:scanDelegate];
        self.oneDMode = shouldUseoOneDMode;
        self.showCancel = shouldShowCancel;
        self.showLicense = shouldShowLicense;
        self.wantsFullScreenLayout = YES;
        beepSound = -1;
        decoding = NO;
        
        OverlayView *theOverLayView = [[OverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds 
                                                           cancelEnabled:showCancel 
                                                                oneDMode:oneDMode
                                                             showLicense:shouldShowLicense];
        [theOverLayView setDelegate:self];
        self.overlayView = theOverLayView;//self.overlayView.canClickCancelBtn
        [theOverLayView release];
        
#if FlashLight
        UIImage *image = [[UIImageManager shareInstance] imageWithFileName:@"TwoDimension/td_torchBtn.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:_(@"OpenTorch") forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        if (![self isSupportAVCapture]) {
            button.enabled = NO;
            button.hidden = YES;
            if (self.overlayView.cancelButton) {
                CGSize theSize = CGSizeMake(96, 33);
                CGRect theRect = CGRectMake((SCREEN_WIDTH-96)/2, SCREEN_HEIGHT-8-33, theSize.width, theSize.height);
                self.overlayView.cancelButton.frame = theRect;
            }		
        }
        [button setFrame:CGRectMake(29, SCREEN_HEIGHT-8-33, 96, 33)];
         button.contentEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
        [button addTarget:self action:@selector(torchToggle) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kTorchToggleTag;
        [self.overlayView addSubview:button];
        
        if ([self isSupportAVCapture]) {
            [self initFlashLight];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outBGTorchToggle) name:UIApplicationDidBecomeActiveNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBGTorchToggle) name:UIApplicationWillResignActiveNotification object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avStreamComeNotification) name:kRemoveIndicatorViewNotification object:nil];
        }
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToDecodeImageNotification:) name:kFailedToDecodeImageNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if 0
	[self removelockNotification];
#endif
#if FlashLight
	[self destoryFlashLight];	
#endif
  if (beepSound != (SystemSoundID)-1) {
    AudioServicesDisposeSystemSoundID(beepSound);
  }
  
  [self stopCapture];

  [result release];
  [soundToPlay release];
  [overlayView release];
  [readers release];
	
  [super dealloc];
}

- (void)cancelled
{
    [self stopCapture];
    if (!self.isStatusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    wasCancelled = YES;
    if (delegate != nil) {
        [delegate zxingControllerDidCancel:self];
    }
}

- (NSString *)getPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    return platform;
}

- (BOOL)fixedFocus
{
    NSString *platform = [self getPlatform];
    if ([platform isEqualToString:@"iPhone1,1"] || [platform isEqualToString:@"iPhone1,2"])
        return YES;
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    self.overlayView.canClickCancelBtn = NO;
    self.wantsFullScreenLayout = YES;
    if ([self soundToPlay] != nil) {
        OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)[self soundToPlay], &beepSound);
        if (error != kAudioServicesNoError) {
            NSLog(@"Problem loading nearSound.caf");
        }
    }
	if (delegate && [delegate respondsToSelector:@selector(zxingControllerViewWillAppear)]) {
		[delegate zxingControllerViewWillAppear];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
    if (!isStatusBarHidden)
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

    decoding = YES;
    
    [self initCapture];
    [self.view addSubview:overlayView];
    
    [overlayView setPoints:nil];
    wasCancelled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveIndicatorViewNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (!isStatusBarHidden)
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.overlayView removeFromSuperview];
    [self stopCapture];
}

- (CGImageRef)CGImageRotated90:(CGImageRef)imgRef
{
    CGFloat angleInRadians = -90 * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    //      CGContextTranslateCTM(bmContext,
    //                                                +(rotatedRect.size.width/2),
    //                                                +(rotatedRect.size.height/2));
    CGContextScaleCTM(bmContext, rotatedRect.size.width/rotatedRect.size.height, 1.0);
    CGContextTranslateCTM(bmContext, 0.0, rotatedRect.size.height);
    CGContextRotateCTM(bmContext, angleInRadians);
    //      CGContextTranslateCTM(bmContext,
    //                                                -(rotatedRect.size.width/2),
    //                                                -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                           rotatedRect.size.width,
                                           rotatedRect.size.height),
                     imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    [(id)rotatedImage autorelease];
    
    return rotatedImage;
}

- (CGImageRef)CGImageRotated180:(CGImageRef)imgRef
{
    CGFloat angleInRadians = M_PI;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                        +(width/2),
                        +(height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                        -(width/2),
                        -(height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    [(id)rotatedImage autorelease];
    
    return rotatedImage;
}

// DecoderDelegate methods

- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset
{
#if ZXING_DEBUG
    NSLog(@"DecoderViewController MessageWhileDecodingWithDimensions: Decoding image (%.0fx%.0f) ...", image.size.width, image.size.height);
#endif
}

- (void)decoder:(Decoder *)decoder decodingImage:(UIImage *)image usingSubset:(UIImage *)subset
{
    
}

- (void)presentResultForString:(NSString *)resultString
{
    self.result = [ResultParser parsedResultForString:resultString];
    if (beepSound != (SystemSoundID)-1) {
        AudioServicesPlaySystemSound(beepSound);
    }
#if ZXING_DEBUG
    NSLog(@"result string = %@", resultString);
#endif
}

- (void)presentResultPoints:(NSArray *)resultPoints forImage:(UIImage *)image usingSubset:(UIImage *)subset
{
    // simply add the points to the image view
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:resultPoints];
    [overlayView setPoints:mutableArray];
    [mutableArray release];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult
{
    [self presentResultForString:[twoDResult text]];
    [self presentResultPoints:[twoDResult points] forImage:image usingSubset:subset];
    // now, in a selector, call the delegate to give this overlay time to show the points
    [self performSelector:@selector(notifyDelegate:) withObject:[[twoDResult text] copy] afterDelay:0.0];
    decoder.delegate = nil;
}

- (void)notifyDelegate:(id)text
{
    if (!isStatusBarHidden)
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [delegate zxingController:self didScanResult:text];
    [text release];
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
{
    decoder.delegate = nil;
    [overlayView setPoints:nil];
}

- (void)decoder:(Decoder *)decoder foundPossibleResultPoint:(CGPoint)point
{
    [overlayView setPoint:point];
}

/*
  - (void)stopPreview:(NSNotification*)notification {
  // NSLog(@"stop preview");
  }

  - (void)notification:(NSNotification*)notification {
  // NSLog(@"notification %@", notification.name);
  }
*/

- (UIImage *)createScaleImage:(UIImage*)imageSrc orientation:(UIImageOrientation)orientation
{
	UIImage *scrn = nil;
    static int i = 0;
    
    
	if (i>=0 && i<=4) {
		scrn = [[[UIImage alloc] initWithCGImage:imageSrc.CGImage scale:1.0 orientation:orientation] autorelease];
	}
    else if(i>=5 && i<=7) {
		scrn = [[[UIImage alloc] initWithCGImage:imageSrc.CGImage scale:(imageSrc.size.width/imageSrc.size.height) orientation:orientation] autorelease];
	}
    else if(i>=8 && i<=9) {
		scrn = [[[UIImage alloc] initWithCGImage:imageSrc.CGImage scale:(imageSrc.size.height/imageSrc.size.width) orientation:orientation] autorelease];
	}
	i++;
    if (i == 10) {
        i = 0;
    }
    
	return scrn;
}

- (void)failedToDecodeImageNotification:(NSNotification *)notification
{
    id object = notification.object;
    if (object && [object isKindOfClass:[Decoder class]]) {
        [overlayView setPoints:nil];
    }
}

#pragma mark -
#pragma mark AVFoundation

#include <sys/types.h>
#include <sys/sysctl.h>

// Gross, I know. But you can't use the device idiom because it's not iPad when running
// in zoomed iphone mode but the camera still acts like an ipad.
#if 0 && HAS_AVFF
static bool isIPad() {
  static int is_ipad = -1;
  if (is_ipad < 0) {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); // Get size of data to be returned.
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    free(name);
    is_ipad = [machine hasPrefix:@"iPad"];
  }
  return !!is_ipad;
}
#endif

- (void)initCapture
{
#if HAS_AVFF
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([inputDevice lockForConfiguration:nil]) {
        if ([inputDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            inputDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        if ([inputDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            inputDevice.exposureMode = AVCaptureExposureModeAutoExpose;
        }
        [inputDevice unlockForConfiguration];
    }
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    
#if 1
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init]; 
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
#else
	// Setup the still image file output
    AVCaptureStillImageOutput *captureOutput = [[AVCaptureStillImageOutput alloc] init];
	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [captureOutput setOutputSettings:outputSettings];
    [outputSettings release];
#endif
	
    self.captureSession = [[[AVCaptureSession alloc] init] autorelease];

	NSLog(@"captureOutput:%@",captureOutput);
    NSString *preset = 0;

#if 0
  // to be deleted when verified ...
  if (isIPad()) {
    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
        [UIScreen mainScreen].scale > 1 &&
        [inputDevice
          supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
      preset = AVCaptureSessionPresetiFrame960x540;
    }
    if (false && !preset &&
        [inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]) {
      preset = AVCaptureSessionPresetHigh;
    }
  }
#endif

  if (!preset) {
#if 0
	  if([inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080])
	  {
		  preset = AVCaptureSessionPreset1920x1080;
	  }else if ([inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame1280x720]) {
		  preset = AVCaptureSessionPresetiFrame1280x720;
	  }else if ([inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
		  preset = AVCaptureSessionPresetiFrame960x540;
	  }
	  else if ([inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]) {
		   preset = AVCaptureSessionPresetHigh;
	  }else{
		   preset = AVCaptureSessionPresetMedium;//modify by ygf
	  }
#else
	  preset = AVCaptureSessionPresetMedium;
#endif
	 
  }
  self.captureSession.sessionPreset = preset;

	if ([self.captureSession canAddInput:captureInput]) {
		[self.captureSession addInput:captureInput];
		NSLog(@"self.captureSession canAddInput");
	}else{
		NSLog(@"self.captureSession can not AddInput");
		overlayView.canClickCancelBtn = YES;
//		[[NSNotificationCenter defaultCenter] postNotificationName:kRemoveIndicatorViewNotification object:nil];
		//访问限制
	}
	if ([self.captureSession canAddOutput:captureOutput]) {
		 [self.captureSession addOutput:captureOutput];
		NSLog(@"self.captureSession canAddOutput");
	}else{
		NSLog(@"self.captureSession can not AddOutput");
		overlayView.canClickCancelBtn = YES;
//		[[NSNotificationCenter defaultCenter] postNotificationName:kRemoveIndicatorViewNotification object:nil];
	}
 

  [captureOutput release];

  if (!self.prevLayer) {
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  }
  // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
  self.prevLayer.frame = self.view.bounds;
    self.prevLayer.frame = CGRectInset(self.prevLayer.frame, -100, -100);
	self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer addSublayer: self.prevLayer];
	if (SystemVersion >= 6.0) {//modify by ygf
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[self.captureSession startRunning];
		});
	}else{
		[self.captureSession startRunning];
	}
#endif
}

#if HAS_AVFF
static NSDate *lastDate = nil;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection 
{
    static int dealOutput = 0;
    if (dealOutput++ > 3) {
        dealOutput = 0;
    }
    if (dealOutput%3 != 0) {
        return;
    }
    
    NSDate *nowDate = [NSDate date];
    if (!decoding) {
        self.overlayView.canClickCancelBtn = YES;
        if (!lastDate||[nowDate timeIntervalSinceDate:lastDate]>0.5f) {
//          [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveIndicatorViewNotification object:nil];
            if (lastDate) {
                [lastDate release];
                lastDate = nil;
            }
            lastDate = [nowDate retain];
        }	
        return;
    }
#if 0
	NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
	NSLog(@"imageDataSampleBuffer get data");
	UIImage *image = [[UIImage alloc] initWithData:imageData];
#endif
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    /*Get information about the image*/
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // NSLog(@"wxh: %lu x %lu", width, height);
    
    uint8_t *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    void *free_me = 0;
    if (true) { // iOS bug?
        uint8_t *tmp = baseAddress;
        int bytes = bytesPerRow * height;
        free_me = baseAddress = (uint8_t *)malloc(bytes);
        baseAddress[0] = 0xdb;
        memcpy(baseAddress, tmp, bytes);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
    
    CGImageRef capture = CGBitmapContextCreateImage(newContext);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    free(free_me);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    if (false) {
        CGRect cropRect = [overlayView cropRect];
        if (oneDMode) {
            // let's just give the decoder a vertical band right above the red line
            cropRect.origin.x = cropRect.origin.x + (cropRect.size.width / 2) - (ONE_D_BAND_HEIGHT + 1);
            cropRect.size.width = ONE_D_BAND_HEIGHT;
            // do a rotate
            CGImageRef croppedImg = CGImageCreateWithImageInRect(capture, cropRect);
            CGImageRelease(capture);
            capture = [self CGImageRotated90:croppedImg];
            capture = [self CGImageRotated180:capture];
//            UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:capture], nil, nil, nil);
            CGImageRelease(croppedImg);
            CGImageRetain(capture);
            cropRect.origin.x = 0.0;
            cropRect.origin.y = 0.0;
            cropRect.size.width = CGImageGetWidth(capture);
            cropRect.size.height = CGImageGetHeight(capture);
        }
        
        // N.B.
        // - Won't work if the overlay becomes uncentered ...
        // - iOS always takes videos in landscape
        // - images are always 4x3; device is not
        // - iOS uses virtual pixels for non-image stuff
        
        {
            float height = CGImageGetHeight(capture);
            float width = CGImageGetWidth(capture);
            
            NSLog(@"%f %f", width, height);
            
            CGRect screen = UIScreen.mainScreen.bounds;
            float tmp = screen.size.width;
            screen.size.width = screen.size.height;;
            screen.size.height = tmp;
            
            cropRect.origin.x = (width-cropRect.size.width)/2;
            cropRect.origin.y = (height-cropRect.size.height)/2;
        }
        
        NSLog(@"sb %@", NSStringFromCGRect(UIScreen.mainScreen.bounds));
        NSLog(@"cr %@", NSStringFromCGRect(cropRect));
        
        CGImageRef newImage = CGImageCreateWithImageInRect(capture, cropRect);
        CGImageRelease(capture);
        capture = newImage;
    }
    
    UIImage *scrn = [[[UIImage alloc] initWithCGImage:capture] autorelease];
    scrn = [self createScaleImage:scrn orientation:UIImageOrientationLeft];
    
    CGImageRelease(capture);
    
    Decoder *d = [[Decoder alloc] init];
    d.readers = readers;
    d.delegate = self;
    
    decoding = [d decodeImage:scrn] == YES ? NO : YES;
    
    [d release];
    
    if (decoding) {
        
        d = [[Decoder alloc] init];
        d.readers = readers;
        d.delegate = self;
        
//        scrn = [[[UIImage alloc] initWithCGImage:scrn.CGImage scale:1.0 orientation:UIImageOrientationLeft] autorelease];
        scrn = [self createScaleImage:scrn orientation:UIImageOrientationLeft];
        
        // NSLog(@"^ %@ %f", NSStringFromCGSize([scrn size]), scrn.scale);
        decoding = [d decodeImage:scrn] == YES ? NO : YES;
        
        [d release];
    }
    self.overlayView.canClickCancelBtn = YES;
	
	if (!lastDate||[nowDate timeIntervalSinceDate:lastDate]>0.5f) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:kRemoveIndicatorViewNotification object:nil];
		if (lastDate) {
			[lastDate release];
			lastDate = nil;
		}
		lastDate = [nowDate retain];
	}
    
#if 0
    // Save image
    static int i = 0;
    if (i%30 == 0) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *picPath = [docPath stringByAppendingPathComponent:@"PicPath"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:picPath]) {
            [fileManager createDirectoryAtPath:picPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *path = [picPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png", i]];
        NSData *data = UIImagePNGRepresentation(scrn);
        if (data == nil) {
            data = UIImageJPEGRepresentation(scrn, 1.0);
        }
        [data writeToFile:path atomically:YES];
    }
    i++;
    NSLog(@"i = %d", i);
#endif
}
#endif

- (void)stopCapture
{
    decoding = NO;
#if HAS_AVFF
    [captureSession stopRunning];
	if ([captureSession.inputs count]) {
		AVCaptureInput* input = [captureSession.inputs objectAtIndex:0];
		NSLog(@"stopCapture can remove input");
		[captureSession removeInput:input];		
	}
	if ([captureSession.outputs count]) {
		AVCaptureVideoDataOutput* output = (AVCaptureVideoDataOutput*)[captureSession.outputs objectAtIndex:0];
		NSLog(@"stopCapture can remove output");
		[captureSession removeOutput:output];
	}
    
    [self.prevLayer removeFromSuperlayer];
    
    self.prevLayer = nil;
    self.captureSession = nil;
#endif
}

@end
