//
//  Platforms.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THBaseObject.h"

@interface Platforms : THBaseObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * refreshToken;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * accessToken;

@end
