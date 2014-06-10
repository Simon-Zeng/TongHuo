//
//  UploadViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@class Goods;

@interface UploadViewModel : THBasicViewModel

@property (nonatomic, strong) Goods * good;


@property (nonatomic, strong) NSNumber * tid;
@property (nonatomic, strong) NSString * sellerCode;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * title;

@property (nonatomic, readonly) RACCommand * uploadCommand;

-(RACSignal *)modelIsValidSignal;

@end