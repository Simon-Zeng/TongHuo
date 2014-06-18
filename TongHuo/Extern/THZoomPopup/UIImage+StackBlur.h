//
//  UIImage+StackBlur.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIImage (StackBlur) 
	- (UIImage*) stackBlur:(NSUInteger)radius;
    - (UIImage *) normalize ;
    + (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius;
@end

