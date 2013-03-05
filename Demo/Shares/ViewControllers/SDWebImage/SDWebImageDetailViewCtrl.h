//
//  SDWebImageDetailViewCtrl.h
//  Demo
//
//  Created by lei hui on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDWebImageDetailViewCtrl : UIViewController
{
    NSURL           *_imageURL;
    UIImageView     *_imageView;
}

@property(nonatomic, retain) NSURL *imageURL;

@end
