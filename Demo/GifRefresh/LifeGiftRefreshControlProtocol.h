//
//  LifeGiftRefreshControlProtocol.h
//
//  Created by guangbool on 2017/2/10.
//  Copyright © 2017年 guangbool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOOLRefreshController.h"

@protocol LifeGiftRefreshControlProtocol <BOOLRefreshControlProtocol>

@optional
/**
 设置state状态下的动画图片images
 
 @param images
 @param state
 */
- (void)setGifImages:(NSArray *)images forState:(BOOLRefreshControlState)state;

/**
 设置state状态下的动画持续时间duration
 
 @param images
 @param state
 */
- (void)setGifDuration:(NSTimeInterval)duration forState:(BOOLRefreshControlState)state;

@end
