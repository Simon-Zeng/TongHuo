//
//  THHelper.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-6.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CoreAnimation.h>

@interface THHelper : NSObject

+ (void)playSound:(NSString*)filename;

+ (CAAnimationGroup *)shakeAnimationWithDuration:(float)duration;

@end
