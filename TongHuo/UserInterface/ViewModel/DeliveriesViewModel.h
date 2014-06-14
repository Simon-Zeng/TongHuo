//
//  FaHuoViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

#import "Orders.h"

@interface DeliveriesViewModel : THBasicViewModel

@property (nonatomic, readonly) RACSignal * refreshSignal;
@property (nonatomic, readonly) RACSignal * synchronizeSignal;


@property (nonatomic, strong) NSNumber * state;
@property (nonatomic, strong) NSString * searchString;


-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;
-(Orders *)orderAtIndexPath:(NSIndexPath *)indexPath;

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
