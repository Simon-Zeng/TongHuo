//
//  THNetwork.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-25.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THNetwork : NSObject

@property (nonatomic, readonly) AFNetworkReachabilityManager * reachabilityManager;
@property (nonatomic, readonly) NSURL * baseURL;
@property (nonatomic, readonly) NSURL * adminURL;

@property (nonatomic, assign) BOOL isOnline;

+ (instancetype) sharedNetwork;

@end
