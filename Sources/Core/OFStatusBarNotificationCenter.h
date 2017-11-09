//
//  OFStatusBarNotificationCenter.h
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OFStatusBarNotificationSetting.h"
#import "OFStatusBarNotification.h"

@protocol OFStatusBarNotificationDataSource;
@interface OFStatusBarNotificationCenter : NSObject

@property (nonatomic, strong, readonly) OFStatusBarNotificationSetting *setting;

@property (nonatomic, weak) id<OFStatusBarNotificationDataSource>dataSource;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)sharedCenter;

// if notification's priority is OFStatusBarNotificationPriorityHigh , it will not be merged
- (void)scheduleStatusBarNotification:(OFStatusBarNotification *)notif;

- (void)cancelAllNotifications;
- (void)cancelNotification:(OFStatusBarNotification *)notif error:(NSError **)error;

@end


@protocol OFStatusBarNotificationDataSource <NSObject>

@optional
// 在通知将要展示之前, 返回是否需要展示
- (BOOL)statusBarNotificationCenter:(OFStatusBarNotificationCenter *)center displayNotification:(OFStatusBarNotification *)notif;
// 自定义通知视图
- (__kindof UIView *)statusBarNotificationCenter:(OFStatusBarNotificationCenter *)center viewForNotification:(OFStatusBarNotification *)notif;
// 自定义合并等待队列中的通知, 需要展示的通知
- (OFStatusBarNotification *)statusBarNotificationCenter:(OFStatusBarNotificationCenter *)center mergeNotifications:(NSArray <OFStatusBarNotification *>*)notifications;

@end
