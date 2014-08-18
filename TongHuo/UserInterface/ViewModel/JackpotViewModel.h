//
//  JackpotViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@interface JackpotViewModel : THBasicViewModel

@property (nonatomic, readonly) RACCommand * shakeCommand;

@property (nonatomic, strong) NSNumber * total;

@end
