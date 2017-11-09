//
//  OFStatusBarNotificationCenter.m
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import "OFStatusBarNotificationCenter.h"

#import "OFStatusBarNotificationBoardView.h"
#import "OFStatusBarNotificationContextView.h"

@interface OFStatusBarNotificationCenter ()

@property (nonatomic, strong) NSMutableArray <OFStatusBarNotification *>*pendingQueue;
@property (nonatomic, strong) NSMutableArray <OFStatusBarNotification *>*displayingQueue;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation OFStatusBarNotificationCenter

+ (instancetype)sharedCenter {
    static OFStatusBarNotificationCenter *_center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _center = [[self alloc] init];
    });
    return _center;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    _setting = [[OFStatusBarNotificationSetting alloc] init];
    _displayingQueue = [[NSMutableArray alloc] init];
    _pendingQueue = [[NSMutableArray alloc] init];
}

#pragma mark - Public
- (void)cancelAllNotifications {
    [self.pendingQueue removeAllObjects];
}

- (void)cancelNotification:(OFStatusBarNotification *)notification error:(NSError **)error {
    if (![self.pendingQueue containsObject:notification]) {
        if (error) {
            *error = [NSError errorWithDomain:OFStatusBarNotificationErrorDomain code:OFStatusBarNotificationErrorCodeUnfound userInfo:@{NSLocalizedDescriptionKey : @"未找到通知"}];
        }
        return;
    }
    
    [self.pendingQueue removeObject:notification];
}

- (void)scheduleStatusBarNotification:(OFStatusBarNotification *)notification {
    if (self.displayingQueue.count != 0) {
        if (notification.priority == OFStatusBarNotificationPriorityHigh && self.pendingQueue.count) {
            __block NSInteger insertIndex = 0;
            [self.pendingQueue enumerateObjectsUsingBlock:^(OFStatusBarNotification *obj, NSUInteger idx, BOOL *stop) {
                if (notification.priority > obj.priority) {
                    insertIndex = idx;
                    *stop = YES;
                } else {
                    insertIndex = idx + 1;
                }
            }];
            [self.pendingQueue insertObject:notification atIndex:insertIndex];
        } else {
            [self.pendingQueue addObject:notification];
        }
    } else {
        [self showNotification:notification];
    }
}

- (void)showNotification:(OFStatusBarNotification *)notification {
    if (self.dataSource &&
        [self.dataSource respondsToSelector:@selector(statusBarNotificationCenter:displayNotification:)] &&
        ([self.dataSource statusBarNotificationCenter:self displayNotification:notification] == NO)) {
        
        [self.pendingQueue removeObject:notification];
        return;
    }
    
    [self.displayingQueue addObject:notification];
    
    OFStatusBarNotificationBoardView *boardView = [[OFStatusBarNotificationBoardView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.setting.notificationBoardSize.width, self.setting.notificationBoardSize.height)];
    UIView *contentView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(statusBarNotificationCenter:viewForNotification:)]) {
        contentView = [self.dataSource statusBarNotificationCenter:self viewForNotification:notification];
    }
    if (contentView == nil) {
        OFStatusBarNotificationContextView *notifView = [[OFStatusBarNotificationContextView alloc] init];
        [notifView configWithNotification:notification];
        contentView = notifView;
    }
    [boardView addContentView:contentView];
    boardView.displayAnimationDuration = self.setting.displayAnimationDuration;
    boardView.dismissAnimationDuration = self.setting.dismissAnimationDuration;
    [boardView setWillDismissBlock:^(OFStatusBarNotificationBoardView * _Nonnull view) {
        self.timer ? dispatch_source_cancel(self.timer) : nil;
    }];
    [boardView setTapBlock:^(OFStatusBarNotificationBoardView * _Nonnull view) {
        notification.event ? notification.event(notification, OFStatusBarNotificationEventClickDown) : nil;
    }];
    [boardView setSwipeBlock:^(OFStatusBarNotificationBoardView * _Nonnull view) {
        notification.event ? notification.event(notification, OFStatusBarNotificationEventSwipeDismiss) : nil;
    }];
    [boardView display];
    
    self.timer ? dispatch_source_cancel(self.timer) : nil;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        boardView.displayingDuration = boardView.displayingDuration + 1;
        if (boardView.displayingDuration >= self.setting.minimumAutoDisplayDuration &&
            boardView.displayingDuration < self.setting.maximumAutoDisplayDuration) {
            
            if (self.pendingQueue.count) {
                [boardView dismissStyle:OFNotificationDismissStyleDissolve];
                notification.event ? notification.event(notification, OFStatusBarNotificationEventAutoDismiss) : nil;
            }
        } else if (boardView.displayingDuration >= self.setting.maximumAutoDisplayDuration) {
            [boardView dismissStyle:OFNotificationDismissStyleTranstionTop];
            notification.event ? notification.event(notification, OFStatusBarNotificationEventAutoDismiss) : nil;
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{
        [self.displayingQueue removeObject:notification];
        
        if (self.pendingQueue.count == 0) {
            return;
        }
        
        OFStatusBarNotification *nextNotif = self.pendingQueue.firstObject;
        if (nextNotif.priority == OFStatusBarNotificationPriorityHigh) {
            [self.pendingQueue removeObject:nextNotif];
            
            [self showNotification:nextNotif];
            return;
        }
        
        if (self.pendingQueue.count > self.setting.maximunNotificationWaitingCount) {
            NSArray *tempNotify = [self.pendingQueue copy];
            OFStatusBarNotification *mergeNotif;
            if (self.dataSource &&
                [self.dataSource respondsToSelector:@selector(statusBarNotificationCenter:mergeNotifications:)] &&
                [self.dataSource statusBarNotificationCenter:self mergeNotifications:tempNotify]) {
                mergeNotif = [self.dataSource statusBarNotificationCenter:self mergeNotifications:tempNotify];
            } else {
                mergeNotif = [[OFStatusBarNotification alloc] init];
                mergeNotif.image = self.setting.defaultBadgeImage;
                mergeNotif.content = [NSString stringWithFormat:@"您有%@条未读消息", @(tempNotify.count)];
            }
            
            [self.pendingQueue removeObjectsInArray:tempNotify];
            [self showNotification:mergeNotif];
        } else {
            [self.pendingQueue removeObject:nextNotif];
            
            [self showNotification:nextNotif];
        }
    });
    dispatch_resume(timer);
    self.timer = timer;
}

@end
