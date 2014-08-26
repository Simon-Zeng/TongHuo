//
//  ModelService.h
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelService : NSObject

+ (NSTimeInterval)timeForQuery;

+ (void)parseAndSaveOrders:(NSDictionary *)response;

@end
