//
//  AddContactAction.m
//  ZXing
//
//  Created by Christian Brunschen on 29/05/2008.
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

#import "AddContactAction.h"
#import "AddressBook/AddressBook.h"


@implementation AddContactAction

@synthesize name;
@synthesize phoneNumbers;
@synthesize note;
@synthesize email;
@synthesize urlString;
@synthesize address;
@synthesize organization;
@synthesize jobTitle;

@synthesize weiBoStr;
@synthesize jobStr;
@synthesize faxStr;
@synthesize zipCodeStr;

+ (id)actionWithName:(NSString *)n
        phoneNumbers:(NSArray *)nums
               email:(NSString *)em
                 url:(NSString *)us
             address:(NSString *)ad
                note:(NSString *)nt
        organization:(NSString *)org
            jobTitle:(NSString *)title
			DivWeiBo:(NSString *)weiBo
              TilJob:(NSString *)job
		   FaxNumber:(NSString *)fax
           ZipCode:(NSString *)zipCode
{
  AddContactAction *aca = [[[self alloc] init] autorelease];
  aca.name = n;
  aca.phoneNumbers = nums;
  aca.email = em;
  aca.urlString = us;
  aca.address = ad;
  aca.note = nt;
  aca.organization = org;
  aca.jobTitle = title;
	
  aca.weiBoStr = weiBo;
  aca.jobStr = job;
	
  aca.faxStr = fax;
  aca.zipCodeStr = zipCode;

  return aca;
}

- (NSString *)title {
  return self.name;
}

