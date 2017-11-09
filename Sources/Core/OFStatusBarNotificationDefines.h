//
//  OFStatusBarNotificationDefines.h
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/31.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * OFStatusBarNotificationUserKey;

typedef NS_ENUM(NSUInteger, OFStatusBarNotificationEvent) {
    OFStatusBarNotificationEventClickDown = 1,
    OFStatusBarNotificationEventSwipeDismiss,
    OFStatusBarNotificationEventAutoDismiss,
};

typedef NS_ENUM(NSUInteger, OFStatusBarNotificationPriority) {
    OFStatusBarNotificationPriorityNormal,
    OFStatusBarNotificationPriorityHigh,
};

FOUNDATION_EXTERN NSString * const OFStatusBarNotificationErrorDomain;

typedef NS_ENUM(NSUInteger, OFStatusBarNotificationErrorCode) {
    OFStatusBarNotificationErrorCodeUnknow,
    OFStatusBarNotificationErrorCodeUnfound,
};
