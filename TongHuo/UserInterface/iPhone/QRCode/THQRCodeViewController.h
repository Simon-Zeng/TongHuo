//
//  THQRCodeViewController.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "THViewController.h"

@class QRCodeViewModel;

@interface THQRCodeViewController : THViewController

@property (nonatomic, strong) QRCodeViewModel *viewModel;

@end
