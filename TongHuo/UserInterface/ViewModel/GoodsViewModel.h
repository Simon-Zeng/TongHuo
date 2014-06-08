//
//  GoodsViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

#import "Goods.h"

@class Shops;

@interface GoodsViewModel : THBasicViewModel

@property (nonatomic, readonly) RACSignal * refreshSignal;
@property (nonatomic, strong) Shops * shop;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(Goods *)goodAtIndexPath:(NSIndexPath *)indexPath;

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
