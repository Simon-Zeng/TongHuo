//
//  ScanPostViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-6-17.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@class Orders;

@interface ScanPostViewModel : THBasicViewModel

@property (nonatomic, strong) Orders * order;

- (BOOL)isPostValid:(NSString *)post;

@end
