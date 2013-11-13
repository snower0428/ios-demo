//
//  ResultAction.h
//  ZXing
//
//  Created by Christian Brunschen on 28/05/2008.
/*
 * Copyright 2008 ZXing authors
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

#import <UIKit/UIKit.h>

//type action
typedef enum ItemType
{
	URLType = 10,
	OpenURLType,//urlString is the same
	NameType,
	PhoneNumbersType,
	NoteType,
	EmailType,
	EmailToType,
	AddressType,
	OrganizationType,
	JobTitleType,
	WeiBoStrType,
	LocationType,
	SMSNumberType,
	SMSBodyType,
	SMSNumberBodyType,
}ItemType;

@interface ItemAction : NSObject{
	ItemType itemType;
	NSString *iconImage;
	NSString *nameStr;
	id itemData;//NSString or NSArray
}
@property (nonatomic,assign) ItemType itemType;
@property (nonatomic,copy) NSString *iconImage;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,retain) id itemData;//NSString or NSArray
@end

@interface ResultAction : NSObject {

}
- (UIImage *)getIconImage;
- (NSMutableArray *)propertys;
- (NSInteger)propertyCounts;
- (NSString *)title;
- (void)performActionWithController:(UIViewController *)controller
                      shouldConfirm:(bool)confirm;

@end
