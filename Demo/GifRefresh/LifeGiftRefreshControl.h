//
//  LifeGiftRefreshControl.h
//
//  Created by guangbool on 2017/2/10.
//  Copyright © 2017年 guangbool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeGiftRefreshControlProtocol.h"
@class LifeGifRefreshControlLayout;


/**
 Gif 下拉刷新视图，默认 gif 动图 0.1s/帧
 */
@interface LifeGiftRefreshControl : UIView <LifeGiftRefreshControlProtocol>

/**
 设置布局，会更新 intrinsicContentSize
 */
@property (nonatomic) LifeGifRefreshControlLayout *layout;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (CGSize)intrinsicContentSize;

@end

/**
 布局 class
 */
@interface LifeGifRefreshControlLayout : NSObject

@property (nonatomic) CGFloat imageTop;
@property (nonatomic) CGFloat imageHeight;
@property (nonatomic) CGFloat lastUpdateDateLabelTop;
@property (nonatomic) CGFloat lastUpdateDateLabelheight;
@property (nonatomic) CGFloat lastUpdateDateLabelBottom;

@end
