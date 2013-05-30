//
//  UIDevice+Additions.m
//  Demo
//
//  Created by hui lei on 13-1-26.
//  Copyright (c) 2013年 113. All rights reserved.
//

#import "UIDevice+Additions.h"

#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//availableMemory
#include <sys/sysctl.h>  
#include <mach/mach.h>

#define KNDWIFIID       @"01"	//ND WIFI标识
#define KNDCFUUID		@"02"	//ND cfuuid标识

static NSString *kUDID = nil;

@implementation UIDevice(Additions)

- (NSString *)udid
{
	if (kUDID) {
		return kUDID;
	}
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 50000
    NSString *udid = [self uniqueIdentifier];
#else
    NSString *udid = nil;
#endif
    
	if (udid == nil || [udid hasPrefix:@"5.0"] || [udid length] < 10) {
		//wifi
		NSString *macaddress = [[UIDevice currentDevice] macaddress];
		if (nil == macaddress) {
			//uuid
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSString *uuid = [defaults stringForKey:@"udid"];
			if (nil == uuid || [uuid length]<36) {
				//create uuid
                udid = [Utility GUIDString];
				//uuid+Base64+header
				NSString *uuidBase64 = [uuid encodeBase64];
				NSString *uuidBase64WithHeader = [KNDCFUUID stringByAppendingString:uuidBase64];
				//save to local
				[defaults setValue:uuidBase64WithHeader forKey:@"udid"];
				[defaults synchronize];
				kUDID = [uuidBase64WithHeader retain];
			} else {
				kUDID = [uuid retain];
			}
		} else {
			//wifi+Base64+header
			NSString *macaddressBase64 = [macaddress encodeBase64];
			NSString *macaddressBase64WithHeader = [KNDWIFIID stringByAppendingString:macaddressBase64];
			kUDID = [macaddressBase64WithHeader retain];
		}
	} else {
		kUDID = [udid retain];
	}
    NSLog(@"udid:%@", udid);
    
	return kUDID;
}

- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (double)availableMemory
{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

@end
