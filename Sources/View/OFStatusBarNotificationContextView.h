//
//  OFStatusBarNotificationContextView.h
//  OFStatusBarNotification
//
//  Created by Gene on 2017/9/1.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OFStatusBarNotification;
@interface OFStatusBarNotificationContextView : UIView {
@private
    __weak OFStatusBarNotification *_notification;
}

@property (nullable, nonatomic, weak, readonly) OFStatusBarNotification *notification;

- (void)configWithNotification:(OFStatusBarNotification *)notification;

@end

NS_ASSUME_NONNULL_END
