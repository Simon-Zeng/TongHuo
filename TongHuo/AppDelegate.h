//
//  AppDelegate.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-23.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) JASidePanelController *sidePanelController;

+ (UINavigationController *)rootNavigationController;

+ (void)logout;

@end
