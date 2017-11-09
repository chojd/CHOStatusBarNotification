//
//  OFStatusBarNotificationBoardView.h
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OFNotificationDismissStyle) {
    OFNotificationDismissStyleTranstionTop,
    OFNotificationDismissStyleDissolve,
};

NS_ASSUME_NONNULL_BEGIN

@interface OFStatusBarNotificationBoardView : UIView {
@private
    __weak UIView *_contentView;
}

@property (nonatomic, assign) NSTimeInterval displayAnimationDuration;
@property (nonatomic, assign) NSTimeInterval dismissAnimationDuration;

@property (nonatomic, assign) NSTimeInterval displayingDuration;

@property (nonatomic, weak, readonly) UIView *contentView;

@property (nonatomic, copy) void(^willDismissBlock)(OFStatusBarNotificationBoardView *view);
@property (nonatomic, copy) void(^dismissedBlock)(OFStatusBarNotificationBoardView *view);
@property (nonatomic, copy) void(^swipeBlock)(OFStatusBarNotificationBoardView *view);
@property (nonatomic, copy) void(^tapBlock)(OFStatusBarNotificationBoardView *view);

- (void)display;
- (void)dismissStyle:(OFNotificationDismissStyle)style;
- (void)addContentView:(UIView *)view;

@end


NS_ASSUME_NONNULL_END
