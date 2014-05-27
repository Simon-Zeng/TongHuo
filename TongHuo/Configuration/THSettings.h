//
//  THSettings.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THSettings : NSObject

@property (nonatomic, readonly) NSString * documentDirectoryPathString;
@property (nonatomic, readonly) NSURL * documentDirectoryPathURL;

@property (nonatomic, readonly) NSString * applicationDataSupportDirectoryPathString;
@property (nonatomic, readonly) NSURL * applicationDataSupportDirectoryPathURL;

@property (nonatomic, readonly) NSString * tempDirectoryPathString;
@property (nonatomic, readonly) NSURL * tempDirectoryPathURL;


+ (instancetype) sharedSettings;

@end
