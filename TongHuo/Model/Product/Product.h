//
//  Product.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-8.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * dates;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * createtime;

@end
