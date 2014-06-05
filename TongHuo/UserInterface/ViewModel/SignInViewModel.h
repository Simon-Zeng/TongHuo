//
//  SignInViewModel.h
//  TongHuo
//
//  Created by zeng songgen on 14-5-30.
//  Copyright (c) 2014年 59pi. All rights reserved.
//

#import "THBasicViewModel.h"

@interface SignInViewModel : THBasicViewModel

@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;

@property (nonatomic, readonly) RACCommand * signInCommand;


-(RACSignal *)forbiddenNameSignal;

-(RACSignal *)modelIsValidSignal;


@end
