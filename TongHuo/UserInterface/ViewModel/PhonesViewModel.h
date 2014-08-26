//
//  PhonesViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-8-26.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@class Product;
@class Orders;

@interface PhonesViewModel : THBasicViewModel

@property (nonatomic, strong) Product * product;


-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(Orders *)orderAtIndexPath:(NSIndexPath *)indexPath;

@end
