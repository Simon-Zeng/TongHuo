//
//  THBaseObject.h
//  TongHuo
//
//  Created by zeng songgen on 14-9-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol THManagedObjectProtocol <NSObject>

+ (NSString *)entityName;
- (NSString *)entityName;

@end

@interface THBaseObject : NSManagedObject<THManagedObjectProtocol>

@end
