//
//  LifeGiftRefreshControlDataHolder.h
//
//  Created by guangbool on 2017/2/10.
//  Copyright © 2017年 guangbool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOOLRefreshController.h"

@interface LifeGiftRefreshControlDataHolder : NSObject

- (void)setGifImages:(NSArray *)images forState:(BOOLRefreshControlState)state;
- (NSArray *)gifImagesForState:(BOOLRefreshControlState)state;

- (void)setGifDuration:(NSTimeInterval)duration forState:(BOOLRefreshControlState)state;
- (NSTimeInterval)gifDurationForState:(BOOLRefreshControlState)state;

@end
