//
//  Orders.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-28.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Orders : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sf;
@property (nonatomic, retain) NSString * cs;
@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSNumber * createtime;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * kno;
@property (nonatomic, retain) NSNumber * tel;
@property (nonatomic, retain) NSString * ktype;
@property (nonatomic, retain) NSNumber * tb;
@property (nonatomic, retain) NSNumber * did;

@end
