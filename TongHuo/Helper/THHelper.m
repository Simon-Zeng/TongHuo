//
//  THHelper.m
//  TongHuo
//
//  Created by zeng songgen on 14-6-6.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THHelper.h"

#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation THHelper

SystemSoundID g_soundID = 0;

void systemSoundCompletionProc(SystemSoundID ssID,void *clientData)
{
	AudioServicesRemoveSystemSoundCompletion(ssID);
	AudioServicesDisposeSystemSoundID(g_soundID);
	g_soundID = 0;
}

+ (void)playSound:(NSString*)filename
{
    if(g_soundID || 0 == [filename length])
	    return;
    
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	
	NSURL *fileUrl = [NSURL fileURLWithPath:path];
	g_soundID = 0;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &g_soundID);
    
	AudioServicesAddSystemSoundCompletion(g_soundID,NULL,NULL, systemSoundCompletionProc, NULL);
	AudioServicesPlaySystemSound(g_soundID);
}


+ (CAAnimationGroup *)shakeAnimationWithDuration:(float)duration
{
    const CGFloat angle = M_PI / 4.0f;

    CGPoint anchorPoint;
    CATransform3D startTranslation;
    CATransform3D rotation;
    
    anchorPoint = CGPointMake(1.0f, 1.0);
    startTranslation = CATransform3DMakeTranslation(85, 70, 0);
    rotation = CATransform3DRotate(startTranslation, angle, 0, 0, 1.0);
    
    CABasicAnimation * outAnchorPointAnimation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    outAnchorPointAnimation.fromValue = [NSValue valueWithCGPoint:anchorPoint];
    outAnchorPointAnimation.toValue = [NSValue valueWithCGPoint:anchorPoint];
    
    CABasicAnimation * outRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    outRotationAnimation.fromValue = [NSValue valueWithCATransform3D:startTranslation];
    outRotationAnimation.toValue = [NSValue valueWithCATransform3D:rotation];
    
    CABasicAnimation * outOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outOpacityAnimation.fromValue = @1.0f;
    outOpacityAnimation.toValue = @1.0f;
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    [outAnimation setAnimations:@[outOpacityAnimation, outRotationAnimation, outAnchorPointAnimation]];
    
    outAnimation.duration = duration;
    outAnimation.repeatCount = HUGE_VALF;
    outAnimation.autoreverses = YES;
    
    return outAnimation;
}

@end
