//
//  Goods+Access.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-7.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "Goods.h"

@interface Goods (Access)

+ (instancetype)goodWithId:(NSNumber *)identifier;

+ (instancetype)objectFromDictionary:(NSDictionary *)dict;



@end