- (void) addContactWithController:(UIViewController *)controller {

  CFErrorRef *error = NULL;
  NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
	NSLog(@"addContactWithController begin create");
  ABRecordRef person = ABPersonCreate();
  NSLog(@"person create name:%@",name);
  NSRange commaRange = [name rangeOfString:@","];
  if (commaRange.location != NSNotFound) {
    NSString *lastName = [[name substringToIndex:commaRange.location] 
                          stringByTrimmingCharactersInSet:whitespaceSet];
    ABRecordSetValue(person, kABPersonLastNameProperty, lastName, error);
    NSArray *firstNames = [[[name substringFromIndex:commaRange.location + commaRange.length]
                            stringByTrimmingCharactersInSet:whitespaceSet] 
                           componentsSeparatedByCharactersInSet:whitespaceSet];
    ABRecordSetValue(person, kABPersonFirstNameProperty, [firstNames objectAtIndex:0], error);
    for (unsigned i = 1; i < [firstNames count]; i++) {
      ABRecordSetValue(person, kABPersonMiddleNameProperty, [firstNames objectAtIndex:1], error);
    }
  } else {
    NSArray *nameParts = [name componentsSeparatedByCharactersInSet:whitespaceSet];
    int nParts = nameParts.count;
    if (nParts == 1) {
      ABRecordSetValue(person, kABPersonLastNameProperty, name, error);
    } else if (nParts >= 2) {
      int lastPart = nParts - 1;
      ABRecordSetValue(person, kABPersonLastNameProperty, [nameParts objectAtIndex:0], error);
      for (int i = 1; i < lastPart; i++) {
        ABRecordSetValue(person, kABPersonMiddleNameProperty, [nameParts objectAtIndex:i], error);
      }
      ABRecordSetValue(person, kABPersonFirstNameProperty, [nameParts objectAtIndex:lastPart], error);
    }
  }
    NSLog(@"person self.note:%@",self.note);
  if (self.note) {
	  NSString *noteStr = self.note;
	  if (noteStr&&self.weiBoStr) {
		  noteStr = [noteStr stringByAppendingFormat:@" %@",self.weiBoStr];
	  }
    ABRecordSetValue(person, kABPersonNoteProperty, noteStr, error);
  }
  NSLog(@"person self.organization:%@",self.organization);
  if (self.organization) {
    ABRecordSetValue(person, kABPersonOrganizationProperty, (CFStringRef)self.organization, error);
  }
   NSLog(@"person self.jobTitle:%@",self.jobTitle);
  if (self.jobTitle) {
    ABRecordSetValue(person, kABPersonJobTitleProperty, (CFStringRef)self.jobTitle, error);
  }
  if ((!self.jobTitle)&&self.jobStr) {
	ABRecordSetValue(person, kABPersonJobTitleProperty, (CFStringRef)self.jobStr, error);
  }
   NSLog(@"person self.phoneNumbers:%@",self.phoneNumbers);
  if (self.phoneNumbers && self.phoneNumbers.count > 0) {
    // multi-values: nultiple phone numbers
    ABMutableMultiValueRef phoneNumberMultiValue = 
    ABMultiValueCreateMutable(kABStringPropertyType);
    for (NSString *number in self.phoneNumbers) {
		if ([number length]<11) {
			ABMultiValueAddValueAndLabel(phoneNumberMultiValue, number, 
										 kABPersonPhoneMobileLabel, NULL);
		}else{
			ABMultiValueAddValueAndLabel(phoneNumberMultiValue, number, 
										 kABPersonPhoneMobileLabel, NULL);
		}
      
    }
    ABRecordSetValue(person, kABPersonPhoneProperty,
                     phoneNumberMultiValue, error);
    CFRelease(phoneNumberMultiValue);
  }
	  NSLog(@"person self.faxStr:%@",self.faxStr);
	if (self.faxStr) {
		ABMutableMultiValueRef phoneNumberMultiValue = 
		ABMultiValueCreateMutable(kABStringPropertyType);	
		ABMultiValueAddValueAndLabel(phoneNumberMultiValue, self.faxStr, 
											 kABPersonPhoneWorkFAXLabel, NULL);			
		ABRecordSetValue(person, kABPersonPhoneProperty,
						 phoneNumberMultiValue, error);
		CFRelease(phoneNumberMultiValue);
	}
     NSLog(@"person self.email:%@",self.email);
  if (self.email) {
    // a single email address
    ABMutableMultiValueRef emailMultiValue = 
    ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(emailMultiValue, self.email, 
                                 kABHomeLabel, NULL);
    ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, error);
    CFRelease(emailMultiValue);
  }
  NSLog(@"person self.urlString:%@",self.urlString);
  if (self.urlString) {
    // a single url as the home page
    ABMutableMultiValueRef urlMultiValue = 
    ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(urlMultiValue, self.urlString,
                                 kABPersonHomePageLabel, NULL);
    ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, error);
    CFRelease(urlMultiValue);
  }
  NSLog(@"person self.address:%@",self.address);
  if (self.address) {
    // we can't parse all the possible address formats, alas, so we punt by putting
    // the entire thing into a multi-line 'street' address.
    // This won't look great on the phone, but at least the info will be there, 
    // and can be syned to a desktop computer, adjusted as necessary, and so on.
    
    // split the address into parts at each comma or return
    NSArray *parts =
        [self.address componentsSeparatedByCharactersInSet:
         [NSCharacterSet characterSetWithCharactersInString:@",;\r\n"]];
    NSMutableArray *strippedParts = [NSMutableArray arrayWithCapacity:[parts count]];
    // for each part:
    for (NSString *part in parts) {
      // strip the part of whitespace
      NSString *strippedPart =
          [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      if ([strippedPart length] > 0) {
        // if there is anything in this address part, add it to the list of stripped parts
        [strippedParts addObject:strippedPart];
      }
    }
    // finally, create a 'street' address by concatenating all the stripped parts, separated by linefeeds
    NSString *street = [strippedParts componentsJoinedByString:@"\n"];

    CFMutableDictionaryRef addressDict =
        CFDictionaryCreateMutable(NULL, 
                                  2,//modify by ygf 
                                  &kCFTypeDictionaryKeyCallBacks, 
                                  &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(addressDict, kABPersonAddressStreetKey, street);
	if (self.zipCodeStr) {
		 CFDictionarySetValue(addressDict, kABPersonAddressZIPKey, self.zipCodeStr);
	}
	
    
    ABMutableMultiValueRef addressMultiValue = 
        ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(addressMultiValue, 
                                 addressDict, 
                                 kABHomeLabel, 
                                 NULL);
    ABRecordSetValue(person, kABPersonAddressProperty, addressMultiValue, error);
    CFRelease(addressMultiValue);
    CFRelease(addressDict);
  }
#if 0
  NSLog(@"ABUnknownPersonViewController begin");
  ABUnknownPersonViewController *unknownPersonViewController = 
  [[ABUnknownPersonViewController alloc] init];
  NSLog(@"ABUnknownPersonViewController person");
  unknownPersonViewController.displayedPerson = person;
  unknownPersonViewController.allowsActions = false;//modify by ygf for facetime information
  unknownPersonViewController.allowsAddingToAddressBook = true;
  unknownPersonViewController.unknownPersonViewDelegate = self;
  NSLog(@"ABUnknownPersonViewController delegate");
  CFRelease(person);
	NSLog(@"push begin:%@",controller);
	viewController = [controller retain];
	if ([viewController isKindOfClass:[UINavigationController class]])
		[(UINavigationController *)viewController pushViewController:unknownPersonViewController animated:YES];
	else if ([viewController isKindOfClass:[UIViewController class]])
		[[viewController navigationController] pushViewController:unknownPersonViewController animated:YES];
	
	[unknownPersonViewController release];
#else	
	NSLog(@"ABPersonViewController begin");
	ABNewPersonViewController *personViewController = 
	[[ABNewPersonViewController alloc] init];
	NSLog(@"ABPersonViewController person");
	personViewController.displayedPerson = person;
	personViewController.newPersonViewDelegate = self;
	NSLog(@"ABUnknownPersonViewController delegate");
	CFRelease(person);
	NSLog(@"push begin:%@",controller);
	viewController = [controller retain];
	if ([viewController isKindOfClass:[UINavigationController class]])
		[(UINavigationController *)viewController pushViewController:personViewController animated:YES];
	else if ([viewController isKindOfClass:[UIViewController class]])
		[[viewController navigationController] pushViewController:personViewController animated:YES];
	[personViewController release];
#endif

  

	NSLog(@"push end");
}

- (void)performAction:(UIViewController *)controller
{
	viewController = controller;
	[self addContactWithController:controller];
}
- (void)postMsgExit
{
	[[NSNotificationCenter defaultCenter] postNotificationName:ReleaseMainCtrlNotification object:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	NSLog(@"alertView begin");
  if (buttonIndex != [alertView cancelButtonIndex]) {
	  NSLog(@"addContactWithController begin");
	  [[viewController navigationController] setNavigationBarHidden:NO];
    // perform the action
    [self addContactWithController:viewController];	 
	    NSLog(@"addContactWithController end");
	//added by ygf towdimcode
	//[self performSelector:@selector(postMsgExit) withObject:nil afterDelay:0.5f];
  }else{
	  //added by ygf towdimcode
	  [self performSelector:@selector(postMsgExit) withObject:nil afterDelay:0.5f];
  }
}

//#ifdef CONFIRM_ADDING_CONTACT
//#undef CONFIRM_ADDING_CONTACT
//#endif
- (void)performActionWithController:(UIViewController *)controller 
                      shouldConfirm:(bool)confirm {
//#ifdef CONFIRM_ADDING_CONTACT 
  if (confirm) {//crash
	  NSLog(@"performActionWithController begin");
    viewController = controller;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:NSLocalizedString(@"AddContactAction alert message", @"Add Contact?") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") 
                                              otherButtonTitles:NSLocalizedString(@"confirm", @"Add Contact"), nil];
    [alertView show];
    [alertView release];
	  NSLog(@"performActionWithController end");
  } else {
//#endif
	  NSLog(@"addContactWithController begin");
	[[viewController navigationController] setNavigationBarHidden:NO];
    [self addContactWithController:controller];
	 
	  NSLog(@"addContactWithController end");
	  //added by ygf towdimcode
	  //[self performSelector:@selector(postMsgExit) withObject:nil afterDelay:0.5f];
//#ifdef CONFIRM_ADDING_CONTACT    
  }
//#endif
	//modify by ygf twodimcode
}

- (void)dismissUnknownPersonViewController {
	NSLog(@"dismissUnknownPersonViewController begin");
  [[viewController navigationController] popToViewController:viewController animated:YES];
  [viewController release];
  viewController = nil;
}

// ABUnknownPersonViewControllerDelegate

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonViewController
                 didResolveToPerson:(ABRecordRef)person {
  if (person) {
    [self performSelector:@selector(dismissUnknownPersonViewController) withObject:nil afterDelay:0.0];
  }
}
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
	NSLog(@"newPersonViewController delegate");
	
	[self performSelector:@selector(dismissUnknownPersonViewController) withObject:nil afterDelay:0.0];
	
	return;
}
- (NSMutableArray *)propertys
{
	NSMutableArray *arrProperty = [NSMutableArray arrayWithCapacity:10];
	ItemAction *itemAction;
	if (name) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NameType;
		itemAction.iconImage = @"addContact.png";
		itemAction.nameStr = @"AddContactActionName";
		itemAction.itemData = name;
		[arrProperty addObject:itemAction];
	}
	if (jobTitle) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = JobTitleType;
		itemAction.iconImage = @"jobIcon.png";
		itemAction.nameStr = @"AddContactActionJobTitle";
		itemAction.itemData = jobTitle;
		[arrProperty addObject:itemAction];
	}
	if (!jobTitle&&jobStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = JobTitleType;
		itemAction.iconImage = @"jobIcon.png";
		itemAction.nameStr = @"AddContactActionJobStr";
		itemAction.itemData = jobStr;
		[arrProperty addObject:itemAction];
	}
	if (phoneNumbers&&[phoneNumbers count]) {		
		for (NSUInteger index=0; index <[phoneNumbers count]; index++) {
			NSString *phoneNumber = [phoneNumbers objectAtIndex:index];
			if (phoneNumber) {
				itemAction = [[[ItemAction alloc] init] autorelease];
				itemAction.itemType = PhoneNumbersType;
				if (index == 0) {
					itemAction.iconImage = @"mobile.png";
					if ([itemAction.nameStr length]>=11) {
						itemAction.nameStr = @"AddContactActionMobilePhone";
					}else{
						itemAction.nameStr = @"AddContactActionPhoneNumbers";
					}
					
				}else{
					itemAction.iconImage = @"callPhone.png";
					itemAction.nameStr = @"AddContactActionPhoneNumbers";
				}
				
				
				itemAction.itemData = phoneNumber;
				[arrProperty addObject:itemAction];
			}			
		}		
	}
	
	if (email) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = EmailType;
		itemAction.iconImage = @"sendMail.png";
		itemAction.nameStr = @"EmailActionRecipient";
		itemAction.itemData = email;
		[arrProperty addObject:itemAction];
	}
	if (urlString) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = OpenURLType;
		itemAction.iconImage = @"td_openLink.png";
		itemAction.nameStr = @"OpenUrlActionURL";
		itemAction.itemData = urlString;
		[arrProperty addObject:itemAction];
	}
	if (address) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = AddressType;
		itemAction.iconImage = @"showMap.png";
		itemAction.nameStr = @"AddContactActionAddress";
		itemAction.itemData = address;
		[arrProperty addObject:itemAction];
	}
	
	if (organization) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = OrganizationType;
		itemAction.iconImage = @"company.png";
		itemAction.nameStr = @"AddContactActionOrganization";
		itemAction.itemData = organization;
		[arrProperty addObject:itemAction];
	}
	if (faxStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"division.png";
		itemAction.nameStr = @"AddContactActionFaxStr";
		itemAction.itemData = faxStr;
		[arrProperty addObject:itemAction];
	}
	if (zipCodeStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = NoteType;
		itemAction.iconImage = @"division.png";
		itemAction.nameStr = @"AddContactActionZipCodeStr";
		itemAction.itemData = zipCodeStr;
		[arrProperty addObject:itemAction];
	}
	if (weiBoStr) {
		itemAction = [[[ItemAction alloc] init] autorelease];
		itemAction.itemType = WeiBoStrType;
		itemAction.iconImage = @"division.png";
		//DIV 可能是部门，或者微博:twitter,qq,sina,wangyi,sohu,facebook
		NSRange searchRange0 = [weiBoStr rangeOfString:@"@sina" options:NSCaseInsensitiveSearch];
		NSRange searchRange1 = [weiBoStr rangeOfString:@"@qq" options:NSCaseInsensitiveSearch];
		if ((searchRange0.location != NSNotFound)||(searchRange1.location != NSNotFound)) {
			itemAction.nameStr = @"WeiBoString";
		}else{
			itemAction.nameStr = @"AddContactActionWeiBoStr";
		}
		itemAction.itemData = weiBoStr;
		[arrProperty addObject:itemAction];
	}
	
	if (note) {
		BOOL res = NO;
		NSArray *array = [note componentsSeparatedByString:@":"];
		if ([array count]>1) {
			for (NSUInteger index = 0; index < [array count]; ) {
				NSString *strItem = [array objectAtIndex:index];
				strItem = [strItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				NSString *strItem1 = @"";
				if ((index%2 == 0)&&([strItem compare:@"MSN" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
					if ((index+1) < [array count]) {
						strItem1 = [array objectAtIndex:index+1];
						itemAction = [[[ItemAction alloc] init] autorelease];
						itemAction.itemType = NoteType;
						itemAction.iconImage = @"division.png";
						itemAction.nameStr = @"MSN";
						itemAction.itemData = strItem1;
						[arrProperty addObject:itemAction];
						res = YES;
					}					
				}
				if ((index%2 == 0)&&([strItem compare:@"QQ" options:NSCaseInsensitiveSearch] == NSOrderedSame)){
					if ((index+1) < [array count]) {
						strItem1 = [array objectAtIndex:index+1];
						itemAction = [[[ItemAction alloc] init] autorelease];
						itemAction.itemType = NoteType;
						itemAction.iconImage = @"division.png";
						itemAction.nameStr = @"QQ";
						itemAction.itemData = strItem1;
						[arrProperty addObject:itemAction];
						res = YES;
					}					
				}
				if ((index%2 == 0)&&([strItem compare:@"yahoo" options:NSCaseInsensitiveSearch] == NSOrderedSame)){
					if ((index+1) < [array count]) {
						strItem1 = [array objectAtIndex:index+1];
						itemAction = [[[ItemAction alloc] init] autorelease];
						itemAction.itemType = NoteType;
						itemAction.iconImage = @"division.png";
						itemAction.nameStr = @"Yahoo";
						itemAction.itemData = strItem1;
						[arrProperty addObject:itemAction];
						res = YES;
					}					
				}
				index ++;
			}
		}
		
		if (!res) {
			itemAction = [[[ItemAction alloc] init] autorelease];
			itemAction.itemType = NoteType;
			itemAction.iconImage = @"copyText.png";
			itemAction.nameStr = @"AddContactActionPhoneNote";
			itemAction.itemData = note;
			[arrProperty addObject:itemAction];
		}
	}
		
	
	
	
	return arrProperty;
}
- (NSInteger)propertyCounts{
	return [[self propertys] count];
}
- (void)dealloc {
  [name release];
  [phoneNumbers release];
  [note release];
  [email release];
  [urlString release];
  [address release];
  [organization release];
	[jobTitle release];
	
  [weiBoStr release];
  [jobStr release];
  [super dealloc];
}
@end
