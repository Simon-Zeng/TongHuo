//
//  ShopsViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

#import "Shops.h"

@class Markets;

@interface ShopsViewModel : THBasicViewModel

@property (nonatomic, readonly) RACSignal * refreshSignal;

@property (nonatomic, strong) Markets * market;

@property (nonatomic, strong) NSString * searchString;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;
-(NSString *)titleForSection:(NSInteger)section;

-(Shops *)shopAtIndexPath:(NSIndexPath *)indexPath;

-(void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
