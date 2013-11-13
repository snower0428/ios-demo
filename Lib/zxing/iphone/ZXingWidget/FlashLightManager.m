//
//  FlashLightManager.m
//  ZXingWidget
//
//  Created by leihui on 13-8-29.
//
//

#import "FlashLightManager.h"
#import <sys/utsname.h>

static FlashLightManager *kFlashLightManager = nil;

@implementation FlashLightManager

@synthesize avSession = _avSession;

- (id)init
{
    self = [super init];
    if (self) {
        // Init
    }
    
    return self;
}

+ (FlashLightManager *)shareInstance
{
    @synchronized(self)
    {
        if (nil == kFlashLightManager) {
            kFlashLightManager = [[FlashLightManager alloc] init];
        }
    }
    return kFlashLightManager;
}

+ (void)exitInstance
{
    @synchronized(self)
    {
        if (kFlashLightManager != nil) {
            [kFlashLightManager release];
            kFlashLightManager = nil;
        }
    }
}

#pragma mark - Private

- (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (BOOL)isSupportAVCapture
{
	BOOL bSucc = NO;
	NSString *machineName = [self machineName];
	if (!([machineName isEqualToString:@"iPhone1,1"] || [machineName hasPrefix:@"iPhone1,2"] || [machineName hasPrefix:@"iPhone2,1"]
		  || [machineName hasPrefix:@"iPad"]
		  || [machineName isEqualToString:@"iPod1,1"] || [machineName isEqualToString:@"iPod2,1"] || [machineName isEqualToString:@"iPod3,1"]|| [machineName isEqualToString:@"iPod4,1"]))
	{
		bSucc = YES;
	}
	return bSucc;
}

- (BOOL)isTorchOn
{
    BOOL torchOn = NO;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
		[device lockForConfiguration:nil];
        if (device.torchMode == AVCaptureTorchModeOff)
        {
			torchOn = NO;
        }
        else {
			torchOn = YES;
        }
		[device unlockForConfiguration];
    }
	NSLog(@"torchOn:%d",torchOn);
	return torchOn;
}

- (void)changeTorchMode:(NSNumber *)avCaptureTouchMode
{
	AVCaptureTorchMode mode = [avCaptureTouchMode integerValue];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	[device lockForConfiguration:nil];
    if (mode == AVCaptureTorchModeOn) {
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    
	[device setTorchMode:mode];
	[device unlockForConfiguration];
}

- (void)toggleTorch
{
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (systemVersion < 5.0 && [self isSupportAVCapture])
    {
        if (device.torchMode == AVCaptureTorchModeOff)
        {
            if ([device hasTorch])
            {
                // Create an AV session
                AVCaptureSession *session = [[[AVCaptureSession alloc] init] autorelease];
                
                // Create device input and add to current session
                AVCaptureDeviceInput *inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                if ([session canAddInput:inputDevice]) {
                    [session addInput:inputDevice];
                }
                
                // Create video output and add to current session
                AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
                if ([session canAddOutput:output]) {
                    [session addOutput:output];
                }
                // Start session configuration
                [session beginConfiguration];
                
                [device lockForConfiguration:nil];
                // Set torch to on
                [device setTorchMode:AVCaptureTorchModeOff];
                
                [device setTorchMode:AVCaptureTorchModeOn];
                [device unlockForConfiguration];
                [session commitConfiguration];
                // Start the session
                [session startRunning];
                // Keep the session around
                self.avSession = session;
                [output release];
            }
        }
        else
        {
            if ([device hasTorch] )  {
                // Close flashlight
                [self.avSession stopRunning];
                self.avSession = nil;
            }
        }
    }
    else
    {
        if ([device hasTorch])
        {
            if (![self isTorchOn])
            {
                [self changeTorchMode:[NSNumber numberWithInteger:AVCaptureTorchModeOn]];
            }
            else
            {
                [self changeTorchMode:[NSNumber numberWithInteger:AVCaptureTorchModeOff]];
            }
        }
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    self.avSession = nil;
    
    [super dealloc];
}

@end
