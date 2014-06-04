//
//  MenuViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-3.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@class OrdersViewModel;
@class DeliveriesViewModel;
@class MarketsViewModel;
@class JackpotViewModel;

@interface MenuViewModel : THBasicViewModel


-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)subtitleAtIndexPath:(NSIndexPath *)indexPath;

-(THBasicViewModel *)viewModelForIndexPath:(NSIndexPath *)indexPath;

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
