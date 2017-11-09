//
//  OFStatusBarNotificationContextView.m
//  OFStatusBarNotification
//
//  Created by Gene on 2017/9/1.
//  Copyright © 2017年 CHOJD.COM All rights reserved.
//

#import "OFStatusBarNotificationContextView.h"

#import "OFStatusBarNotification.h"

@interface OFStatusBarNotificationContextView ()

@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation OFStatusBarNotificationContextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self buildMaskView];
        [self buildImageView];
        [self buildContentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.bounds) / 2.f;
}

#pragma mark - Public
- (void)configWithNotification:(OFStatusBarNotification *)notification {
    _notification = notification;
    
    self.imageView.image = notification.image;
    self.contentLabel.text = notification.content;
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - Auto Layout
- (void)updateConstraints {
    [super updateConstraints];
    
    // mask view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:-20]];
    
    // image view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeTop multiplier:1.f constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeLeft multiplier:1.f constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1.f constant:0]];
    
    // content label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeRight multiplier:1.f constant:6.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTop multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeRight multiplier:1.f constant:-6]];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Builder
- (void)buildMaskView {
    UIView *maskView = [[UIView alloc] init];
    maskView.translatesAutoresizingMaskIntoConstraints = NO;
    maskView.backgroundColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.f];
    [self addSubview:maskView];
    self.maskView = maskView;
}

- (void)buildImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)buildContentLabel {
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    contentLabel.font = [UIFont systemFontOfSize:12.f];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.numberOfLines = 1.f;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

@end
