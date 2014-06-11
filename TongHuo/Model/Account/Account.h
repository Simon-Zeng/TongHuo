//
//  Account.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * loginname;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * typeName;

@end
