//
//  OFStatusBarNotificationBoardView.m
//  OFStatusBarNotification
//
//  Created by Gene on 2017/8/30.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import "OFStatusBarNotificationBoardView.h"

@implementation OFStatusBarNotificationBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self buildTapGestureRecognizer];
        [self buildSwipeUpGestureRecognizer];
    }
    return self;
}

- (void)addContentView:(UIView *)contentView {
    if (_contentView == contentView) {
        return;
    }
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    
    _contentView = contentView;
   
    [self addSubview:_contentView];
   
    [self setNeedsUpdateConstraints];
}

#pragma mark - AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.contentView == nil) { return; }
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
}

#pragma mark - Action
- (void)handleTapGesRec:(UITapGestureRecognizer *)tagGesRec {
    [self dismissCompletion:^(OFStatusBarNotificationBoardView *view) {
        self.tapBlock ? self.tapBlock(self) : nil;
    } style:OFNotificationDismissStyleTranstionTop];
}

- (void)handleSwipeGesRec:(UISwipeGestureRecognizer *)swipeGesRec {
    [self dismissCompletion:^(OFStatusBarNotificationBoardView *view) {
        self.swipeBlock ? self.swipeBlock(self) : nil;
    } style:OFNotificationDismissStyleTranstionTop];
}

- (void)display {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    NSAssert(window != nil, @"delegate window is nil");
    self.frame = CGRectMake(0.f, -CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [window addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.displayAnimationDuration
                     animations:^()
     {
         weakSelf.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(window.bounds), CGRectGetHeight(self.bounds));
     }];
}

- (void)dismissCompletion:(void(^)(OFStatusBarNotificationBoardView *view))completion style:(OFNotificationDismissStyle)style {
    self.willDismissBlock ? self.willDismissBlock(self) : nil;
    [UIView animateWithDuration:self.dismissAnimationDuration
                     animations:^()
     {
         switch (style) {
             case OFNotificationDismissStyleDissolve:
             {
                 self.alpha = 0.f;
             }
                 break;
             default:
             case OFNotificationDismissStyleTranstionTop:
             {
                 self.frame = CGRectMake(0.f, -CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
             }
                 break;
         }
     }
                     completion:^(BOOL finished)
     {
         completion ? completion(self) : nil;
         self.dismissedBlock ? self.dismissedBlock(self) : nil;
         [self removeFromSuperview];
     }];
}

- (void)dismissStyle:(OFNotificationDismissStyle)style {
    [self dismissCompletion:nil style:style];
}

- (void)buildTapGestureRecognizer {
    UITapGestureRecognizer *tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesRec:)];
    [self addGestureRecognizer:tapGesRec];
}

- (void)buildSwipeUpGestureRecognizer {
    UISwipeGestureRecognizer *swipeGesRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesRec:)];
    [self addGestureRecognizer:swipeGesRec];
}

@end
