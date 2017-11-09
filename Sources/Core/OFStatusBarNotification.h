//
//  OFStatusBarNotification.h
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OFStatusBarNotificationDefines.h"

@interface OFStatusBarNotification : NSObject {
@private
    __strong NSMutableDictionary *_userInfo;
}

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong, readonly) NSMutableDictionary <OFStatusBarNotificationUserKey, id>*userInfo;// undefined property

// 如果 priority 是 'OFStatusBarNotificationPriorityHigh' 当等待队列达到最大值时候, 通知将不会被合并, 并且在提交队列时, 进行插队展示.
// 默认 'OFStatusBarNotificationPriorityNormal'
@property (nonatomic, assign) OFStatusBarNotificationPriority priority;

@property (nonatomic, copy) void(^event)(OFStatusBarNotification *notification, OFStatusBarNotificationEvent event);

@end
