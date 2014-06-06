//
//  UINavigationBar+statusBarColor.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-6.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (statusBarColor)

@property (nonatomic, strong, setter = setStatusBarColor:, getter=statusBarColor) UIColor * statusBarColor;

@end