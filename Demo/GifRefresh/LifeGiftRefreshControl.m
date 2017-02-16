//
//  LifeGiftRefreshControl.m
//
//  Created by guangbool on 2017/2/10.
//  Copyright © 2017年 guangbool. All rights reserved.
//

#import "LifeGiftRefreshControl.h"
#import "LifeGiftRefreshControlDataHolder.h"

@interface LifeGiftRefreshControl ()

@property (nonatomic) UIImageView *gifView;
@property (nonatomic) UILabel *lastUpdatedTimeLabel;

@property (nonatomic) NSLayoutConstraint *gifViewTopConstraint;
@property (nonatomic) NSLayoutConstraint *gifViewHeightConstraint;
@property (nonatomic) NSLayoutConstraint *lastUpdatedTimeLabelTopConstraint;
@property (nonatomic) NSLayoutConstraint *lastUpdatedTimeLabelHeightConstraint;
@property (nonatomic) NSLayoutConstraint *lastUpdatedTimeLabelBottomConstraint;

@property (nonatomic) LifeGiftRefreshControlDataHolder *dataHolder;
@property (nonatomic) NSDate *lastRefreshDate;

@end

@implementation LifeGiftRefreshControl

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.gifView];
    [self addSubview:self.lastUpdatedTimeLabel];
    
    self.gifView.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastUpdatedTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    id views = NSDictionaryOfVariableBindings(_gifView, _lastUpdatedTimeLabel);
    
    self.gifViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.gifView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.layout.imageTop];
    [self addConstraint:self.gifViewTopConstraint];
    
    self.gifViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.gifView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.layout.imageHeight];
    [self addConstraint:self.gifViewHeightConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_gifView]-8-|" options:0 metrics:nil views:views]];
    
    self.lastUpdatedTimeLabelTopConstraint = [NSLayoutConstraint constraintWithItem:self.lastUpdatedTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.gifView attribute:NSLayoutAttributeBottom multiplier:1 constant:self.layout.lastUpdateDateLabelTop];
    [self addConstraint:self.lastUpdatedTimeLabelTopConstraint];
    
    self.lastUpdatedTimeLabelBottomConstraint = [NSLayoutConstraint constraintWithItem:self.lastUpdatedTimeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.layout.lastUpdateDateLabelBottom];
    [self addConstraint:self.lastUpdatedTimeLabelBottomConstraint];
    
    self.lastUpdatedTimeLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.lastUpdatedTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:self.lastUpdatedTimeLabelHeightConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_lastUpdatedTimeLabel]-8-|" options:0 metrics:nil views:views]];
    
    [self updateLastUpdatedTimeLabelPreferredMaxLayoutWidth];
    [self updateLastRefreshDateLabelText];
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        gifView.contentMode = UIViewContentModeCenter;
        _gifView = gifView;
    }
    return _gifView;
}

- (UILabel *)lastUpdatedTimeLabel
{
    if (!_lastUpdatedTimeLabel) {
        _lastUpdatedTimeLabel = [[UILabel alloc] init];
        _lastUpdatedTimeLabel.numberOfLines = 0;
        _lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        _lastUpdatedTimeLabel.textColor = [UIColor grayColor];
        _lastUpdatedTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lastUpdatedTimeLabel;
}

- (LifeGiftRefreshControlDataHolder *)dataHolder {
    if (!_dataHolder) {
        _dataHolder = [[LifeGiftRefreshControlDataHolder alloc] init];
    }
    return _dataHolder;
}

- (void)setLayout:(LifeGifRefreshControlLayout *)layout {
    _layout = layout;
    
    self.gifViewTopConstraint.constant = layout.imageTop;
    self.gifViewHeightConstraint.constant = layout.imageHeight;
    self.lastUpdatedTimeLabelTopConstraint.constant = layout.lastUpdateDateLabelTop;
    self.lastUpdatedTimeLabelHeightConstraint.constant = layout.lastUpdateDateLabelheight;
    self.lastUpdatedTimeLabelBottomConstraint.constant = -layout.lastUpdateDateLabelBottom;
    
    [self invalidateIntrinsicContentSize];
}

- (CGFloat)heightOfLastUpdatedTimeLabelIntrinsicHeight {
    return [self.lastUpdatedTimeLabel intrinsicContentSize].height;
}

- (void)updateLastUpdatedTimeLabelPreferredMaxLayoutWidth {
    _lastUpdatedTimeLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 16;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self updateLastUpdatedTimeLabelPreferredMaxLayoutWidth];
}

- (void)updateLastRefreshDateLabelText {
    NSString *updateTimeText = nil;
    
    // 2.格式化日期
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
    });
    if (self.lastRefreshDate) {
        updateTimeText = [NSString stringWithFormat:@"上次更新%@", [formatter stringFromDate:self.lastRefreshDate]];
    } else {
        updateTimeText = @"将要更新";
    }
    
    self.lastUpdatedTimeLabel.text = updateTimeText;
}

#pragma mark - LifeGiftRefreshControlProtocol

- (void)stateWillChangeFromCurrent:(BOOLRefreshControlState)fromCurrentState toState:(BOOLRefreshControlState)toState {
    
}

- (void)stateDidChangedFromOld:(BOOLRefreshControlState)fromOldState toCurrentState:(BOOLRefreshControlState)toCurrentState {
    
    if (toCurrentState == BOOLRefreshControlRefreshing) {
        self.lastRefreshDate = [NSDate date];
        [self updateLastRefreshDateLabelText];
    }
    
    if (toCurrentState != BOOLRefreshControlStateIdle) {
        
        NSArray *images = [self.dataHolder gifImagesForState:toCurrentState];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            NSTimeInterval dur = [self.dataHolder gifDurationForState:toCurrentState];
            if (dur <= 0) dur = (0.1 * images.count);
            self.gifView.animationDuration = dur;
            [self.gifView startAnimating];
        }
    } else {
        [self.gifView stopAnimating];
    }
}

- (void)animateWhenFinishRefresh {
    // do nothing
}

- (void)pullingPercentChangeTo:(CGFloat)pullingPercent {
    
    NSArray *pullingImages = [self.dataHolder gifImagesForState:BOOLRefreshControlPulling];
    NSUInteger imagesCount = pullingImages.count;
    if (imagesCount <= 0) return;
    
    // 停止动画
    [self.gifView stopAnimating];
    
    // 设置当前需要显示的图片
    NSUInteger index =  imagesCount * pullingPercent;
    if (index >= imagesCount) index = imagesCount - 1;
    self.gifView.image = pullingImages[index];
    
}

- (void)setGifImages:(NSArray *)images forState:(BOOLRefreshControlState)state {
    [self.dataHolder setGifImages:images forState:state];
}

- (void)setGifDuration:(NSTimeInterval)duration forState:(BOOLRefreshControlState)state {
    [self.dataHolder setGifDuration:duration forState:state];
}

- (CGSize)intrinsicContentSize {
    CGFloat height = 0;
    height += self.gifViewTopConstraint.constant;
    height += self.gifViewHeightConstraint.constant;
    height += self.lastUpdatedTimeLabelTopConstraint.constant;
    height += self.lastUpdatedTimeLabelHeightConstraint.constant;
    height += (-self.lastUpdatedTimeLabelBottomConstraint.constant);
    
    return CGSizeMake(CGRectGetWidth(self.frame), height);
}

@end

@implementation LifeGifRefreshControlLayout

@end
