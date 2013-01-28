

#import <UIKit/UIKit.h>

@class LogInAlertView;

@protocol LogInAlertViewDelegate <NSObject>
- (void)logInAlertView:(LogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password;
@end

@interface LogInAlertView : UIAlertView 
{
    UITextField *userIDTextField;
    UITextField *passwordTextField;
    
//    id<UIAlertViewDelegate, LogInAlertViewDelegate> delegate;
}

@property(nonatomic, retain, readonly)  UITextField *userIDTextField;
@property(nonatomic, retain, readonly)  UITextField *passwordTextField;

//@property (nonatomic, assign) id<UIAlertViewDelegate, LogInAlertViewDelegate> delegate;

@end
