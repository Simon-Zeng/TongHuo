//
//  THBaseObject.m
//  TongHuo
//
//  Created by zeng songgen on 14-9-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBaseObject.h"

@implementation THBaseObject

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

- (NSString *)entityName
{
    return [[self class] entityName];
}

@end
