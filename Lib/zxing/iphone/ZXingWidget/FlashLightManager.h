//
//  FlashLightManager.h
//  ZXingWidget
//
//  Created by leihui on 13-8-29.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FlashLightManager : NSObject
{
    AVCaptureSession    *_avSession;
}

@property (nonatomic, retain) AVCaptureSession *avSession;

+ (FlashLightManager *)shareInstance;
- (void)toggleTorch;
- (BOOL)isTorchOn;

@end
