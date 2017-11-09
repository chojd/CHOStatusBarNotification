//
//  OFStatusBarNotification.m
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import "OFStatusBarNotification.h"

@implementation OFStatusBarNotification

- (instancetype)init {
    self = [super init];
    if (self) {
        _userInfo = [NSMutableDictionary dictionaryWithCapacity:10];
        _priority = OFStatusBarNotificationPriorityNormal;
    }
    return self;
}

@end
