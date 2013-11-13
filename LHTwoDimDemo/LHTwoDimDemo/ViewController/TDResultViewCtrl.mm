//
//  TDResultViewCtrl.m
//  LHTwoDimDemo
//
//  Created by leihui on 13-11-3.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "TDResultViewCtrl.h"
#import "DataMatrix.h"
#import "QREncoder.h"
#import "TDProduceViewCtrl.h"

#define kQRCodeImageViewTag     1000

@interface TDResultViewCtrl ()
{
    UIImage     *_qrCodeImage;
}

@end

@implementation TDResultViewCtrl

@synthesize strTDUrl = _strTDUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //the qrcode is square. now we make it 250 pixels wide
    int qrcodeImageDimension = 200;
    
    if (self.strTDUrl != nil) {
        //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
        DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:self.strTDUrl];
        
        //then render the matrix
        _qrCodeImage = [[QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension] retain];
        
        CGFloat top = 0.f;
        if (SYSTEM_VERSION >= 7.0) {
            top = STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT;
        }
        //put the image into the view
        UIImageView *qrcodeImageView = [[UIImageView alloc] initWithImage:_qrCodeImage];
        qrcodeImageView.tag = kQRCodeImageViewTag;
        CGRect parentFrame = self.view.frame;
        CGFloat x = (parentFrame.size.width - qrcodeImageDimension) / 2.0;
        CGFloat y = top + 10;
        CGRect qrcodeImageViewFrame = CGRectMake(x, y, qrcodeImageDimension, qrcodeImageDimension);
        [qrcodeImageView setFrame:qrcodeImageViewFrame];
        
        //and that's it!
        [self.view addSubview:qrcodeImageView];
        [qrcodeImageView release];
    }
    
    //Right items
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(onComplete)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(onSave)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:completeItem, saveItem, nil];
    [saveItem release];
    [completeItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)onComplete
{
    for (UIViewController *ctrl in self.navigationController.viewControllers) {
        if ([ctrl isKindOfClass:[TDProduceViewCtrl class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
            break;
        }
    }
}

- (void)onSave
{
    CGFloat width = 400.f;
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 37.f;
    CGFloat imageWidth = width - margin*2;
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, imageWidth, imageWidth)] autorelease];
    imageView.image = _qrCodeImage;
    [view addSubview:imageView];
    
    CGSize imageSize = view.frame.size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已保存到相册" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

#pragma mark - dealloc

- (void)dealloc
{
    self.strTDUrl = nil;
    [_qrCodeImage release];
    
    [super dealloc];
}

@end
