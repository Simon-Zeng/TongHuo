//
//  ScanPostViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-17.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@class Product;

@interface ScanPostViewModel : THBasicViewModel

@property (nonatomic, strong) Product * product;

- (BOOL)isPostValid:(NSString *)post;

@end
