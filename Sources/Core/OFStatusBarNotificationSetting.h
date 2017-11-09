//
//  OFStatusBarNotificationSetting.h
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFStatusBarNotificationSetting : NSObject

@property (nonatomic, assign) NSTimeInterval displayAnimationDuration;   // default 0.35f second
@property (nonatomic, assign) NSTimeInterval dismissAnimationDuration;   // default 0.2f  second
@property (nonatomic, assign) NSTimeInterval maximumAutoDisplayDuration; // default 10.f  second
@property (nonatomic, assign) NSTimeInterval minimumAutoDisplayDuration; // default 3.f   second
@property (nonatomic, assign) NSUInteger maximunNotificationWaitingCount;// default 4
@property (nonatomic, assign) CGSize notificationBoardSize;        // default {[UIScreen mainScreen].bounds.size.width, 64}
@property (nonatomic, strong) UIImage *defaultBadgeImage;

@end
