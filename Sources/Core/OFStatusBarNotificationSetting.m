//
//  OFStatusBarNotificationSetting.m
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import "OFStatusBarNotificationSetting.h"

@implementation OFStatusBarNotificationSetting

- (instancetype)init {
    if (self = [super init]) {
        _notificationBoardSize = [self defaultBoardSize];
        _displayAnimationDuration = 0.35f;
        _dismissAnimationDuration = 0.2f;
        _maximumAutoDisplayDuration = 10.f;
        _minimumAutoDisplayDuration = 3.f;
        _maximunNotificationWaitingCount = 4;
    }
    return self;
}

- (CGSize)defaultBoardSize {
    static CGSize _boardSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        screenSize.height = 64.f;
        _boardSize = screenSize;
    });
    return _boardSize;
}

@end
