//
//  Utility.m
//  BomBomBom
//
//  Created by zhangtianfu on 12-2-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"
//#import "JSON.h"

@implementation Utility

#pragma mark ---------MBProgressHUD---------------------
static MBProgressHUD *kMBProgressHUDInstance = nil;

+ (void)displayProgressHUD:(NSString*)text onView:(UIView*)container{
	if (nil == kMBProgressHUDInstance) {
		kMBProgressHUDInstance = [[MBProgressHUD alloc] initWithView:container];
		kMBProgressHUDInstance.removeFromSuperViewOnHide = YES;
		[container addSubview:kMBProgressHUDInstance];
		[kMBProgressHUDInstance release];
		[kMBProgressHUDInstance show:YES];
	}
	
	kMBProgressHUDInstance.labelText = text;
}

+ (void)closeProgressHUD {
    if (kMBProgressHUDInstance) {
        [kMBProgressHUDInstance hide:YES];
        kMBProgressHUDInstance = nil;
    }
}

+ (void)setProgressHUDText:(NSString*)text{
    if (kMBProgressHUDInstance) {
        kMBProgressHUDInstance.labelText = text;
    }
}

+ (void)showText:(NSString*)text onView:(UIView*)container whileExecuting:(SEL)method onTarget:(id)target withObject:(id)object{
    MBProgressHUD *mbProgressHUD = [[MBProgressHUD alloc] initWithView:container];
    mbProgressHUD.removeFromSuperViewOnHide = YES;
    mbProgressHUD.labelText = text;
    [container addSubview:mbProgressHUD];
    [mbProgressHUD release];
    [mbProgressHUD showWhileExecuting:method onTarget:target withObject:object animated:YES];
}

#pragma mark--------------UserDefaults-----------------------------
+ (id)readUserDefaultsObjectForKey:(NSString *)key{
    NSUserDefaults *preffer = [NSUserDefaults standardUserDefaults];
    return [preffer objectForKey:key];
}

+ (void)saveUserDefaultsObject:(id)object forKey:(NSString *)key{
    NSUserDefaults *preffer = [NSUserDefaults standardUserDefaults];
    [preffer setObject:object forKey:key];
    [preffer synchronize];
}


//图标抖动
+ (void)shakeView:(UIView*)view animated:(BOOL)animated{
	if(animated){
		CABasicAnimation *theAnimation; 
		[CATransaction begin];
		theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; 
		theAnimation.duration=0.15;  
		theAnimation.repeatDuration = 100e+10;
		theAnimation.autoreverses=YES;
		theAnimation.fromValue=[NSNumber numberWithFloat:0.05]; 
		theAnimation.toValue=[NSNumber numberWithFloat:-0.05];
		[view.layer addAnimation:theAnimation forKey:@"rotation.z"];
		[CATransaction commit];
	}else{
		[view.layer removeAnimationForKey:@"rotation.z"];		
	}	
}

//检查Email是否合法
+ (BOOL)isValidEmail:(NSString *)checkString{  
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";  
    NSString *emailRegex = stricterFilterString ? stricterFilterString : laxString;  
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];  
    return [emailTest evaluateWithObject:checkString];  
}

//GUID
+ (NSString *)GUIDString{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}

//将元素对拼接成URL
+ (NSString *)URLStringFromDictionary:(NSDictionary *)dict{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator]){
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]])){
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}


//中文字数
+ (int)getChineseCharacterLength:(NSString *)text{
	int result = 0;
	int length = [text length];
	for (int i=0; i<length; ++i){
        unichar ch = [text characterAtIndex:i];
        NSString *subString = [NSString stringWithCharacters:&ch length:1];
		const char	*cString = [subString UTF8String];
		if (strlen(cString) == 3){
			result++;
		}
	}
	
	return result;
}

+ (id)jsonValueFromURLString:(NSString *)URLString error:(NSError **)error{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (data) {
        NSString *responceString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        id json = [responceString JSONValue];
        if (json) {
            return json;
        }
    }
    return nil;
}

@end
