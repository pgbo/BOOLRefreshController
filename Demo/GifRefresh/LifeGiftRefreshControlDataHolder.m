//
//  LifeGiftRefreshControlDataHolder.m
//
//  Created by guangbool on 2017/2/10.
//  Copyright © 2017年 guangbool. All rights reserved.
//

#import "LifeGiftRefreshControlDataHolder.h"

@interface LifeGiftRefreshControlDataHolder ()

/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation LifeGiftRefreshControlDataHolder

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        _stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        _stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}


- (void)setGifImages:(NSArray *)images forState:(BOOLRefreshControlState)state {
    if (!images) {
        [self.stateImages removeObjectForKey:@(state)];
    } else {
        self.stateImages[@(state)] = images;
    }
}

- (NSArray *)gifImagesForState:(BOOLRefreshControlState)state {
    return self.stateImages[@(state)];
}


- (void)setGifDuration:(NSTimeInterval)duration forState:(BOOLRefreshControlState)state {
    self.stateDurations[@(state)] = @(duration);
}

- (NSTimeInterval)gifDurationForState:(BOOLRefreshControlState)state {
    return ((NSNumber *)self.stateDurations[@(state)]).doubleValue;
}

@end
