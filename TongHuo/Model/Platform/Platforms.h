//
//  Platforms.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-28.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Platforms : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSNumber * uid;

@end
