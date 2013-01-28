//
//  BabyInputViewCtrl.h
//  ToDo
//
//  Created by leihui on 12-10-23.
//
//

#import <UIKit/UIKit.h>


typedef enum
{
    BabyInputActionTypePreBirth     = 200,  // 预产期
    BabyInputActionTypeLastMenses   = 201,  // 最后月经时间
    BabyInputActionTypeDate         = 202,  // 选择日期
    BabyInputActionTypeNext         = 203,  // 下一步
    BabyInputActionTypePrince       = 204,  // 王子
    BabyInputActionTypePrincess     = 205,  // 公主
}BabyInputActionType;

typedef enum
{
    BabyDateTypeNone        = -1,
    BabyDateTypePreBirth    = 0,    // 预产期
    BabyDateTypeLastMenses  = 1,    // 最后月经时间
    BabyDateTypeHasBaby     = 2,    // 有宝宝
}BabyDateType;

@interface BabyInputViewCtrl : UIViewController
{
    UIImageView         *_imageViewSun;
    UIImageView         *_imageViewBg;
    UIImageView         *_imageViewDateBg;
    
    UIButton            *_btnPreBirth;
    UIButton            *_btnLastMenses;
    UIButton            *_btnNext;
    
    UIButton            *_btnPrince;
    UIButton            *_btnPrincess;
    
    UILabel             *_lableDate;
    UIButton            *_btnDate;
    
    BOOL                _hasBaby;           // 是否有宝宝
    BOOL                _isLastMensesDate;  // 是否是最后月经时间
    
    NSInteger           _preBirthYear;      // 预产期年、月、日
    NSInteger           _preBirthMonth;
    NSInteger           _preBirthDay;
    
    NSInteger           _babyBirthYear;     // 宝宝出生年、月、日
    NSInteger           _babyBirthMonth;
    NSInteger           _babyBirthDay;
    
    NSString            *_preBitrhDate;
    NSString            *_lastMensesDate;
    NSString            *_babyBirthday;
    
    NSInteger           _babySex;           // 宝宝性别 0-王子　1-公主
    
    BabyDateType        _babyDateType;
}

- (id)initWithBaby:(BOOL)hasBaby;

@property(nonatomic, assign) BOOL hasBaby;

@end
