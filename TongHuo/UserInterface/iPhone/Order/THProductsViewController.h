//
//  THOrderViewController.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "THViewController.h"

@class ProductsViewModel;

@interface THProductsViewController : THViewController

@property (nonatomic, strong) ProductsViewModel *viewModel;

@end
